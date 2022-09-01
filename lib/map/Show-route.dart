import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_restart/kuksa/class-provider.dart';
import 'package:test_restart/kuksa/class.dart';
import 'package:test_restart/map/bottom-card.dart';
import 'package:test_restart/map/turnNavigation.dart';

class NavigationHome extends ConsumerWidget {
  final List<LatLng> polyLine;
  String CurrAddress;
  String Duration;
  num Distance;
  // final List<LatLng> currPolyLineList;
  // double mapRotation;
  // LatLng mapCenter;
  // double? mapZoom;
  // double? pathStroke;
  NavigationHome({
    Key? key,
    required this.polyLine,
    required this.CurrAddress,
    required this.Duration,
    required this.Distance,
    // required this.currPolyLineList,
    // required this.mapRotation,
    // required this.mapCenter,
    // this.mapZoom,
    // this.pathStroke,
  }) : super(key: key);

  // LatLng src = LatLng(31.71, 76.95);

  // LatLng des = LatLng(31.781456, 76.997469);

  double tempangle = 0;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final currListProvider = ref.watch(polyLineStateProvider);
    // List<LatLng> currPolyLineList = currListProvider.currPolyLineList;
    //
    MapController mapController = MapController();
    int length = polyLine.length;
    VehicleSignal vehicleSignal = ref.watch(vehicleSignalProvider);
    LatLng currPos = LatLng(vehicleSignal.currentLatitude, vehicleSignal.currentLongitude);
    LatLng destiPos = LatLng(vehicleSignal.destinationLatitude, vehicleSignal.destinationLongitude);

    return Scaffold(

      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: Colors.black),
      // ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              // rotation: -1 * mapRotation,
              center: polyLine[(length/2).toInt()],
              minZoom: 1,
              zoom: 8,
              // zoom: mapZoom ?? 18,
              maxZoom: 22.0,
              keepAlive: true,
            ),
            layers: [
              // TileLayerOptions(
              //   maxZoom: 22,
              //   maxNativeZoom: 18,
              //   subdomains: ["a", "b", "c"],
              //   urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              //   userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              // ),
              TileLayerOptions(
                urlTemplate: "https://api.mapbox.com/styles/v1/hritik3961/cl7j225qm001w14o4xeiqtv36/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaHJpdGlrMzk2MSIsImEiOiJjbDRpZjJoZmEwbmt2M2JwOTR0ZmxqamVpIn0.j7hMYKw95zKarr69MMtfcA",     additionalOptions: {
                  "access_token": "pk.eyJ1IjoiaHJpdGlrMzk2MSIsImEiOiJjbDRpZjJoZmEwbmt2M2JwOTR0ZmxqamVpIn0.j7hMYKw95zKarr69MMtfcA"
                },
              ),
              if (polyLine.isNotEmpty)
                PolylineLayerOptions(
                  polylineCulling: false,
                  polylines: [
                    // if (currPolyLineList.isNotEmpty)
                      Polyline(
                        color : Colors.blue,
                        strokeWidth: 6,
                        // strokeWidth: pathStroke ?? 12,
                        points: polyLine,
                      ),
                    // if (currPolyLineList.isNotEmpty)
                    //   Polyline(
                    //     strokeWidth: 12,
                    //     points: currPolyLineList,
                    //     color: Colors.blue,
                    //   ),
                  ],
                ),
              MarkerLayerOptions(
                rotate: true,
                markers: [
                  Marker(
                      point: currPos,
                      width: 70,
                      height: 70,
                      builder: (context) =>
                      const Icon(
                        // Icons.center_focus_strong,
                        Icons.location_pin,
                        size: 50,
                        color: Colors.red,
                      )

                  ),
                ],
              ),
              MarkerLayerOptions(
                rotate: true,
                markers: [
                  Marker(
                      point: destiPos,
                      width: 70,
                      height: 70,
                      builder: (context) =>
                      const Icon(
                        // Icons.center_focus_strong,
                        Icons.location_pin,
                        size: 50,
                        color: Colors.green,
                      )

                  ),
                ],
              ),
              // if (currPolyLineList.isNotEmpty)
              //   MarkerLayerOptions(
              //     rotate: true,
              //     markers: [
              //       Marker(
              //         point: mapCenter,
              //         width: 70,
              //         height: 70,
              //         builder: (context) => Image.asset(
              //           // "images/arrow.png",
              //           "images/car.png",
              //           // color: Colors.blue,
              //         ),
              //       ),
              //     ],
              //   ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
              child :IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
          ),
          bottomDetailCard(context,ref,Distance.toString(),Duration.toString(),CurrAddress),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () async{

          // print(polyline);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      TurnNavigation()));
          // _addSourceAndLineLayer(RouteResponse['geometry'], true);
        },
        label: const Text('lets go'),
        icon: const Icon(Icons.drive_eta_rounded),
      ),
    );
  }
}