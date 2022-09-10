// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_navigation/config.dart';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';



String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String navType = 'driving';

Dio _dio = Dio();

Future getdrivingRouteUsingMapbox(LatLng source, LatLng destination,ref) async {
  final config = ref.read(ConfigStateprovider);

  String url =
      '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=${config.mapboxAccessToken}';
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    print(e);
  }
}

Future<Map> getDirectionsAPIResponse(LatLng currentLatLng,LatLng destiLatLng,ref) async {

  final response = await getdrivingRouteUsingMapbox(currentLatLng, destiLatLng,ref);

  if(response != null){
    Map geometry = response['routes'][0]['geometry'];
    num duration = response['routes'][0]['duration'];
    num distance = response['routes'][0]['distance'];
    Map legs = response['routes'][0]['legs'][0];

    Map modifiedResponse = {
      "geometry": geometry,
      "duration": duration,
      "distance": distance,
      "legs" : legs,
    };
    return modifiedResponse;

  }
  else{
    Map map = {};
    return map;
  }

}

Future<Map> getAdress(LatLng pos,ref) async{
  final config = ref.read(ConfigStateprovider);

  var url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/${pos.longitude},${pos.latitude}.json?&access_token=${config.mapboxAccessToken}';
  http.Response response = await http.get(Uri.parse(url));
  Map data = json.decode(response.body);
  return data;
}