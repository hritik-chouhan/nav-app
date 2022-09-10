// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'class.dart';

final vehicleSignalProvider =
StateNotifierProvider<VehicleSignalNotifier, VehicleSignal>(
      (ref) => VehicleSignalNotifier(),
);

class VehicleSignalNotifier extends StateNotifier<VehicleSignal> {
  VehicleSignalNotifier() : super(_initialValue);
  static final VehicleSignal _initialValue = VehicleSignal(

    currentLatitude: 31.706964,
    currentLongitude: 76.933138,

    destinationLatitude: 0,
    destinationLongitude: 0,
  );
  void update({

    double? currentLatitude,
    double? currentLongitude,

    double? destinationLatitude,
    double? destinationLongitude,
  }) {
    state = state.copyWith(

      currentLatitude: currentLatitude,
      currentLongitude: currentLongitude,

      destinationLatitude: destinationLatitude,
      destinationLongitude: destinationLongitude,
    );
  }
}