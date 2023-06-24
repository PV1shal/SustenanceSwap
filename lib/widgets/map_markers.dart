import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/post.dart';
import '../screens/custom_marker_window.dart';
import '../utils/privacy_option.dart';

/// This function is used to create markers for map on homepage which shows posts on tap of markers
List<Marker>? getMarkers(
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? postLocations,
    CustomInfoWindowController customInfoWindowController,
    FirebaseFirestore firebaseFirestore,
    FirebaseAuth firebaseAuth) {
  final currentUserUid = firebaseAuth.currentUser!.uid;

  final posts = <LatLng, List<PostModel>>{};

  for (final post in postLocations!) {
    final latitude = post.data()?['latitude'];
    final longitude = post.data()?['longitude'];
    final loc = LatLng(latitude ?? 0.0, longitude ?? 0.0);

    final ownerId = post.data()?['ownerId'];

    PostModel newPost = PostModel(
        caption: post.data()['caption'],
        lat: latitude,
        long: longitude,
        likes: post.data()['likes'],
        mediaUrl: post.data()['mediaUrl'],
        ownerId: ownerId,
        postID: post.data()['postId'],
        timestamp: post.data()['timestamp'],
        fireStoreInstance: firebaseFirestore);

    final privacy = post.data()['privacy'];

    //filtering posts which are having privacy option as only me and ownerUid is not currentUserUid
    if (privacy == PrivacyOption.onlyMe.value && ownerId != currentUserUid) {
      continue;
    }

    final newPostInfo = [newPost];

    posts.update(loc, (value) {
      value.add(newPost);
      return value;
    }, ifAbsent: () => newPostInfo);
  }

  final markers = <Marker>[];
  posts.forEach((latLng, postsList) {
    final newMarker = Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(168.0),
        onTap: () {
          customInfoWindowController.addInfoWindow!(
              CustomMarkerWindow(
                postsList: postsList,
                firebaseFirestore: firebaseFirestore,
                firebaseAuth: firebaseAuth,
              ),
              latLng);
        });

    markers.add(newMarker);
  });

  return markers;
}
