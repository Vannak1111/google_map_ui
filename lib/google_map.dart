// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googlemap_ui/persmition.dart';

class GoogleMap extends StatefulWidget {
  const GoogleMap({super.key});

  @override
  State<GoogleMap> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  @override
  void initState() {
    determinePosition();
    super.initState();
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google map")),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isloading = true;
                    });
                    LocationPermission permission;
                    permission = await Geolocator.checkPermission();
                    if (permission == LocationPermission.always ||
                        permission == LocationPermission.whileInUse) {
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      setState(() {
                        isloading = false;
                      });
                      debugPrint("lat long $position");
                      double icsLat = 11.561267332172669;
                      double icsLong = 104.92612366046919;
                      double matherLat = position.latitude;
                      double matherLong = position.longitude;
                      double disabled = Geolocator.distanceBetween(
                          icsLat, icsLong, matherLat, matherLong);
                      debugPrint("disten $disabled");
                      if ((matherLat > icsLat && matherLong < icsLong) ||
                          (matherLat > icsLat && matherLong > icsLong) ||
                          (matherLat < icsLat && matherLong < icsLong)) {
                        if ((matherLat < icsLat && matherLong < icsLong)) {
                          if (matherLat < 11.560777414908193) {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: const Text(
                                          'you can not pick your child'),
                                      content: Text(
                                          "Your can not take your child when you stay $disabled from ics school"),
                                    ));
                          } else {
                            showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                      backgroundColor: Colors.green,
                                      title: Text('success'),
                                      content: Text(
                                          'wait to pick your child , have a nice day'),
                                    ));
                          }
                        } else {
                          if (disabled > 100) {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: const Text(
                                          'you can not pick your child'),
                                      content: Text(
                                          "Your can not take your child when you stay $disabled from ics school"),
                                    ));
                          } else {
                            showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                      backgroundColor: Colors.green,
                                      title: Text('success'),
                                      content: Text(
                                          'wait to pick your child , have a nice day'),
                                    ));
                          }
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  backgroundColor: Colors.red.withOpacity(0.9),
                                  title: const Text(
                                      'you not in from of the ics school'),
                                  content: const Text(
                                      'Ics school provide pick your child only in from of school '),
                                ));
                      }
                      debugPrint(" $disabled meter ");
                    } else {
                      Geolocator.openLocationSettings();
                    }
                  },
                  child: const Text("get location "))),
    );
  }
}
