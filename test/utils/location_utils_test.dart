import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:urban_sketchers/utils/location_utils.dart';

Position get mockPosition => Position(
      latitude: 52.561270,
      longitude: 5.639382,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        500,
        isUtc: true,
      ),
      altitude: 3000.0,
      accuracy: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

final mockLocation = Location(
  latitude: 52.2165157,
  longitude: 6.9437819,
  timestamp: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
);

final mockPlacemark = Placemark(
    administrativeArea: 'Overijssel',
    country: 'Netherlands',
    isoCountryCode: 'NL',
    locality: 'Enschede',
    name: 'Gronausestraat',
    postalCode: '',
    street: 'Gronausestraat 710',
    subAdministrativeArea: 'Enschede',
    subLocality: 'Enschmarke',
    subThoroughfare: '',
    thoroughfare: 'Gronausestraat');

void main() {
  group('Geolocator testing', () {
    setUp(() {
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
    });
    test('checkPermission', () async {
      final permission = await Geolocator.checkPermission();

      expect(permission, LocationPermission.whileInUse);
    });

    test('requestPermission', () async {
      final permission = await Geolocator.requestPermission();

      expect(permission, LocationPermission.whileInUse);
    });

    test('getCurrentPosition testing', () async {
      final position = await getCurrentLocation();
      expect(position, mockPosition);
    });
  });
  group('Geocoding', () {
    setUp(() {
      GeocodingPlatform.instance = MockGeocodingPlatform();
    });

    test('locationFromAddress', () async {
      final loc = await (getLocationFromAddress('500 Wall ST seattle'));
      double latitude = loc.latitude;
      double longitude = loc.longitude;

      expect(latitude, mockLocation.latitude);
      expect(longitude, mockLocation.longitude);

      expect(() async => await (getLocationFromAddress("")),
          throwsA(isA<ArgumentError>()));
    });

    test('placemarkFromCoordinates', () async {
      final address = await (getAddress(0, 0));
      expect(address, 'Gronausestraat, Enschmarke, Enschede, , Netherlands');
    });
  });
}

class MockGeocodingPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        GeocodingPlatform {
  @override
  Future<List<Location>> locationFromAddress(
    String address, {
    String? localeIdentifier,
  }) async {
    return [mockLocation];
  }

  @override
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    String? localeIdentifier,
  }) async {
    return [mockPlacemark];
  }
}

class MockGeolocatorPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        GeolocatorPlatform {
  @override
  Future<LocationPermission> checkPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<LocationPermission> requestPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<bool> isLocationServiceEnabled() => Future.value(true);

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) =>
      Future.value(mockPosition);

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() =>
      Future.value(LocationAccuracyStatus.reduced);

  @override
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) =>
      Future.value(LocationAccuracyStatus.reduced);

  @override
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #getPositionStream,
        null,
        <Symbol, Object?>{
          #desiredAccuracy: locationSettings?.accuracy ?? LocationAccuracy.best,
          #distanceFilter: locationSettings?.distanceFilter ?? 0,
          #timeLimit: locationSettings?.timeLimit ?? 0,
        },
      ),
      returnValue: Stream.value(mockPosition),
    );
  }

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    return super.noSuchMethod(
      Invocation.method(
        #getServiceStatusStream,
        null,
      ),
      returnValue: Stream.value(ServiceStatus.enabled),
    );
  }
}
