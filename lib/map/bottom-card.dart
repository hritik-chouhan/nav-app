// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

import 'package:flutter_navigation/kuksa/class-provider.dart';
import 'package:flutter_navigation/kuksa/class.dart';
import 'package:flutter_navigation/provider.dart';

Widget bottomDetailCard(
    BuildContext context, ref,String distance, String dropOffTime,String CurrAdd) {
  VehicleSignal vehicleSignal = ref.watch(vehicleSignalProvider);
  String destiadd = ref.read(DestinationAdressProvider);

  return Container(
    alignment: Alignment.bottomLeft,

    child: SizedBox(

      width: MediaQuery.of(context).size.width,
      child: Card(

        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$CurrAdd ➡ $destiadd',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.indigo)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    leading: const Image(
                        image: AssetImage('assets/car2.png'),
                        height: 50,
                        width: 50),
                    title: const Text('Happy Journey',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('$distance km     $dropOffTime',style: TextStyle(color: Colors.black),),

                  ),
                ),

              ]),
        ),
      ),
    ),
  );
}