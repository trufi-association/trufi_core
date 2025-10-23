import 'package:flutter/material.dart';
import 'package:trufi_core/models/enums/transport_mode.dart';
import 'package:trufi_core/models/plan_entity.dart';

extension PlanEntityExtension on PlanEntity {
  Widget get iconSecondaryPublic {
    if ((itineraries ?? []).isNotEmpty) {
      final publicModes = itineraries![0].legs
          .where(
            (element) =>
                element.transportMode != TransportMode.walk &&
                element.transportMode != TransportMode.bicycle &&
                element.transportMode != TransportMode.car,
          )
          .toList();
      if (publicModes.isNotEmpty) {
        return Container(
          decoration: BoxDecoration(
            color: publicModes[0].route?.color != null
                ? Color(
                    int.tryParse("0xFF${publicModes[0].route!.color!}") ?? 0,
                  )
                : publicModes[0].transportMode.color,
          ),
          child: publicModes[0].transportMode.getImage(color: Colors.white),
        );
      }
    }
    return Container();
  }

  bool get isOnlyWalk =>
      (itineraries?.isEmpty ?? true) ||
      itineraries!.length == 1 &&
          itineraries![0].legs.length == 1 &&
          itineraries![0].legs[0].transportMode == TransportMode.walk;

  bool get isOutSideLocation {
    return false;
    // return planInfoBox == PlanInfoBox.originOutsideService ||
    //     planInfoBox == PlanInfoBox.destinationOutsideService;
  }
}
