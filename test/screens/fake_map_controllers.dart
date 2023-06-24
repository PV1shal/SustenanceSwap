// A dummy implementation of the platform interface for tests.
/// Code from official repo as recommended by google_map_flutter
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:stream_transform/stream_transform.dart';

class TestGoogleMapsFlutterPlatform extends GoogleMapsFlutterPlatform {
  TestGoogleMapsFlutterPlatform();

  // The IDs passed to each call to buildView, in call order.
  List<int> createdIds = <int>[];

  // Whether `dispose` has been called.
  bool disposed = false;

  // Stream controller to inject events for testing.
  final StreamController<MapEvent<dynamic>> mapEventStreamController =
      StreamController<MapEvent<dynamic>>.broadcast();

  @override
  Future<void> init(int mapId) async {}

  @override
  Future<void> updateMapConfiguration(
    MapConfiguration update, {
    required int mapId,
  }) async {}

  @override
  Future<void> updateMarkers(
    MarkerUpdates markerUpdates, {
    required int mapId,
  }) async {}

  @override
  Future<void> updatePolygons(
    PolygonUpdates polygonUpdates, {
    required int mapId,
  }) async {}

  @override
  Future<void> updatePolylines(
    PolylineUpdates polylineUpdates, {
    required int mapId,
  }) async {}

  @override
  Future<void> updateCircles(
    CircleUpdates circleUpdates, {
    required int mapId,
  }) async {}

  @override
  Future<void> updateTileOverlays({
    required Set<TileOverlay> newTileOverlays,
    required int mapId,
  }) async {}

  @override
  Future<void> clearTileCache(
    TileOverlayId tileOverlayId, {
    required int mapId,
  }) async {}

  @override
  Future<void> animateCamera(
    CameraUpdate cameraUpdate, {
    required int mapId,
  }) async {}

  @override
  Future<void> moveCamera(
    CameraUpdate cameraUpdate, {
    required int mapId,
  }) async {}

  @override
  Future<void> setMapStyle(
    String? mapStyle, {
    required int mapId,
  }) async {}

  @override
  Future<LatLngBounds> getVisibleRegion({
    required int mapId,
  }) async {
    return LatLngBounds(
        southwest: const LatLng(0, 0), northeast: const LatLng(0, 0));
  }

  @override
  Future<ScreenCoordinate> getScreenCoordinate(
    LatLng latLng, {
    required int mapId,
  }) async {
    return const ScreenCoordinate(x: 0, y: 0);
  }

  @override
  Future<LatLng> getLatLng(
    ScreenCoordinate screenCoordinate, {
    required int mapId,
  }) async {
    return const LatLng(0, 0);
  }

  @override
  Future<void> showMarkerInfoWindow(
    MarkerId markerId, {
    required int mapId,
  }) async {}

  @override
  Future<void> hideMarkerInfoWindow(
    MarkerId markerId, {
    required int mapId,
  }) async {}

  @override
  Future<bool> isMarkerInfoWindowShown(
    MarkerId markerId, {
    required int mapId,
  }) async {
    return false;
  }

  @override
  Future<double> getZoomLevel({
    required int mapId,
  }) async {
    return 0.0;
  }

  @override
  Future<Uint8List?> takeSnapshot({
    required int mapId,
  }) async {
    return null;
  }

  @override
  Stream<CameraMoveStartedEvent> onCameraMoveStarted({required int mapId}) {
    return mapEventStreamController.stream.whereType<CameraMoveStartedEvent>();
  }

  @override
  Stream<CameraMoveEvent> onCameraMove({required int mapId}) {
    return mapEventStreamController.stream.whereType<CameraMoveEvent>();
  }

  @override
  Stream<CameraIdleEvent> onCameraIdle({required int mapId}) {
    return mapEventStreamController.stream.whereType<CameraIdleEvent>();
  }

  @override
  Stream<MarkerTapEvent> onMarkerTap({required int mapId}) {
    return mapEventStreamController.stream.whereType<MarkerTapEvent>();
  }

  @override
  Stream<InfoWindowTapEvent> onInfoWindowTap({required int mapId}) {
    return mapEventStreamController.stream.whereType<InfoWindowTapEvent>();
  }

  @override
  Stream<MarkerDragStartEvent> onMarkerDragStart({required int mapId}) {
    return mapEventStreamController.stream.whereType<MarkerDragStartEvent>();
  }

  @override
  Stream<MarkerDragEvent> onMarkerDrag({required int mapId}) {
    return mapEventStreamController.stream.whereType<MarkerDragEvent>();
  }

  @override
  Stream<MarkerDragEndEvent> onMarkerDragEnd({required int mapId}) {
    return mapEventStreamController.stream.whereType<MarkerDragEndEvent>();
  }

  @override
  Stream<PolylineTapEvent> onPolylineTap({required int mapId}) {
    return mapEventStreamController.stream.whereType<PolylineTapEvent>();
  }

  @override
  Stream<PolygonTapEvent> onPolygonTap({required int mapId}) {
    return mapEventStreamController.stream.whereType<PolygonTapEvent>();
  }

  @override
  Stream<CircleTapEvent> onCircleTap({required int mapId}) {
    return mapEventStreamController.stream.whereType<CircleTapEvent>();
  }

  @override
  Stream<MapTapEvent> onTap({required int mapId}) {
    return mapEventStreamController.stream.whereType<MapTapEvent>();
  }

  @override
  Stream<MapLongPressEvent> onLongPress({required int mapId}) {
    return mapEventStreamController.stream.whereType<MapLongPressEvent>();
  }

  @override
  void dispose({required int mapId}) {
    disposed = true;
  }

  @override
  Widget buildViewWithConfiguration(
    int creationId,
    PlatformViewCreatedCallback onPlatformViewCreated, {
    required MapWidgetConfiguration widgetConfiguration,
    MapObjects mapObjects = const MapObjects(),
    MapConfiguration mapConfiguration = const MapConfiguration(),
  }) {
    onPlatformViewCreated(0);
    createdIds.add(creationId);
    return Container();
  }
}
