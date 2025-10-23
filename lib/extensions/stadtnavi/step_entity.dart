import 'package:trufi_core/extensions/utils/geo_utils.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/models/step_entity.dart';

extension StepEntityExtension on StepEntity {
  String distanceString(AppLocalization localization) => distance != null
      ? displayDistanceWithLocale(localization, distance!)
      : '';
}
