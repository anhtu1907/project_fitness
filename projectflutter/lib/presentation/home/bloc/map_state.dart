import 'package:latlong2/latlong.dart';

abstract class MapState {}

class LoadingMap extends MapState {}

class DisplayMap extends MapState {
  final LatLng center;
  final double zoom;
  final LatLng? currentLocation;
  final List<LatLng> path;

  DisplayMap(
      {required this.center,
      required this.zoom,
      this.currentLocation,
      required this.path});
}

class LoadMapFailure extends MapState {
  final String errorMessage;
  LoadMapFailure({required this.errorMessage});
}
