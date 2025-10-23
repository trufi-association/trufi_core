import 'package:flutter/material.dart';
import 'package:trufi_core/extensions/stadtnavi_models/enums_plan/enums_plan.dart';
import 'package:trufi_core/extensions/utils/geo_utils.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/models/enums/transport_mode.dart';
import 'package:trufi_core/models/plan_entity.dart';
import 'package:trufi_core/widgets/utils/date_time_utils.dart';

extension PlanItineraryLegExtension on PlanItineraryLeg {
  int get durationIntLeg {
    return endTime.difference(startTime).inSeconds;
  }

  bool get isLegOnFoot =>
      transportMode == TransportMode.walk || mode == 'BICYCLE_WALK';

  String get startTimeString => DateTimeUtils.durationToHHmm(startTime);

  String get endTimeString => DateTimeUtils.durationToHHmm(endTime);

  Color get backgroundColor {
    return route?.color != null
        ? Color(int.tryParse('0xFF${route?.color}')!)
        : transportMode.backgroundColor;
  }

  Color get primaryColor {
    return transportMode == TransportMode.bicycle &&
            fromPlace?.bikeRentalStation != null
        ? getBikeRentalNetwork(fromPlace!.bikeRentalStation!.networks?[0]).color
        : route?.color != null
        ? Color(int.tryParse('0xFF${route?.color}')!)
        : transportMode.color;
  }

  String get nameTransport {
    return route?.shortName ?? (route?.longName ?? (shortName ?? ''));
  }

  String distanceString(AppLocalization localization) =>
      displayDistanceWithLocale(localization, distance);

  String durationLeg(AppLocalization localization) =>
      DateTimeUtils.durationToStringMinutes(duration);

  String get headSign {
    return transportMode == TransportMode.carPool
        ? toPlace?.name ?? ''
        : stopStart;
  }

  String get stopStart {
    return trip?.tripHeadsign ?? route?.longName ?? '';
  }
}
