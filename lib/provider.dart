import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:latlong2/latlong.dart';

final currlnglatProvider = StateNotifierProvider<currentLngLat,LatLng>(
      (ref)=> currentLngLat(),
);

class currentLngLat extends StateNotifier<LatLng>{
  currentLngLat() : super(
    LatLng(48.143724,11.576278),
  );
  Future<void> update(value) async{

    state = value;
  }

}

final destinationlnglatProvider = StateNotifierProvider<distiLngLat,LatLng>(
      (ref)=> distiLngLat(),
);

class distiLngLat extends StateNotifier<LatLng>{
  distiLngLat() : super(
    LatLng(0,0),
  );
  Future<void> update(value) async{
    state = value;
  }

}

final CurrentAdressProvider = StateNotifierProvider<currentAdress,String>(
      (ref)=> currentAdress(),
);

class currentAdress extends StateNotifier<String>{
  currentAdress() : super(
      ''
  );
  Future<void> update(value)async{
    state = value;
  }
}

final DestinationAdressProvider = StateNotifierProvider<destiAdress,String>(
      (ref)=> destiAdress(),
);

class destiAdress extends StateNotifier<String>{
  destiAdress() : super(
      ''
  );
  Future<void> update(value)async{
    state = value;
  }
}