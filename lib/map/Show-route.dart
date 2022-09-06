import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_navigation/kuksa/class-provider.dart';
import 'package:flutter_navigation/kuksa/class.dart';
import 'package:flutter_navigation/map/bottom-card.dart';
import 'package:flutter_navigation/map/turnNavigation.dart';
import 'map-config.dart';

class NavigationHome extends ConsumerWidget {
  final List<LatLng> polyLine;
  String CurrAddress;
  String Duration;
  num Distance;

  NavigationHome({
    Key? key,
    required this.polyLine,
    required this.CurrAddress,
    required this.Duration,
    required this.Distance,

  }) : super(key: key);



  double tempangle = 0;
  @override
  Widget build(BuildContext context, WidgetRef ref) {


    MapController mapController = MapController();
    int length = polyLine.length;
    VehicleSignal vehicleSignal = ref.watch(vehicleSignalProvider);
    LatLng currPos = LatLng(vehicleSignal.currentLatitude, vehicleSignal.currentLongitude);
    LatLng destiPos = LatLng(vehicleSignal.destinationLatitude, vehicleSignal.destinationLongitude);

    return Scaffold(


      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(

              center: currPos,
              minZoom: 1,
              zoom: 8,

              maxZoom: 22.0,
              keepAlive: true,
            ),
            layers: [

              TileLayerOptions(
                urlTemplate: map.MapTileDarkMode,
                additionalOptions: {
                  "access_token": map.MapBoxToken
                },
              ),
              if (polyLine.isNotEmpty)
                PolylineLayerOptions(
                  polylineCulling: false,
                  polylines: [

                      Polyline(
                        color : Colors.blue,
                        strokeWidth: 6,

                        points: polyLine,
                      ),

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

                        Icons.location_pin,
                        size: 50,
                        color: Colors.green,
                      )

                  ),
                ],
              ),

            ],
          ),
          Container(
            alignment: Alignment.topLeft,
              child :IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white,),
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



          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      TurnNavigation()));

        },
        label: const Text('lets go'),
        icon: const Icon(Icons.drive_eta_rounded),
      ),
    );
  }
}