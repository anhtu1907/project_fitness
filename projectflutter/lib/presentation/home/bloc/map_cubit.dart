import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:projectflutter/presentation/home/bloc/map_state.dart';
import 'package:http/http.dart' as http;

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(LoadingMap());
  final Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  final List<LatLng> _path = [];
  DateTime? _startTime;
  DateTime? _endTime;
  Future<void> startTracking() async {
    try {
      // Lấy vị trí hiện tại khi dùng app
      final locationData = await _getCurrentPosition();
      final currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      // final LocationData newLocation;
      _path.clear();
      _path.add(currentLocation);
      _startTime = DateTime.now();

      //kcal = MET × weight(kg) × time(hour) Tính khối lượng đã tiêu hao trong một lần chạy
      //( 1 bảng chứa các thông tin MET, 1 bảng sẽ lưu lại các thông số như userid, s, v,t,kcal)
      const double zoom = 13.0;
      emit(DisplayMap(
          center: currentLocation,
          zoom: zoom,
          currentLocation: currentLocation,
          path: List.from(_path)));

      _locationSubscription?.cancel();
      _locationSubscription = location.onLocationChanged.listen((newData) {
        // newLocation = LatLng(newData.latitude!, newData.longitude!);
        const newLocation = LatLng(10.8198175, 106.6415405);
        _path.add(newLocation);
        emit(DisplayMap(
            center: newLocation,
            zoom: zoom,
            currentLocation: newLocation,
            path: List.from(_path)));
      });

      // Tổng hợp đoạn đường từ bắt đầu đến kết thúc
      List<LatLng> routePath = await getRouteFromOSRM(currentLocation.latitude,
          currentLocation.longitude, 10.8198175, 106.6415405);
      _path.clear();
      _path.addAll(routePath);

      emit(DisplayMap(
        center: routePath.last,
        zoom: zoom,
        currentLocation: routePath.last,
        path: List.from(_path),
      ));
      _endTime = DateTime.now();

      // Return Duration(2:30:00)
      final duration = _endTime!.difference(_startTime!);
      final hours = duration.inSeconds / 3600;
      // Tính toán quãng đường
      double distanceKm = calculateDistance(routePath) / 1000;
      final avarageSpeed = distanceKm / hours;
      print("Distance: ${distanceKm.toStringAsFixed(2)} km");
      print("Time: $hours h");
      print("Speed: ${avarageSpeed.toStringAsFixed(1)} km/h");
    } catch (err) {
      emit(LoadMapFailure(errorMessage: err.toString()));
    }
  }

  // Future<void> stopTracking() async {
  //   _locationSubscription?.cancel();
// _locationSubscription = location.onLocationChanged.listen((newData) {
//         // final newLocation = LatLng(newData.latitude!, newData.longitude!);
//         const newLocation = LatLng(10.8198175, 106.6415405);
//         _path.add(newLocation);
//         _endTime = DateTime.now();
//         emit(DisplayMap(
//             center: newLocation,
//             zoom: zoom,
//             currentLocation: newLocation,
//             path: List.from(_path)));
//       });
  //   final duration = _endTime!.difference(_startTime!);
  //     final hours = duration.inSeconds / 3600;
  //     // Tính toán quãng đường
  //     double distanceKm = calculateDistance(_path) / 1000;
  //     final avarageSpeed = distanceKm / hours;
  //     print("Distance: ${distanceKm.toStringAsFixed(2)} km");
  //     print("Time: ${hours} h");
  //     print("Speed: ${avarageSpeed.toStringAsFixed(1)} km/h");
  // }

// Theo dõi và tạo đường line chính xác
  Future<List<LatLng>> getRouteFromOSRM(
      double startLat, double startLng, double endLat, double endLng) async {
    // Lấy API từ link
    final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$startLng,$startLat;$endLng,$endLat?overview=full&geometries=geojson');
    // Thông tin tuyến đường
    final response = await http.get(url);
    print('Resposne: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final routeCoordinates =
          data['routes'][0]['geometry']['coordinates'] as List;

      List<LatLng> path = [];
      for (var coord in routeCoordinates) {
        path.add(LatLng(coord[1], coord[0]));
      } // 1 is latitude, 0 is longtitude
      return path;
    } else {
      throw Exception('Failed to load route');
    }
  }

  // Người dùng có muốn bật định vị lên không
  Future<LocationData> _getCurrentPosition() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // Bật Popup hỏi người dùng có muốn bật không
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }
    }

    //Kiểm tra xem ứng dụng của bạn có được cấp quyền truy cập vị trí
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission denied');
      }
    }
    return await location.getLocation();
  }

  // Tránh lãng phí tài nguyên
  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }

  double calculateDistance(List<LatLng> path) {
    final Distance distance = Distance();
    double totalDistance = 0.0;
    for (int i = 0; i < path.length - 1; i++) {
      totalDistance += distance(path[i], path[i + 1]);
    }
    return totalDistance;
  }
}
