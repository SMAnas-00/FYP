// ignore_for_file: unnecessary_null_comparison, unused_local_variable, depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: unused_import
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final CameraPosition _initialLocation =
      const CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth userAuth = FirebaseAuth.instance;

  NOTIFY notify = NOTIFY();
  bool isinNotification = false;
  bool isInPolygon = false;
  late StreamSubscription<Position> positionStreamSubscription;

  late Position _currentPosition;
  String _currentAddress = '';
  // ignore: prefer_final_fields
  Set<Polygon> _polygon = {};

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  var uuid = const Uuid();
  bool isInselected = true;
  String _sessionToken = '1223344';
  List<dynamic> _placesList = [];

  // ignore: non_constant_identifier_names
  List<LatLng> Polygonpoints = const [
    LatLng(24.873463514025758, 67.13520799826712),
    LatLng(24.873472639291787, 67.1352086688193),
    LatLng(24.873480547855124, 67.13520933937151),
    LatLng(24.873480547855124, 67.1352207387589),
    LatLng(24.873479331153092, 67.13527371238264),
    LatLng(24.873477506100052, 67.13529248784423),
    LatLng(24.873459863919177, 67.13528913508323),
    LatLng(24.873458038865834, 67.13523750256388),
  ];

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;

  Set<Marker> markers = {};

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return SizedBox(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;

        debugPrint('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
        checkUpdatedLocation(_currentPosition as LatLng);
      });
      await _getAddress();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(_destinationAddress);

      double startLatitude = _startAddress == _currentAddress
          ? _currentPosition.latitude
          : startPlacemark[0].latitude;

      double startLongitude = _startAddress == _currentAddress
          ? _currentPosition.longitude
          : startPlacemark[0].longitude;

      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: _startAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: _destinationAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      debugPrint(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      debugPrint(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );

      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);

      double totalDistance = 0.0;

      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        debugPrint(totalDistance.toStringAsFixed(2));
        _placeDistance = totalDistance.toStringAsFixed(3);
        debugPrint('DISTANCE: $_placeDistance km');
      });
      setState(() {});

      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    debugPrint('LATITUDE 1: $lat1');
    debugPrint('LATITUDE 1: $lat2');

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    PolylineId id = const PolylineId('ROUTE');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.purple,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  @override
  void initState() {
    super.initState();
    startLocationService();
    _checkLocation();
    _getCurrentLocation();
    startAddressController.addListener(() {
      onChange();
    });
    destinationAddressController.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    setState(() {
      String value1 = (startAddressFocusNode.hasFocus)
          ? startAddressController.text
          : destinationAddressController.text;
      getsuggestion(value1);
    });
  }

  void stopLocationService() {
    if (positionStreamSubscription != null) {
      positionStreamSubscription.cancel();
    }
  }

  void getsuggestion(String input) async {
    String kplacesApiKey = 'AIzaSyDNzkszHrT2L0zwdhK0DzVK46aqO7n5lxk';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Faild to Load');
    }
  }

  void checkUpdatedLocation(LatLng pointLatLng) {
    List<map_tool.LatLng> convatedpolygonpoints =
        Polygonpoints.map((e) => map_tool.LatLng(e.latitude, e.longitude))
            .toList();
    if (mounted) {
      setState(() {
        isInselected = map_tool.PolygonUtil.containsLocation(
            map_tool.LatLng(pointLatLng.latitude, pointLatLng.longitude),
            convatedpolygonpoints,
            false);
      });
    }
  }

  sendNotification(String title, String token, String msg) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': 1,
      'status': 'done',
      'message': title
    };
    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAxEir0ZA:APA91bEjKav5v9gOfz-abN9-zuQwE2LKFQ8wT-cKwoHUTYCUxB3162YVY8j4hX3fGNAy23Qd07vXYmxipYst-RDQV3xvENgJ5DWH2JfxXk_Pl7qNJnVx3DAtZ9_fFmQ3nKC_UqcG0-jH'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': msg,
                },
                'priority': 'high',
                'data': data,
                'to': token
              }));

      if (response.statusCode == 200) {
        debugPrint("Notification has been send");
      } else {
        debugPrint("Somethin went wrong");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> startLocationService() async {
    final userDoc = await firestore
        .collection('app')
        .doc('Users')
        .collection('Signup')
        .doc(userAuth.currentUser!.uid)
        .get();
    String userToken = await userDoc.data()?['token'];

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      debugPrint('Location permission denied.');
      return;
    }

    // Subscribe to location changes
    Geolocator.getPositionStream().listen((Position position) {
      final userLocation = LatLng(position.latitude, position.longitude);
      final isInsidePolygon = isPointInPolygon(userLocation, Polygonpoints);
      if (mounted) {
        setState(() async {
          isInPolygon = isInsidePolygon;
          if (isInPolygon == true && isinNotification == false) {
            debugPrint('In boundary============================');
            sendNotification(
                'Inside Boundary', userToken, 'You are Inside the Boundary');
            isinNotification = true;
          }
          if (isInPolygon == false && isinNotification == true) {
            debugPrint('OUTSIDE boundary============================');
            sendNotification(
                'Outside Boundary', userToken, 'You are Outside the Boundary');
            isinNotification = false;
          }
        });
      }
    });
  }

  bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    bool isInside = false;
    int i, j = polygon.length - 1;

    for (i = 0; i < polygon.length; i++) {
      if ((polygon[i].latitude < point.latitude &&
              polygon[j].latitude >= point.latitude) ||
          (polygon[j].latitude < point.latitude &&
              polygon[i].latitude >= point.latitude)) {
        if (polygon[i].longitude +
                (point.latitude - polygon[i].latitude) /
                    (polygon[j].latitude - polygon[i].latitude) *
                    (polygon[j].longitude - polygon[i].longitude) <
            point.longitude) {
          isInside = !isInside;
        }
      }
      j = i;
    }
    return isInside;
  }

  @override
  void dispose() {
    super.dispose();
    stopLocationService();
  }

  @override
  Widget build(BuildContext context) {
    final BackArrow = IconButton(
        color: Colors.white,
        onPressed: () {},
        icon: const Icon(Icons.arrow_back));
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              polygons: {
                Polygon(
                    polygonId: const PolygonId('1'),
                    points: Polygonpoints,
                    fillColor: Colors.black26,
                    strokeWidth: 2)
              },
            ),

            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 220, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Show the place input fields & button for
            // showing the route
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            'Places',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          const SizedBox(height: 10),
                          _textField(
                              label: 'Start',
                              hint: 'Choose starting point',
                              prefixIcon: const Icon(Icons.looks_one),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.my_location),
                                onPressed: () async {
                                  await _getAddress();
                                  startAddressController.text = _currentAddress;
                                  debugPrint(_currentAddress);
                                  _startAddress = _currentAddress;
                                },
                              ),
                              controller: startAddressController,
                              focusNode: startAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _startAddress = value;
                                });
                              }),
                          const SizedBox(height: 10),
                          _textField(
                              label: 'Destination',
                              hint: 'Choose destination',
                              prefixIcon: const Icon(Icons.looks_two),
                              controller: destinationAddressController,
                              focusNode: desrinationAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _destinationAddress = value;
                                });
                              }),
                          Container(
                            child: startAddressController.text == null
                                ? Container(
                                    height: 5,
                                  )
                                : SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                        itemCount: _placesList.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            child: ListTile(
                                              title: Text(_placesList[index]
                                                  ['description']),
                                            ),
                                          );
                                        }),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: _placeDistance == null ? false : true,
                            child: Text(
                              'DISTANCE: $_placeDistance km',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: (_startAddress != '' &&
                                    _destinationAddress != '')
                                ? () async {
                                    startAddressFocusNode.unfocus();
                                    desrinationAddressFocusNode.unfocus();
                                    setState(() {
                                      if (markers.isNotEmpty) markers.clear();
                                      if (polylines.isNotEmpty) {
                                        polylines.clear();
                                      }
                                      if (polylineCoordinates.isNotEmpty) {
                                        polylineCoordinates.clear();
                                      }
                                      _placeDistance = null;
                                    });

                                    _calculateDistance().then((isCalculated) {
                                      if (isCalculated) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Distance Calculated Sucessfully'),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Error Calculating Distance'),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Show Route'.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
                child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Colors.black45,
                    size: 40,
                  ),
                  onPressed: () {},
                ),
              ),
            )),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: const SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkLocation() async {
    LatLng currentlocation = await _getCurrentLocation();
    bool isInside = false;
    for (Polygon polygon in _polygon) {}
  }
}

class Secrets {
  static const API_KEY = 'AIzaSyDNzkszHrT2L0zwdhK0DzVK46aqO7n5lxk';
}

class NOTIFY {
  Future<void> _scheduleNotification() async {
    // Define the notification details.
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('01', 'ALERT',
            channelDescription: 'you are in BOUNDARY',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the notification.
    await FlutterLocalNotificationsPlugin().zonedSchedule(
        0,
        'ALERT',
        'YOU ARE IN THE BOUNDARY',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> _scheduleNotification2() async {
    // Define the notification details.
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('02', 'ALERT',
            channelDescription: 'you are OUTSIDE in the Boundary',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the notification.
    await FlutterLocalNotificationsPlugin().zonedSchedule(
        0,
        'ALERT',
        'YOU ARE OUTSIDE THE BOUNDARY',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
