

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_restart/kuksa/class-provider.dart';
import 'package:test_restart/kuksa/class.dart';
import 'package:test_restart/provider.dart';

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
    String mini = '';
    if(min.toString().length > 2){
      mini = min.toString().substring(0,2);

    }
    String Hour = hour.toString();
    if(mini.length == 0){
      String time = "$Hour hr 0 min";
      return time;

    }
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
        // print(' current $current');
        // print(' destination $destination');
        Map RouteResponse = await getDirectionsAPIResponse(current,destination);
        // print(RouteResponse['geometry']['coordinates'].runtimeType);

        if(RouteResponse.isNotEmpty){

          List RouteCoordinates = RouteResponse['geometry']['coordinates'];
          // print('check');
          // print(RouteResponse['steps']['maneuver']['instruction']);
          Map steps = RouteResponse['legs']['steps'][0];
          // print(steps['maneuver']['instruction']);

          // print(steps);
          // print(steps['maneuver']);
          ref.read(Infoprovider.notifier).update(Duration: RouteResponse['duration'],
              Distance: RouteResponse['distance'], instruction: steps['maneuver']['instruction']);
          List<LatLng> currpolyline =[];
          for(int i =0; i<RouteCoordinates.length ;i++){
            currpolyline.add(LatLng(RouteCoordinates[i][1],RouteCoordinates[i][0]));

          }
          ref.read(polylineprovider.notifier).update(currpolyline);
          print('timerpolyline ${polyLine[0]},${polyLine[1]}');
          double rotationDegree = 0;
          int n = currpolyline.length;
          if (currpolyline.isNotEmpty && n > 1) {
            rotationDegree = calcAngle(
                currpolyline[0], currpolyline[1]);

            rotationDegree = (rotationDegree.isNaN) ? 0 : rotationDegree;
          }
          // print("Rotation:$rotationDegree");
          mapController.rotate(-1 * rotationDegree);


        }


      });

    });
  }

  void dispose(){
    //...
    super.dispose();
    timer.cancel();
    //...
  }

  double tempangle = 0;
  double calcAngle(LatLng a, LatLng b) {
    List<double> newA = convertCoord(a);
    List<double> newB = convertCoord(b);
    double slope = (newB[1] - newA[1]) / (newB[0] - newA[0]);
    // -1 * deg + 180
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



    int length = polyLine.length;
    // LatLng pos = ref.watch(currlnglatProvider);
    VehicleSignal vehicleSignal = ref.watch(vehicleSignalProvider);
    LatLng currPos = LatLng(vehicleSignal.currentLatitude, vehicleSignal.currentLongitude);
    polyLine = ref.watch(polylineprovider);
    info routeinfo = ref.watch(Infoprovider);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              // rotation: -1 * mapRotation,
              center: currPos,
              minZoom: 1,
              zoom: 12,
              // zoom: mapZoom ?? 18,
              maxZoom: 30.0,
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
                urlTemplate: "https://api.mapbox.com/styles/v1/hritik3961/cl7hxzrrf002t15o2j2yh14lm/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaHJpdGlrMzk2MSIsImEiOiJjbDRpZjJoZmEwbmt2M2JwOTR0ZmxqamVpIn0.j7hMYKw95zKarr69MMtfcA",     additionalOptions: {
                "access_token": "pk.eyJ1IjoiaHJpdGlrMzk2MSIsImEiOiJjbDRpZjJoZmEwbmt2M2JwOTR0ZmxqamVpIn0.j7hMYKw95zKarr69MMtfcA"
              },
              ),
              if (polyLine.isNotEmpty)
                PolylineLayerOptions(
                  polylineCulling: false,
                  polylines: [
                    // if (currPolyLineList.isNotEmpty)
                    Polyline(
                      strokeWidth: 3,
                      // strokeWidth: pathStroke ?? 12,
                      points: polyLine,
                      color: Colors.purple,
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
                        Icons.circle,
                        size: 40,
                        color: Colors.green,

                      )
                    // Image.asset('car.png'),
                    //   Image.asset(
                    //     "assets/car3.png",
                    //   ),
                      // Image(
                      //     image: AssetImage('assets/car.png'),
                      //     ),

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
              // Flex(
              //   direction: Axis.vertical,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Flex(
              //       direction: Axis.horizontal,
              //       children: [
              //         Icon(Icons.drive_eta_rounded),
              //         Text(routeinfo.instruction,style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //         ),),
              //       ],
              //     ),
              //     Text('Remaining Time : ${ConvertToTime(routeinfo.Duration)}',style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //     ),),
              //     Text('Remaining Distance : ${(routeinfo.Distance/1000).toInt().toString()} KM',style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //     ),),
              //   ],
              //
              // ),
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


// class TurnNavigation extends ConsumerWidget {
//   final List<LatLng> polyLine;
//   // final List<LatLng> currPolyLineList;
//   // double mapRotation;
//   // LatLng mapCenter;
//   // double? mapZoom;
//   // double? pathStroke;
//   TurnNavigation({
//     Key? key,
//     required this.polyLine,
//     // required this.currPolyLineList,
//     // required this.mapRotation,
//     // required this.mapCenter,
//     // this.mapZoom,
//     // this.pathStroke,
//   }) : super(key: key);
//
//   // LatLng src = LatLng(31.71, 76.95);
//
//   // LatLng des = LatLng(31.781456, 76.997469);
//
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final currListProvider = ref.watch(polyLineStateProvider);
//     // List<LatLng> currPolyLineList = currListProvider.currPolyLineList;
//     //
//
//
//     return Scaffold(
//       body:
//
//     );
//   }
// }