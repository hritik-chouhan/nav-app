// SPDX-License-Identifier: Apache-2.0

class VehicleSignal {
  VehicleSignal({

    required this.currentLatitude,
    required this.currentLongitude,

    required this.destinationLatitude,
    required this.destinationLongitude,
  });


  final double currentLongitude;
  final double currentLatitude;
  final double destinationLongitude;
  final double destinationLatitude;


  VehicleSignal copyWith({

    double? currentLongitude,
    double? currentLatitude,

    double? destinationLongitude,
    double? destinationLatitude,
  }) {
    return VehicleSignal(

      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,

      destinationLatitude: destinationLatitude ?? this.destinationLatitude,
      destinationLongitude: destinationLongitude ?? this.destinationLongitude,
    );
  }
}

class info{
  info({required this.Duration, required this.Distance, required this.instruction});

  final num Duration;
  final num Distance;
  final String instruction;

  info copywith({num? Duration , num? Distance, String? instruction}){
    return info(Duration: Duration ?? this.Duration,
        Distance: Distance ?? this.Distance,
        instruction: instruction ?? this.instruction);

  }
}