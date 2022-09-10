// SPDX-License-Identifier: Apache-2.0


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_navigation/config.dart';
import 'package:flutter_navigation/kuksa/class-provider.dart';
import 'package:flutter_navigation/kuksa/class.dart';
import 'package:flutter_navigation/map/map-response.dart';
import 'package:flutter_navigation/provider.dart';
import 'package:flutter_navigation/search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';


import 'map/Show-route.dart';

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
    min = (min/60).toInt();
    String mini = min.toString();
    String Hour = hour.toString();
    String time = "$Hour hr $mini min";

    return time;
  }

  @override
  Widget build(BuildContext context) {

    VehicleSignal vehicleSignal = ref.watch(vehicleSignalProvider);
    LatLng center = LatLng(vehicleSignal.currentLatitude, vehicleSignal.currentLongitude);

    _destinationController.text = ref.watch(DestinationAdressProvider);
    final config = ref.read(ConfigStateprovider);



    return Scaffold(

      body: Stack(
        children: [

          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: center,
              minZoom: 12,
              zoom: 12,

              maxZoom: 25.0,
              keepAlive: true,
            ),
            layers: [

              TileLayerOptions(
                urlTemplate: "https://api.mapbox.com/styles/v1/hritik3961/cl7hxzrrf002t15o2j2yh14lm/tiles/256/{z}/{x}/{y}@2x?access_token=${config.mapboxAccessToken}",
                additionalOptions: {
                  "access_token": config.mapboxAccessToken,

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

                        Icons.location_pin,
                        size: 40,
                        color: Colors.red,
                      )

                  ),
                ],
              ),

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

            Map RouteResponse = await getDirectionsAPIResponse(current,destination,ref);

            if(RouteResponse.isNotEmpty){
              List RouteCoordinates = RouteResponse['geometry']['coordinates'];
              List<LatLng> polyline =[];

              for(int i =0; i<RouteCoordinates.length ;i++){
                polyline.add(LatLng((RouteCoordinates[i][1]).toDouble(),(RouteCoordinates[i][0]).toDouble()));

              }
              ref.read(polylineprovider.notifier).update(polyline);
              Map response = await getAdress(current,ref);
              String curradress = response['features'][0]['place_name'];
              num duration = RouteResponse['duration'];
              String time = ConvertToTime(duration);


              double distanc = ((RouteResponse['distance']).toDouble());
              int distance = (distanc/1000).toInt();


              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          NavigationHome( polyLine: polyline, CurrAddress: curradress,Duration: time,Distance: distance,)));

            }



          }


        },
        label: const Text('Show Route'),
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.drive_eta_rounded),
      ),


    );
  }
}
