import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_navigation/kuksa/class-provider.dart';
import 'package:flutter_navigation/kuksa/class.dart';
import 'package:flutter_navigation/map/Show-route.dart';
import 'package:flutter_navigation/provider.dart';
import 'package:flutter_navigation/search.dart';

import 'kuksa/config.dart';
import 'kuksa/intial-connection.dart';
import 'map/map-response.dart';

// void main() {
//   runApp(ProviderScope(child: MyApp()));
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpClient client = await initializeClient();
  print('hello');

  runApp(
    ProviderScope(
      child: MaterialApp(
        home: InitialScreen(client: client),
      ),
    ),
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {


  late MapController mapController;
  TextEditingController _destinationController = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
  }

  String ConvertToTime(num duration){
    int hour = (duration/3600).toInt();
    int min = (duration%3600).toInt() ;
    String mini = min.toString().substring(0,2);
    String Hour = hour.toString();
    String time = "$Hour hr $mini min";

    return time;
  }

  @override
  Widget build(BuildContext context) {

    VehicleSignal vehicleSignal = ref.watch(vehicleSignalProvider);
    LatLng center = LatLng(vehicleSignal.currentLatitude, vehicleSignal.currentLongitude);

    _destinationController.text = ref.watch(DestinationAdressProvider);

    return Scaffold(

      body: Stack(
        children: [

          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: center,
              minZoom: 12,
              zoom: 12,
              // zoom: mapZoom ?? 18,
              maxZoom: 25.0,
              keepAlive: true,
            ),
            layers: [
              // TileLayerOptions(
              //   maxZoom: 25,
              //   maxNativeZoom: 18,
              //   subdomains: ["a", "b", "c"],
              //   urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              //   userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              // ),
              TileLayerOptions(
                urlTemplate: "https://api.mapbox.com/styles/v1/hritik3961/cl4jl8h7y002914lrd5ojcgzl/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaHJpdGlrMzk2MSIsImEiOiJjbDRpZjJoZmEwbmt2M2JwOTR0ZmxqamVpIn0.j7hMYKw95zKarr69MMtfcA",
                additionalOptions: {
                  "access_token": "pk.eyJ1IjoiaHJpdGlrMzk2MSIsImEiOiJjbDRpZjJoZmEwbmt2M2JwOTR0ZmxqamVpIn0.j7hMYKw95zKarr69MMtfcA"
                // "access-token" : (R.string.mapbox_access_token).toString(),
                },
              ),
              MarkerLayerOptions(
                rotate: true,
                markers: [
                  Marker(
                    point: center,
                    width: 70,
                    height: 70,
                    builder: (context) =>
                    const Icon(
                          // Icons.center_focus_strong,
                          Icons.location_pin,
                          size: 40,
                          color: Colors.red,
                        )

                  ),
                ],
              ),
              // if (currPolyLineList.isNotEmpty || polyLineList.isNotEmpty)
              //   PolylineLayerOptions(
              //     polylineCulling: false,
              //     polylines: [
              //       if (currPolyLineList.isNotEmpty)
              //         Polyline(
              //           strokeWidth: pathStroke ?? 4,
              //           // strokeWidth: pathStroke ?? 12,
              //           points: currPolyLineList,
              //           color: Colors.blue,
              //         ),
              //       // if (currPolyLineList.isNotEmpty)
              //       //   Polyline(
              //       //     strokeWidth: 12,
              //       //     points: currPolyLineList,
              //       //     color: Colors.blue,
              //       //   ),
              //     ],
              //   ),
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
            padding: EdgeInsets.all(8),

            alignment: Alignment.topLeft,
            child: TextFormField(

              controller: _destinationController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                icon: Icon(Icons.location_pin,color: Colors.black,),
                hintText: "Choose your destination",


              ),

              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(iscurrent: false),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{


          LatLng current = LatLng(vehicleSignal.currentLatitude, vehicleSignal.currentLongitude);
          LatLng destination = LatLng(vehicleSignal.destinationLatitude,vehicleSignal.destinationLongitude);

          if(destination != LatLng(0,0)){

            print(current);
            print(destination);
            Map RouteResponse = await getDirectionsAPIResponse(current,destination);

            if(RouteResponse.isNotEmpty){
              List RouteCoordinates = RouteResponse['geometry']['coordinates'];
              List<LatLng> polyline =[];

              for(int i =0; i<RouteCoordinates.length ;i++){
                polyline.add(LatLng((RouteCoordinates[i][1]).toDouble(),(RouteCoordinates[i][0]).toDouble()));

              }
              ref.read(polylineprovider.notifier).update(polyline);
              Map response = await getAdress(current);
              String curradress = response['features'][0]['place_name'];
              num duration = RouteResponse['duration'];
              String time = ConvertToTime(duration);
              // print(time);

              double distanc = ((RouteResponse['distance']).toDouble());
              int distance = (distanc/1000).toInt();
              // print(polyline);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          NavigationHome( polyLine: polyline, CurrAddress: curradress,Duration: time,Distance: distance,)));

            }
            // print(RouteResponse['geometry']['coordinates'].runtimeType);


          }

          // _addSourceAndLineLayer(RouteResponse['geometry'], true);
        },
        label: const Text('Show Route'),
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.drive_eta_rounded),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.red,
      //   onPressed: (){
      //
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => SearchPage(iscurrent: true),
      //         ),
      //       );
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
