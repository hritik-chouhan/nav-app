// SPDX-License-Identifier: Apache-2.0

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_navigation/kuksa/intial-connection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaml/yaml.dart';


class GetConfig extends ConsumerStatefulWidget {
  const GetConfig({Key? key, required this.client}) : super(key: key);
  final HttpClient client;

  @override
  ConsumerState<GetConfig> createState() => _GetConfigState();
}

class _GetConfigState extends ConsumerState<GetConfig> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final configStateProvider = ref.read(ConfigStateprovider.notifier);

      String configFilePath = '/etc/xdg/AGL/nav_config.yaml';
      String mapboxFilePath = '/etc/default/mapboxkey';

      String keyContent = "";

      final mapboxKeyFile = File(mapboxFilePath);

      final configFile = File(configFilePath);
      configFile.readAsString().then((content) {
        final dynamic yamlMap = loadYaml(content);
        configStateProvider.update(
          hostname: yamlMap['hostname'],
          port: yamlMap['port'],
          kuksaAuthToken: yamlMap['kuskaAuthToken'],
        );
      });
      mapboxKeyFile.readAsString().then((content) {
        keyContent = content.split(':')[1].trim();
        if (keyContent.isNotEmpty && keyContent != 'YOU_NEED_TO_SET_IT_IN_LOCAL_CONF') {
          configStateProvider.update(mapboxAccessToken: keyContent);
        } else {
          print("WARNING: Mapbox API Key not found !");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(ConfigStateprovider);
    if (config.hostname == "" ||
        config.port == 0 ||
        config.kuksaAuthToken == "" ||
        config.mapboxAccessToken == "") {
      return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("ERROR",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                    "Something Wrong with config file! Check config.yaml file and restart"),
                Text("OR"),
                Text("You Need to set MapboxAccess token in local.conf file"),
              ],
            )),
      );
    }
    return InitialScreen(client: widget.client);
  }
}

class Config {
  Config({
    required this.hostname,
    required this.port,
    required this.kuksaAuthToken,
    required this.mapboxAccessToken,

  });
  final String hostname;
  final int port;
  final String kuksaAuthToken;
  final String mapboxAccessToken;

  Config copywith({
    String? hostname,
    int? port,
    String? kuksaAuthToken,
    String? mapboxAccessToken,
  }) =>
      Config(
        hostname: hostname ?? this.hostname,
        port: port ?? this.port,
        kuksaAuthToken: kuksaAuthToken ?? this.kuksaAuthToken,
        mapboxAccessToken: mapboxAccessToken ?? this.mapboxAccessToken,
      );
}

final ConfigStateprovider =
StateNotifierProvider<ConfigStateNotifier, Config>(
        (ref) => ConfigStateNotifier());

class ConfigStateNotifier extends StateNotifier<Config> {
  ConfigStateNotifier() : super(_initialValue);
  static final Config _initialValue = Config(
    hostname: "",
    port: 0,
    kuksaAuthToken: "",
    mapboxAccessToken: "",
  );
  void update({
    String? hostname,
    int? port,
    String? kuksaAuthToken,
    String? mapboxAccessToken,
  }) {
    state = state.copywith(
      hostname: hostname,
      port: port,
      kuksaAuthToken: kuksaAuthToken,
      mapboxAccessToken: mapboxAccessToken,
    );
  }
}
