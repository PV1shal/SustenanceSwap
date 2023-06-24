import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:urban_sketchers/widgets/progress.dart';
import 'package:urban_sketchers/screens/notificationpage.dart';

import '../models/user.dart';
import '../utils/location_utils.dart';
import '../widgets/map_markers.dart';

/// Timeline widget is a Stateful widget showing map on homepage with markers of posts.
/// Map will show default view as your current location. Also, markers will show posts available on this location.
class Timeline extends StatefulWidget {
  /// instance of firebaseFirestore
  final FirebaseFirestore firebaseFirestore;

  /// instance of firebaseAuth
  final FirebaseAuth firebaseAuth;

  /// Constructor of timeline widget
  const Timeline(
      {Key? key, required this.firebaseFirestore, required this.firebaseAuth})
      : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

/// Private state class of Timeline
class _TimelineState extends State<Timeline> {
  /// customInfoWindowController for infowindow on marker
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  /// GoogleMapController instance
  late GoogleMapController mapController;

  ///CurrentPosition of user
  late Future<Position> currentPosition;

  /// Mapstyle as String
  String? mapStyle;

  /// Current CameraPosition of map as instance CameraPosition
  late CameraPosition _currentCameraPosition;

  /// locationController as instance of TextEditingController
  final TextEditingController locationController = TextEditingController();

  /// currentAddress in text as to show in hint
  String _currentAddress = "";

  /// PostLocations is snapshot of query for all posts
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? postLocations;

  @override
  void initState() {
    super.initState();
    loadMapStyles(); // reading json file for map style
    currentPosition = getCurrentLocation(); // getting user's current location

    /// getting address in text accordingly and setting cameraPosition in map
    currentPosition.then((value) {
      Future<String> currAddress = getAddress(value.latitude, value.longitude);
      currAddress.then((value) {
        setState(() {
          _currentAddress = value;
        });
      });
      setState(() {
        _currentCameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 14.4746,
        );
      });
    });

    /// Retrieve the posts from Firebase Firestore
    final postsSnapshot =
        widget.firebaseFirestore.collectionGroup('posts').get();

    postsSnapshot.then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      setState(() {
        postLocations = snapshot.docs;
      });
    });
  }

  /// loading map styles according to app colors
  Future loadMapStyles() async {
    mapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  /// this function is called onMapCreated
  void _onMapCreated(GoogleMapController controller, data) async {
    _customInfoWindowController.googleMapController = controller;
    mapController = controller;
    controller.setMapStyle(mapStyle);
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Urban Sketchers'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.location_on,
              color: AppColors.primaryFocusColor,
              size: 30.0,
            ),
            splashRadius: 35.0,
            onPressed: () async {
              locationController.clear();

              Position currentLocation = await getCurrentLocation();

              if (currentLocation.latitude == 0.0) return;
              _currentAddress = await getAddress(
                  currentLocation.latitude, currentLocation.longitude);
              setState(() {
                currentPosition = Future.value(currentLocation);
                _currentCameraPosition = CameraPosition(
                  target: LatLng(
                      currentLocation.latitude, currentLocation.longitude),
                  zoom: 14.4746,
                );
                mapController.animateCamera(
                    CameraUpdate.newCameraPosition(_currentCameraPosition));
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_active,
              color: AppColors.primaryFocusColor,
              size: 30.0,
            ),
            splashRadius: 35.0,
            onPressed: () {
              var userProfile = Provider.of<UserModel>(context, listen: false);
              // handle notification icon press
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                          value: userProfile,
                          child: NotificationPage(
                            firestore: widget.firebaseFirestore,
                            userID: widget.firebaseAuth.currentUser!.uid,
                          ),
                        )),
              );
              ;
            },
          ),
          const SizedBox(width: 10),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              key: const Key("location-field"),
              style: const TextStyle(color: AppColors.primaryFontColor),
              controller: locationController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.white38),
                hintText: _currentAddress.isNotEmpty
                    ? _currentAddress
                    : 'Enter a location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  splashRadius: 35.0,
                  onPressed: () async {
                    if (locationController.text.trim() != "") {
                      _currentAddress = locationController.text;
                      Location currentLocation =
                          await getLocationFromAddress(_currentAddress);
                      setState(() {
                        currentPosition = Future.value(Position(
                          latitude: currentLocation.latitude,
                          longitude: currentLocation.latitude,
                          timestamp: DateTime.now(),
                          altitude: 0.0,
                          accuracy: 1.0,
                          heading: 1.0,
                          speed: 0.0,
                          speedAccuracy: 0.0,
                        ));
                        _currentCameraPosition = CameraPosition(
                          target: LatLng(currentLocation.latitude,
                              currentLocation.longitude),
                          zoom: 14.4746,
                        );
                        mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                                _currentCameraPosition));
                      });
                    }
                  },
                ),
                suffixIconColor: AppColors.iconColor,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<Position>(
        future: currentPosition,
        builder: (context, snapshot) {
          if (snapshot.hasData && postLocations != null) {
            List<Marker>? markers = getMarkers(
                postLocations,
                _customInfoWindowController,
                widget.firebaseFirestore,
                widget.firebaseAuth);
            return Stack(
              children: [
                GoogleMap(
                  key: const Key('app-map'),
                  onTap: (position) =>
                      _customInfoWindowController.hideInfoWindow!(),
                  myLocationButtonEnabled: false,
                  markers: Set<Marker>.from(markers!),
                  onMapCreated: (controller) {
                    _onMapCreated(controller, snapshot.data);
                  },
                  initialCameraPosition: _currentCameraPosition,
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 200,
                  width: 300,
                  offset: 50,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return customCircularProgressIndicator();
          } else {
            return customCircularProgressIndicator();
          }
        },
      ),
    );
  }
}
