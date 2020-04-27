import 'package:ba_locale/model/database/company.dart';
/**
 * This page displays the map from Google
 **/

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  @override
  MapsPageState createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;
  //This is the position of the centre of Angers
  final LatLng _initial = const LatLng(47.471780, -0.551767);
  final Map<String, Marker> _markers = {};

  //This create the map to display Google Maps
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.clear();
      for (CompanyDB company in CompaniesDB.companies) {
        final marker = Marker(
          markerId: MarkerId(company.uid),
          position: LatLng(company.lat, company.long),
          infoWindow: InfoWindow(
            title: company.name,
            snippet: company.address,
          ),
        );
        _markers[company.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _initial,
            zoom: 15.0,
          ),
          markers: _markers.values.toSet(),
        );
  }
}