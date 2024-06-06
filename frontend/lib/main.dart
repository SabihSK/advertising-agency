import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/scheduler.dart';

import 'location.dart';
// import 'package:flutter_map_example/misc/tile_providers.dart';
// import 'package:flutter_map_example/widgets/drawer/floating_menu_button.dart';
// import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';
// import 'package:flutter_map_example/widgets/first_start_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LocationListScreen(),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Map'),
      ),
      body: const FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(51.509364, -0.128928),
          initialZoom: 13.0,
        ),
        children: [],

        // layers: [
        //   TileLayerOptions(
        //     urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        //     subdomains: ['a', 'b', 'c'],
        //     attributionBuilder: (_) {
        //       return const Text('© OpenStreetMap contributors');
        //     },
        //   ),
        //   MarkerLayerOptions(
        //     markers: [
        //       Marker(
        //         width: 80.0,
        //         height: 80.0,
        //         point: const LatLng(51.509364, -0.128928),
        //         builder: (ctx) => const Icon(
        //           Icons.location_pin,
        //           color: Colors.red,
        //           size: 40.0,
        //         ),
        //       ),
        //     ],
        //   ),
        // ], children: const [],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  // static const String route = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    showIntroDialogIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(51.5, -0.09),
              initialZoom: 5,
              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(
                  const LatLng(-90, -180),
                  const LatLng(90, 180),
                ),
              ),
            ),
            children: [
              // openStreetMapTileLayer,
              RichAttributionWidget(
                popupInitialDisplayDuration: const Duration(seconds: 5),
                animationConfig: const ScaleRAWA(),
                showFlutterMapAttribution: false,
                attributions: [
                  // TextSourceAttribution(
                  //   'OpenStreetMap contributors',
                  //   onTap: () async => launchUrl(
                  //     Uri.parse('https://openstreetmap.org/copyright'),
                  //   ),
                  // ),
                  const TextSourceAttribution(
                    'This attribution is the same throughout this app, except '
                    'where otherwise specified',
                    prependCopyright: false,
                  ),
                ],
              ),
            ],
          ),
          // const FloatingMenuButton()
        ],
      ),
    );
  }

  void showIntroDialogIfNeeded() {
    const seenIntroBoxKey = 'seenIntroBox(a)';
    if (kIsWeb && Uri.base.host.trim() == 'demo.fleaflet.dev') {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) async {
          // final prefs = await SharedPreferences.getInstance();
          // if (prefs.getBool(seenIntroBoxKey) ?? false) return;

          // if (!mounted) return;

          // await showDialog<void>(
          //   context: context,
          //   builder: (context) => const FirstStartDialog(),
          // );
          // await prefs.setBool(seenIntroBoxKey, true);
        },
      );
    }
  }
}
