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