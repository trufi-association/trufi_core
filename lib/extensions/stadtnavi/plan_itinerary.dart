import 'package:trufi_core/extensions/utils/geo_utils.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/models/enums/leg_mode.dart';
import 'package:trufi_core/models/enums/transport_mode.dart';
import 'package:trufi_core/models/plan_entity.dart';
import 'package:trufi_core/models/utils/plan_itinerary_leg_utils.dart';
import 'package:trufi_core/widgets/utils/date_time_utils.dart';
import 'stadtnavi_extensions.dart';
import 'package:collection/collection.dart';

extension PlanItineraryExtension on PlanItinerary {
  double get totalDistance => sumDistances(legs);

  String durationFormat(AppLocalization localization) =>
      DateTimeUtils.durationToStringMinutes(duration);

  String get startTimeHHmm => DateTimeUtils.durationToHHmm(startTime);

  String get endTimeHHmm => DateTimeUtils.durationToHHmm(endTime);

  List<PlanItineraryLeg> get compressLegs {
    final usingOwnBicycle = legs.any(
      (leg) =>
          getLegModeByKey(leg.transportMode.name) == LegMode.bicycle &&
          leg.rentedBike == false,
    );
    final compressedLegs = <PlanItineraryLeg>[];
    PlanItineraryLeg? compressedLeg;
    for (final PlanItineraryLeg currentLeg in legs) {
      if (compressedLeg == null) {
        compressedLeg = currentLeg.copyWith();
        continue;
      }
      if (currentLeg.intermediatePlaces != null) {
        compressedLegs.add(compressedLeg);
        compressedLeg = currentLeg.copyWith();
        continue;
      }

      if (usingOwnBicycle && continueWithBicycle(compressedLeg, currentLeg)) {
        final newBikePark =
            compressedLeg.toPlace?.bikeParkEntity ??
            currentLeg.toPlace?.bikeParkEntity;
        compressedLeg = compressedLeg.copyWith(
          duration: compressedLeg.duration + currentLeg.duration,
          distance: compressedLeg.distance + currentLeg.distance,
          toPlace: currentLeg.toPlace?.copyWith(bikeParkEntity: newBikePark),
          endTime: currentLeg.endTime,
          mode: TransportMode.bicycle.name,
          accumulatedPoints: [
            ...compressedLeg.accumulatedPoints,
            ...currentLeg.accumulatedPoints,
          ],
        );
        continue;
      }

      if (currentLeg.rentedBike != null &&
          continueWithRentedBicycle(compressedLeg, currentLeg) &&
          !bikingEnded(currentLeg)) {
        compressedLeg = compressedLeg.copyWith(
          duration: compressedLeg.duration + currentLeg.duration,
          distance: compressedLeg.distance + currentLeg.distance,
          toPlace: currentLeg.toPlace,
          endTime: currentLeg.endTime,
          mode: LegMode.bicycle.name,
          accumulatedPoints: [
            ...compressedLeg.accumulatedPoints,
            ...currentLeg.accumulatedPoints,
          ],
        );
        continue;
      }

      if (usingOwnBicycle &&
          getLegModeByKey(compressedLeg.mode) == LegMode.walk) {
        compressedLeg = compressedLeg.copyWith(mode: LegMode.bicycleWalk.name);
      }

      compressedLegs.add(compressedLeg);
      compressedLeg = currentLeg.copyWith();

      if (usingOwnBicycle && getLegModeByKey(currentLeg.mode) == LegMode.walk) {
        compressedLeg = compressedLeg.copyWith(mode: LegMode.bicycleWalk.name);
      }
    }
    if (compressedLeg != null) {
      compressedLegs.add(compressedLeg);
    }

    return compressedLegs;
  }

  int get totalDurationItinerary {
    return endTime.difference(startTime).inSeconds;
  }

  int getNumberIcons(double renderBarThreshold) {
    final routeShorts = compressLegs.where((leg) {
      final legLength = (leg.durationIntLeg / totalDurationItinerary) * 10;
      if (!(legLength < renderBarThreshold && leg.isLegOnFoot) &&
          leg.toPlace?.bikeParkEntity != null) {
        return true;
      } else if (leg.transportMode == TransportMode.car &&
          leg.toPlace?.carParkEntity != null) {
        return true;
      } else if (leg.transportMode == TransportMode.bicycle &&
          leg.toPlace?.bikeParkEntity != null &&
          !(legLength < renderBarThreshold && leg.isLegOnFoot)) {
        return true;
      }
      return false;
    }).toList();
    return routeShorts.length;
  }

  int getNumberLegHide(double renderBarThreshold) {
    return compressLegs
        .where((leg) {
          final legLength = (leg.durationIntLeg / totalDurationItinerary) * 10;
          return legLength < renderBarThreshold &&
              leg.transportMode != TransportMode.walk;
        })
        .toList()
        .length;
  }

  int getNumberLegTime(double renderBarThreshold) {
    return compressLegs.fold(0, (previousValue, element) {
      final legLength = (element.durationIntLeg / totalDurationItinerary) * 10;
      return legLength < renderBarThreshold
          ? previousValue + element.durationIntLeg
          : previousValue;
    });
  }

  String firstLegStartTime(AppLocalization localization) {
    final firstDeparture = compressLegs.firstWhereOrNull(
      (element) => element.transitLeg,
    );
    String legStartTime = '';
    if (firstDeparture != null) {
      if (firstDeparture.rentedBike ?? false) {
        legStartTime = "localization.departureBikeStation";
        // legStartTime = localization.departureBikeStation(
        //   firstDeparture.startTimeString,
        //   firstDeparture.fromPlace?.name ?? '',
        // );
        if (firstDeparture.fromPlace?.bikeRentalStation?.bikesAvailable !=
            null) {
          legStartTime =
              '$legStartTime ${firstDeparture.fromPlace?.bikeRentalStation?.bikesAvailable} ${"localization.commonBikesAvailable"}';
        }
      } else {
        final String firstDepartureStopType =
            firstDeparture.transportMode == TransportMode.rail ||
                firstDeparture.transportMode == TransportMode.subway
            ? "localization.commonFromStation"
            : "localization.commonFromStop";
        final String firstDeparturePlatform =
            firstDeparture.fromPlace?.stopEntity?.platformCode != null
            ? (firstDeparture.transportMode == TransportMode.rail
                      ? ', ${"localizationST.commonTrack"} '
                      : ', ${"localizationST.commonPlatform"} ') +
                  (firstDeparture.fromPlace?.stopEntity?.platformCode ?? '')
            : '';
        legStartTime =
            "${"localization.commonLeavesAt"} ${"firstDeparture.startTimeString"} $firstDepartureStopType ${firstDeparture.fromPlace?.name} $firstDeparturePlatform";
      }
    } else {
      legStartTime = "localization.commonItineraryNoTransitLegs";
    }

    return legStartTime;
  }

  double get totalWalkingDistance => getTotalWalkingDistance(compressLegs);

  Duration get totalWalkingDuration =>
      Duration(seconds: getTotalWalkingDuration(compressLegs).toInt());

  Duration get totalBikingDuration =>
      Duration(seconds: getTotalBikingDuration(compressLegs).toInt());

  String getDistanceString(AppLocalization localization) =>
      displayDistanceWithLocale(localization, distance.toDouble());

}
