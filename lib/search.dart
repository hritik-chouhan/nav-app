// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_navigation/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_navigation/kuksa/class-provider.dart';
import 'package:flutter_navigation/provider.dart';

import 'mapbox.dart';

class SearchPage extends ConsumerWidget {
  bool iscurrent;

  SearchPage({Key? key, required this.iscurrent}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context,ref) {
    final config = ref.read(ConfigStateprovider);

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        bottom: false,
        child: MapBoxPlaceSearchWidget(
          height: 600,
          popOnSelect: false,
          apiKey: config.mapboxAccessToken,
          searchHint: 'Search around your place',
          onSelected: (place) async{
            var url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/${place.placeName}.json?proximity=ip&types=place%2Cpostcode%2Caddress&access_token=${config.mapboxAccessToken}';
            http.Response response = await http.get(Uri.parse(url));
            Map data = json.decode(response.body);
            double longi = data['features'][0]['center'][0];
            double lati = data['features'][0]['center'][1];
            if(iscurrent){
              LatLng value = LatLng(lati,longi);
              ref.read(vehicleSignalProvider.notifier).update(currentLatitude: lati,currentLongitude: longi);
              ref.read(CurrentAdressProvider.notifier).update(place.placeName);

            }
            else{
              ref.read(vehicleSignalProvider.notifier).update(destinationLatitude: lati,destinationLongitude: longi);

              ref.read(DestinationAdressProvider.notifier).update(place.placeName);

            }



          },
          context: context,
        ),
      ),
    );
  }
}