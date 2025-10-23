import 'package:trufi_core/models/alert.dart';
import 'package:trufi_core/models/enums/alert_severity_level_type.dart';
import 'package:trufi_core/models/enums/realtime_state.dart';
import 'package:trufi_core/models/plan_entity.dart';

class AlertEntityType {
  static const String agency = 'Agency';
  static const String route = 'Route';
  static const String pattern = 'Pattern';
  static const String stop = 'Stop';
  static const String trip = 'Trip';
  static const String stopOnRoute = 'StopOnRoute';
  static const String stopOnTrip = 'StopOnTrip';
  static const String routeType = 'RouteType';
  static const String unknown = 'Unknown';
}

abstract class AlertUtils {
  static const int defaultValidity = 5 * 60;

  static bool isAlertValid(
    AlertEntity? alert,
    double? referenceUnixTime, {
    int defaultValidity = defaultValidity,
    bool isFutureValid = false,
  }) {
    if (alert == null) {
      return false;
    }

    final effectiveStartDate = alert.effectiveStartDate;
    final effectiveEndDate = alert.effectiveEndDate;

    if (effectiveStartDate == null || referenceUnixTime == null) {
      return true;
    }

    if (isFutureValid && referenceUnixTime < effectiveStartDate) {
      return true;
    }

    return effectiveStartDate <= referenceUnixTime &&
        referenceUnixTime <=
            (effectiveEndDate ?? (effectiveStartDate + defaultValidity));
  }

  static bool cancelationHasExpired(
    double referenceUnixTime, {
    double? scheduledArrival,
    double? scheduledDeparture,
    double? serviceDay,
  }) {
    return isAlertValid(
      AlertEntity(
        effectiveStartDate: (serviceDay ?? 0) + (scheduledArrival ?? 0),
        effectiveEndDate: (serviceDay ?? 0) + (scheduledDeparture ?? 0),
      ),
      referenceUnixTime,
      isFutureValid: true,
    );
  }

  static AlertSeverityLevelTypeTrufi? getMaximumAlertSeverityLevel(
    List<AlertEntity>? alerts,
  ) {
    if (alerts == null || alerts.isEmpty) {
      return null;
    }

    final levels = <AlertSeverityLevelTypeTrufi, bool>{};

    for (var alert in alerts) {
      if (alert.alertSeverityLevel != null) {
        levels[alert.alertSeverityLevel!] = true;
      }
    }

    return levels.containsKey(AlertSeverityLevelTypeTrufi.severe)
        ? AlertSeverityLevelTypeTrufi.severe
        : levels.containsKey(AlertSeverityLevelTypeTrufi.warning)
        ? AlertSeverityLevelTypeTrufi.warning
        : levels.containsKey(AlertSeverityLevelTypeTrufi.info)
        ? AlertSeverityLevelTypeTrufi.info
        : levels.containsKey(AlertSeverityLevelTypeTrufi.unknownseverity)
        ? AlertSeverityLevelTypeTrufi.unknownseverity
        : null;
  }

  static AlertSeverityLevelTypeTrufi? getActiveAlertSeverityLevel(
    List<AlertEntity>? alerts,
    double? referenceUnixTime,
  ) {
    if (alerts == null || alerts.isEmpty) {
      return null;
    }

    final filteredAlerts = alerts
        .where((alert) => isAlertValid(alert, referenceUnixTime))
        .toList();

    return getMaximumAlertSeverityLevel(filteredAlerts);
  }

  static AlertSeverityLevelTypeTrufi? getActiveLegAlertSeverityLevel(
    PlanItineraryLeg? leg,
  ) {
    if (leg == null) {
      return null;
    }

    if (legHasCancelation(leg)) {
      return AlertSeverityLevelTypeTrufi.warning;
    }

    final List<AlertEntity> serviceAlerts = [
      ...(leg.route?.alerts ?? []),
      ...(leg.fromPlace?.stopEntity?.alerts ?? []),
      ...(leg.toPlace?.stopEntity?.alerts ?? []),
    ];

    return getActiveAlertSeverityLevel(
      serviceAlerts,
      (leg.startTime.millisecondsSinceEpoch / 1000),
    );
  }

  static bool legHasCancelation(PlanItineraryLeg? leg) {
    if (leg == null) {
      return false;
    }
    return leg.realtimeState == RealtimeStateTrufi.canceled;
  }

  static List<AlertEntity> getActiveLegAlerts(
    PlanItineraryLeg? leg,
    double legStartTime,
  ) {
    if (leg == null) {
      return [];
    }
    final routeAlerts = leg.route?.alerts?.map(
      (e) => e.copyWith(sourceAlert: 'route-alert'),
    );
    final fromStopAlerts = leg.fromPlace?.stopEntity?.alerts?.map(
      (e) => e.copyWith(sourceAlert: 'from-stop-alert'),
    );
    final toStopAlerts = leg.toPlace?.stopEntity?.alerts?.map(
      (e) => e.copyWith(sourceAlert: 'to-stop-alert'),
    );

    final List<AlertEntity> serviceAlerts = [
      ...routeAlerts ?? [],
      ...fromStopAlerts ?? [],
      ...toStopAlerts ?? [],
    ];

    return serviceAlerts
        .where((alert) => isAlertValid(alert, legStartTime))
        .toList();
  }

  static int alertSeverityCompare(AlertEntity a, AlertEntity b) {
    final List<AlertSeverityLevelTypeTrufi?> severityLevels = [
      AlertSeverityLevelTypeTrufi.info,
      AlertSeverityLevelTypeTrufi.unknownseverity,
      AlertSeverityLevelTypeTrufi.warning,
      AlertSeverityLevelTypeTrufi.severe,
    ];

    int severityLevelDifference =
        severityLevels.indexOf(b.alertSeverityLevel) -
        severityLevels.indexOf(a.alertSeverityLevel);

    return severityLevelDifference;
  }
}
