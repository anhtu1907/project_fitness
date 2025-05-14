import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:projectflutter/presentation/home/bloc/map_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/map_state.dart';

class RunMapPage extends StatelessWidget {
  const RunMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    return BlocProvider(
      create: (context) => MapCubit()..startTracking(),
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          if (state is LoadingMap) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LoadMapFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          if (state is DisplayMap) {
            return Stack(children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                    initialCenter: state.center,
                    initialZoom: state.zoom,
                    maxZoom: 18.0,
                    minZoom: 5.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    )),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  if (state.currentLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                            point: state.currentLocation!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ))
                      ],
                    ),
                  if (state.path.isNotEmpty)
                    PolylineLayer(polylines: [
                      Polyline(
                          points: state.path,
                          strokeWidth: 4.0,
                          color: Colors.blueAccent)
                    ])
                ],
              ),
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      mapController.move(state.currentLocation!, state.zoom);
                    },
                    child: const Icon(Icons.my_location),
                  ))
            ]);
          }
          return Container();
        },
      ),
    );
  }
}
