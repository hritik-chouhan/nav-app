

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:test_restart/provider.dart';

class SearchPage extends ConsumerWidget {
  bool iscurrent;
  SearchPage({Key? key, required this.iscurrent}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context,ref) {
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
          popOnSelect: false,
          apiKey: 'pk.eyJ1IjoiaHJpdGlrMzk2MSIsImEiOiJjbDRpZjJoZmEwbmt2M2JwOTR0ZmxqamVpIn0.j7hMYKw95zKarr69MMtfcA',
          searchHint: 'Search around your place',
          onSelected: (place) async{
            var url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/${place.placeName}.json?proximity=ip&types=place%2Cpostcode%2Caddress&access_token=pk.eyJ1IjoiaHJpdGlrMzk2MSIsImEiOiJjbDRpZjJoZmEwbmt2M2JwOTR0ZmxqamVpIn0.j7hMYKw95zKarr69MMtfcA';
            http.Response response = await http.get(Uri.parse(url));
            Map data = json.decode(response.body);
            double longi = data['features'][0]['center'][0];
            double lati = data['features'][0]['center'][1];
            if(iscurrent){
              LatLng value = LatLng(lati,longi);
              ref.read(currlnglatProvider.notifier).update(value);
              ref.read(CurrentAdressProvider.notifier).update(place.placeName);

            }
            else{
              LatLng value = LatLng(lati,longi);
              ref.read(destinationlnglatProvider.notifier).update(value);
              ref.read(DestinationAdressProvider.notifier).update(place.placeName);
              LatLng distiloc = ref.read(destinationlnglatProvider);
              print(distiloc);
            }

            // print(longi);
            // print(lati);

          },
          context: context,
        ),
      ),
    );
  }
}