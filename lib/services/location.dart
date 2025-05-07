import 'package:geolocator/geolocator.dart';

class Location{
  late double latitude;
  late double longitude;

  Future<void> getCurrentLocation() async{
    try{
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnabled){
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.denied){
          return;
        }
      }

      if(permission == LocationPermission.deniedForever){
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low
          )
      );
      longitude = position.longitude;
      latitude = position.latitude;
    }
    catch(e){
      print(e);
    }
    return;
  }
}