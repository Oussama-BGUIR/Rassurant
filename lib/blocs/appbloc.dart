import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rassurant/services/mygeolocator.dart';

class ApplicationBloc with ChangeNotifier{
  final geoLocatorService = GeolocatorService();

  //variables
  Position ?currentLocation ; //late zedtha taslih code sinon app block twali ghalta

  ApplicationBloc() {
    setCurrentLocation();
  }



  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }
}