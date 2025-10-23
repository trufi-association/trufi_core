import 'package:latlong2/latlong.dart';
import 'package:trufi_core/repositories/location/interfaces/i_location_search_service.dart';
import 'package:trufi_core/repositories/location/services/stadtnavi_photon_location_search_service.dart';

class ApiConfig {
  ApiConfig._privateConstructor();
  static final ApiConfig _instance = ApiConfig._privateConstructor();
  factory ApiConfig() => _instance;

  String _baseDomain = "otp.kigali.trufi.dev";
  String _otpPath = "/otp/transmodel/v3";
  String _carpoolOffers = "https://herrenberg.stadtnavi.de/carpool-offers";
  String _faresURL = "/fares";
  LatLng _originMap = const LatLng(-1.96617, 30.06409);
  ILocationSearchService _iLocationSearchService =
      StadtnaviPhotonLocationSearchService(
        photonUrl: "https://photon.komoot.io",
      );

  String get baseDomain => _baseDomain;
  String get openTripPlannerUrl => "https://$_baseDomain$_otpPath";
  String get carpoolOffers => _carpoolOffers;
  String get faresURL => _faresURL;
  LatLng get originMap => _originMap;
  ILocationSearchService get locationSearchService => _iLocationSearchService;

  void configure({
    String? baseDomain,
    String? otpPath,
    String? carpoolOffers,
    String? faresURL,
    LatLng? originMap,
    ILocationSearchService? locationSearchService,
  }) {
    _baseDomain = baseDomain ?? _baseDomain;
    _otpPath = otpPath ?? _otpPath;
    _carpoolOffers = carpoolOffers ?? _carpoolOffers;
    _faresURL = faresURL ?? _faresURL;
    _originMap = originMap ?? _originMap;
    _iLocationSearchService = locationSearchService ?? _iLocationSearchService;
  }
}
