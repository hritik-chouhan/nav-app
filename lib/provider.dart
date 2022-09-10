// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'kuksa/class.dart';


final currlnglatProvider = StateNotifierProvider<currentLngLat,LatLng>(
      (ref)=> currentLngLat(),
);

class currentLngLat extends StateNotifier<LatLng>{
  currentLngLat() : super(
    LatLng(31.706964,76.933138),
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

final polylineprovider = StateNotifierProvider<PolyLine,List<LatLng>>((ref) => PolyLine());

class PolyLine extends StateNotifier<List<LatLng>> {

  PolyLine() : super([]);
  void update(List<LatLng> list) {
    state = list;
  }
}

final Infoprovider = StateNotifierProvider<Info,info>((ref) => Info());

class Info extends StateNotifier<info> {

  Info() : super(initial);
  static final info initial = info(Duration: 0, Distance: 0, instruction: '');

  void update({
  num? Duration,
    num? Distance,
    String? instruction,

      }){
    state = state.copywith(
      Duration: Duration,
      Distance: Distance,
      instruction: instruction,
    );


      }
}