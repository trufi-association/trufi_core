import 'package:flutter/material.dart';
import 'package:trufi_core/extensions/stadtnavi_models/enums_plan/icons/relative_directions_icons.dart';

enum RelativeDirectionTrufi {
  depart,
  hardLeft,
  left,
  slightlyLeft,
  continue_,
  slightlyRight,
  right,
  hardRight,
  circleClockwise,
  circleCounterclockwise,
  elevator,
  uturnLeft,
  uturnRight,
  enterStation,
  exitStation,
  followSigns,
}

RelativeDirectionTrufi getRelativeDirectionByString(String direction) {
  return RelativeDirectionExtension.names.keys.firstWhere(
    (key) => key.name == direction,
    orElse: () => RelativeDirectionTrufi.continue_,
  );
}

extension RelativeDirectionExtension on RelativeDirectionTrufi {
  static const names = <RelativeDirectionTrufi, String>{
    RelativeDirectionTrufi.depart: 'DEPART',
    RelativeDirectionTrufi.hardLeft: 'HARD_LEFT',
    RelativeDirectionTrufi.left: 'LEFT',
    RelativeDirectionTrufi.slightlyLeft: 'SLIGHTLY_LEFT',
    RelativeDirectionTrufi.continue_: 'CONTINUE',
    RelativeDirectionTrufi.slightlyRight: 'SLIGHTLY_RIGHT',
    RelativeDirectionTrufi.right: 'RIGHT',
    RelativeDirectionTrufi.hardRight: 'HARD_RIGHT',
    RelativeDirectionTrufi.circleClockwise: 'CIRCLE_CLOCKWISE',
    RelativeDirectionTrufi.circleCounterclockwise: 'CIRCLE_COUNTERCLOCKWISE',
    RelativeDirectionTrufi.elevator: 'ELEVATOR',
    RelativeDirectionTrufi.uturnLeft: 'UTURN_LEFT',
    RelativeDirectionTrufi.uturnRight: 'UTURN_RIGHT',
    RelativeDirectionTrufi.enterStation: 'ENTER_STATION',
    RelativeDirectionTrufi.exitStation: 'EXIT_STATION',
    RelativeDirectionTrufi.followSigns: 'FOLLOW_SIGNS',
  };
  static Widget? _images(RelativeDirectionTrufi transportMode, Color? color) {
    switch (transportMode) {
      case RelativeDirectionTrufi.depart:
        return iconInstructionStraightSvg;
      case RelativeDirectionTrufi.hardLeft:
        return iconInstructionSharpTurnLeftSvg;
      case RelativeDirectionTrufi.left:
        return iconInstructionTurnLeftSvg;
      case RelativeDirectionTrufi.slightlyLeft:
        return iconInstructionTurnSlightLeftSvg;
      case RelativeDirectionTrufi.continue_:
        return iconInstructionStraightSvg;
      case RelativeDirectionTrufi.slightlyRight:
        return iconInstructionTurnSlightRightSvg;
      case RelativeDirectionTrufi.right:
        return iconInstructionTurnRightSvg;
      case RelativeDirectionTrufi.hardRight:
        return iconInstructionSharpTurnRightSvg;
      case RelativeDirectionTrufi.circleClockwise:
        return iconInstructionRoundaboutLeftSvg;
      case RelativeDirectionTrufi.circleCounterclockwise:
        return iconInstructionRoundaboutLeftSvg;
      case RelativeDirectionTrufi.elevator:
        return iconInstructionElevatorSvg;
      case RelativeDirectionTrufi.uturnLeft:
        return iconInstructionUTurnLeftSvg;
      case RelativeDirectionTrufi.uturnRight:
        return iconInstructionUTurnRightSvg;
      case RelativeDirectionTrufi.enterStation:
        return iconInstructionEnterStationSvg;
      case RelativeDirectionTrufi.exitStation:
        return iconInstructionExitStationSvg;
      case RelativeDirectionTrufi.followSigns:
        return iconInstructionFollowSignsSvg;
      // ignore: unreachable_switch_default
      default:
        return null;
    }
  }

  String get name => names[this] ?? 'CONTINUE';
  
  Widget getImage({Color? color, double size = 24}) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      child: FittedBox(
        child:
            _images(this, color) ?? const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
