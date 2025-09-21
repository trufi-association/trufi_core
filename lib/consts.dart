import 'package:latlong2/latlong.dart';

class ApiConfig {
  ApiConfig._privateConstructor();

  static final ApiConfig _instance = ApiConfig._privateConstructor();

  factory ApiConfig() {
    return _instance;
  }

  String baseDomain = "otp.kigali.trufi.dev"; // For dev
  // String baseDomain = "api.stadtnavi.de"; // For PROD

  String get openTripPlannerUrl => "https://$baseDomain/otp/transmodel/v3";
  String get faresURL => "https://$baseDomain/fares";
  LatLng get originMap => LatLng(-1.96617, 30.06409);
  
  String get carpoolOffers =>
      "https://dev.stadtnavi.eu/carpool-offers"; // For dev
  // String get carpoolOffers =>
  //     "https://herrenberg.stadtnavi.de/carpool-offers"; // For PROD

  String get matomo =>
      "https://track.dev.stadtnavi.eu/matomo.php"; // For dev
  // String get matomo =>
  //     "https://track.stadtnavi.de/matomo.php"; // For PROD


  String searchPhotonEndpoint = "https://photon.komoot.io";
  // String searchPhotonEndpoint = "https://navigator.trufi.app/photon";
  
  String reverseGeodecodingPhotonEndpoint =
      "https://kigali.trufi.dev/photon/reverse/";
  String mapEndpoint = "https://kigali.trufi.dev/static-maps/trufi-liberty/";
}
