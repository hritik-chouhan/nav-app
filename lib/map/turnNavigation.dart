// SPDX-License-Identifier: Apache-2.0

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_navigation/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_navigation/kuksa/class-provider.dart';
import 'package:flutter_navigation/kuksa/class.dart';
import 'package:flutter_navigation/provider.dart';

import 'map-response.dart';

class TurnNavigation extends ConsumerStatefulWidget {
  TurnNavigation({Key? key,}) : super(key: key);

  @override
  ConsumerState<TurnNavigation> createState() => _TurnNavigationState();
}

class _TurnNavigationState extends ConsumerState<TurnNavigation> {

  late Timer timer;
  late MapController mapController;
  List<LatLng> polyLine = [];

  String ConvertToTime(num duration){
    int hour = (duration/3600).toInt();
    int min = (duration%3600).toInt() ;
    min = (min/60).toInt();
    String mini = min.toString();
    String Hour = hour.toString();
    String time = "$Hour hr $mini min";

    return time;
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      timer = Timer.periodic(Duration(seconds: 7), (timer) async{
        VehicleSignal vehicleSignal = ref.read(vehicleSignalProvider);

        LatLng current = LatLng(vehicleSignal.currentLatitude, vehicleSignal.currentLongitude);
        mapController.move(current, 18);
        LatLng destination = LatLng(vehicleSignal.destinationLatitude,vehicleSignal.destinationLongitude);

        Map RouteResponse = await getDirectionsAPIResponse(current,destination,ref);


        if(RouteResponse.isNotEmpty){

          List RouteCoordinates = RouteResponse['geometry']['coordinates'];

          Map steps = RouteResponse['legs']['steps'][0];

          ref.read(Infoprovider.notifier).update(Duration: RouteResponse['duration'],
              Distance: RouteResponse['distance'], instruction: steps['maneuver']['instruction']);
          List<LatLng> currpolyline =[];
          for(int i =0; i<RouteCoordinates.length ;i++){
            currpolyline.add(LatLng((RouteCoordinates[i][1]).toDouble(),(RouteCoordinates[i][0]).toDouble()));

          }
          ref.read(polylineprovider.notifier).update(currpolyline);
          double rotationDegree = 0;
          int n = currpolyline.length;
          if (currpolyline.isNotEmpty && n > 1) {
            rotationDegree = calcAngle(
                currpolyline[0], currpolyline[1]);

            rotationDegree = (rotationDegree.isNaN) ? 0 : rotationDegree;
          }

          mapController.rotate(-1 * rotationDegree);


        }


      });

    });
  }

  void dispose(){

    super.dispose();
    timer.cancel();

  }

  double tempangle = 0;
  double calcAngle(LatLng a, LatLng b) {
    List<double> newA = convertCoord(a);
    List<double> newB = convertCoord(b);
    double slope = (newB[1] - newA[1]) / (newB[0] - newA[0]);

    return ((atan(slope) * 180) / pi);
  }

  List<double> convertCoord(LatLng coord) {
    double oldLat = coord.latitude;
    double oldLong = coord.longitude;
    double newLong = (oldLong * 20037508.34 / 180);
    double newlat =
        (log(tan((90 + oldLat) * pi / 360)) / (pi / 180)) * (20037508.34 / 180);
    return [newlat, newLong];
  }
  @override
  Widget build(BuildContext context) {




    VehicleSignal vehicleSignal = ref.watch(vehicleSignalProvider);
    LatLng currPos = LatLng(vehicleSignal.currentLatitude, vehicleSignal.currentLongitude);
    polyLine = ref.watch(polylineprovider);
    info routeinfo = ref.watch(Infoprovider);
    final config = ref.read(ConfigStateprovider);


    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(

              center: currPos,
              minZoom: 1,
              zoom: 12,

              maxZoom: 30.0,
              keepAlive: true,
            ),
            layers: [

              TileLayerOptions(
                urlTemplate: "https://api.mapbox.com/styles/v1/hritik3961/cl7hxzrrf002t15o2j2yh14lm/tiles/256/{z}/{x}/{y}@2x?access_token=${config.mapboxAccessToken}",
                additionalOptions: {
                "access_token": config.mapboxAccessToken,
              },
              ),
              if (polyLine.isNotEmpty)
                PolylineLayerOptions(
                  polylineCulling: false,
                  polylines: [

                    Polyline(
                      strokeWidth: 3,
                      points: polyLine,
                      color: Colors.purple,
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
                        Icons.circle,
                        size: 40,
                        color: Colors.green,

                      )


                  ),
                ],
              ),

            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,

            child: Card(

              color: Colors.black54,
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.drive_eta_rounded,color: Colors.greenAccent,),
                title: Text(routeinfo.instruction,style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),),
                subtitle: Text('Remaining Distance : ${(routeinfo.Distance/1000).toInt().toString()} KM',style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
        ),),
                trailing: Text('Remaining Time : ${ConvertToTime(routeinfo.Duration)}',style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
        ),),

              ),

            ),
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
        ],
      ),
    );

  }
}


