import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp
  (
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold
      (
        body: SafeArea
        (
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showPopup = false;
  final LatLng hub = const LatLng(3.12070, 101.65446);
  final LatLng currentLoc = const LatLng(3.1195, 101.65460);
  final LatLng elepLoc = const LatLng(3.12110, 101.65495);

  final List<LatLng> routePoints = 
  [
  LatLng(3.1195, 101.65460),
  LatLng(3.12126, 101.65463),
  LatLng(3.12146, 101.65475),
  LatLng(3.12183, 101.65555),
  ];
  final List<LatLng> routePointsRed = 
  [
  LatLng(3.12126, 101.65463),
  LatLng(3.12146, 101.65475),
  ];

DocumentSnapshot? latestDoc;
  @override
void initState() {
  super.initState();

  // Listen for changes in the ElephantDetection collection
  FirebaseFirestore.instance
      .collection("ElephantDetection")
      .doc("Elephas Maximus")
      .snapshots()
      .listen((doc) {
    if (!mounted) return; // prevent setState if widget is disposed
    setState(() {
      latestDoc = doc;
      showPopup = doc.exists; // show popup if at least one document exists
    });
  });
}

void _showElephantAlert(BuildContext context) {
  if (latestDoc == null || !latestDoc!.exists) return;

  final data = latestDoc!.data() as Map<String, dynamic>;
  final count = data["count"] ?? 0;
  final ts = data["last_detected"];

  // Convert Firestore Timestamp to Dart DateTime
  String formattedTime = "";
  if (ts != null) {
    DateTime dt = (ts is Timestamp) ? ts.toDate() : DateTime.tryParse(ts.toString()) ?? DateTime.now();
    formattedTime = "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Image.asset('assets/images/elephanticon4.png',width: 60,height: 60,),
            //SizedBox(width: 2),
            Text("Elephant Alert!",style: TextStyle(fontSize: 22),),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Text("$count elephant(s) detected nearby."),),
            SizedBox(height: 8),
            Text("Last seen: $formattedTime"), // You can make this dynamic
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Dismiss"),
          ),
        ],
      );
    },
  );
}

  
  @override
  Widget build(BuildContext context) 
  {
    if (showPopup) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showElephantAlert(context);
    });
  }
    return FlutterMap
        (options: MapOptions
          (
          initialCenter: hub,
          initialZoom: 17.8,
          ),
          children:
          [
            TileLayer
            (
              urlTemplate: 'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.example.app',
            ),

            PolylineLayer
            (
              polylines: 
              [
                Polyline
                (
                  points: routePoints,
                  strokeWidth: 10,
                  color: Colors.blue, // Navigation line color
                ),
                if (showPopup)
                Polyline
                (
                  points: routePointsRed,
                  strokeWidth: 10,
                  color: Colors.red, // Navigation line color
                ),
              ],
            ),

            MarkerLayer
            (
              markers: 
              [
                Marker
                (
                  point: currentLoc,
                  width: 60, height: 60,
                  child: Container(decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white.withOpacity(0.9)),padding: EdgeInsets.all(8),
                          child: Icon(Icons.navigation, size: 40, color: Colors.blue,),)
                ),
                if (showPopup)
                Marker
                (
                  point: elepLoc,
                  width: 200,
                  height: 100,
                  child: Image.asset('assets/images/elephanticon5.png',width: 50,height:50)
                ),
              ],
            ),

            Stack
            (
              children: 
              [
                Positioned
                (
                  left: 10,
                  top: 80,
                  child: Container
                  (
                    width: 150,
                    height: 70,
                    decoration: BoxDecoration
                    (
                      color: const Color.fromARGB(255, 0, 83, 60),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack
                    (
                      children: 
                      [
                        Positioned(left:20, top:30, child: Text('Then', style: TextStyle(fontSize: 22,color: Colors.white),),),
                        Positioned(left:90, top:23, child: Icon(Icons.turn_right, size: 42,color: Colors.white,),),
                      ],
                    ),
                  ),
                ),

                Positioned
                (
                  left: 10,
                  top: 10,
                  child: Container
                  (
                    width: 345,
                    height: 100,
                    decoration: BoxDecoration
                    (
                      color: const Color.fromARGB(255, 0, 101, 79),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Stack
                    (
                      children: 
                      [
                        Positioned
                        (
                          left: 12,
                          top: 25,
                          child: Icon(Icons.north, size: 50, color: Colors.white,),
                        ),
                        Positioned
                        (
                          left: 70,
                          top: 25,
                          child: Text('towards', style: TextStyle(fontSize: 18, color: Colors.white),)
                        ),
                        Positioned
                        (
                          left: 146,
                          top: 13,
                          child: Text('Jalan DS', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),)
                        ),
                        Positioned
                        (
                          left: 70,
                          top: 43,
                          child: Text('1/12', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),)
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned
                (
                  left: 302,
                  top: 30,
                  child: Container
                  (
                    decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 157, 157, 157), width: 1),boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3),spreadRadius: 1,blurRadius: 1, offset: Offset(1,1))],shape: BoxShape.circle),
                    child: IconButton
                    (
                      onPressed: (){},
                      icon: Icon(Icons.mic),
                      iconSize: 30,
                      style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black,padding: EdgeInsets.all(10)),
                    ),
                  ),
                ),

                Positioned
                (
                  left: 302,
                  top: 95,
                  child: Container
                  (
                    decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 157, 157, 157), width: 1),boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3),spreadRadius: 1,blurRadius: 1, offset: Offset(1,1))],shape: BoxShape.circle),
                    child: IconButton
                    (
                      onPressed: (){},
                      icon: Icon(Icons.search),
                      iconSize: 30,
                      style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black,padding: EdgeInsets.all(10)),
                    ),
                  ),
                ),

                Positioned
                (
                  left: 302,
                  top: 160,
                  child: Container
                  (
                    decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 157, 157, 157), width: 1),boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3),spreadRadius: 1,blurRadius: 1, offset: Offset(1,1))],shape: BoxShape.circle),
                    child: IconButton
                    (
                      onPressed: (){},
                      icon: Icon(Icons.volume_up_sharp),
                      iconSize: 30,
                      style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black,padding: EdgeInsets.all(10)),
                    ),
                  ),
                ),
                Positioned
                (
                  left: 302,
                  top: 225,
                  child: Container
                  (
                    decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 157, 157, 157), width: 1),boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3),spreadRadius: 1,blurRadius: 1, offset: Offset(1,1))],shape: BoxShape.circle),
                    child: IconButton
                    (
                      onPressed: (){},
                      icon: Icon(Icons.explore),
                      iconSize: 30,
                      style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black,padding: EdgeInsets.all(10)),
                    ),
                  ),
                ),
                Positioned
                (
                  top: 662,
                  child: Container
                  (
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    decoration: BoxDecoration
                    (
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color.fromARGB(255, 157, 157, 157))
                    ),

                    child: Stack
                    (
                      children: 
                      [
                        Positioned
                        (
                          left: 170,
                          top: 15,
                          child: Container(width: 30,height: 5, decoration: BoxDecoration(color: const Color.fromARGB(255, 92, 92, 92), borderRadius: BorderRadius.circular(50)),),
                        ),
                        Positioned
                        (
                          left: 123,
                          top: 16,
                          child: Text('33', style: TextStyle(fontSize: 32, color: const Color.fromARGB(255, 13, 126, 17), fontWeight: FontWeight.bold),)
                        ),
                        Positioned
                        (
                          left: 165,
                          top: 17,
                          child: Text('min', style: TextStyle(fontSize: 32, color: const Color.fromARGB(255, 13, 126, 17)),)
                        ),
                        Positioned
                        (
                          left: 113,
                          top: 68,
                          child: Text('27 km  ·  3:53 pm', style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 121, 121, 121)),)
                        ),
                        Positioned
                        (
                          left: 235,
                          top: 28,
                          child: Container
                          (
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2)),
                          ),
                        ),
                        Positioned
                        (
                          left: 228,
                          top: 32,
                          child: Container
                          (
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2)),
                            child: Center(child:Text('1',style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),),),
                          ),
                        ),
                        Positioned
                        (
                          left: 20,
                          top: 28,
                          child: Container
                          (
                            decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 82, 82, 82), width: 1),shape: BoxShape.circle),
                            child: IconButton
                            (
                              onPressed: (){},
                              icon: Icon(Icons.close),
                              iconSize: 30,
                              style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black,padding: EdgeInsets.all(10)),
                            ),
                          ),
                        ),
                        Positioned
                        (
                          left: 290,
                          top: 28,
                          child: Container
                          (
                            decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 82, 82, 82), width: 1),shape: BoxShape.circle),
                            child: IconButton
                            (
                              onPressed: (){},
                              icon: Icon(Icons.call_split),
                              iconSize: 30,
                              style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black,padding: EdgeInsets.all(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned
                (
                  left: 18,
                  top: 580,
                  child: Container
                  (
                    width: 70, height: 70,
                    decoration: BoxDecoration(color: Colors.white,boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3),spreadRadius: 1,blurRadius: 1, offset: Offset(1,1))],border: Border.all(color: const Color.fromARGB(255, 157, 157, 157), width: 1),shape: BoxShape.circle),
                    child: Stack
                    (
                      children: 
                      [
                        Positioned(left: 18,top: 10,child: Text('30', style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),),
                        Positioned(left: 18,top: 40,child: Text('km/h', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
  }
}
