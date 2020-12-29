import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sleek_weather/Backend/DataManager.dart';
import 'package:sleek_weather/Backend/ServerSide.dart';
import 'package:sleek_weather/Weather/BackendWeather.dart';

class Location {
  Location(this.name, this.latitude, this.longitude);

  final String name;
  final double latitude;
  final double longitude;

  String stringify() {
    return "$name:$latitude $longitude";
  }

  String displayName() {
    String displayName = this.name.indexOf(",") == -1 ? this.name : this.name.substring(0,  this.name.indexOf(","));
    displayName = this.name.indexOf("-") == -1 ? displayName : this.name.substring(0,  this.name.indexOf("-"));
    return displayName;
  }

  static Location parseString(String location) {
    String name = location.substring(0, location.indexOf(":"));
    location = location.substring(location.indexOf(":") + 1);
    double latitude = double.parse(location.substring(0, location.indexOf(" ")));
    location = location.substring(location.indexOf(" ") + 1);
    double longitude = double.parse(location.substring(0, location.length - 1));
    return Location(name, latitude, longitude);
  }

  static List<String> extractNames(List<Location> locations) {
    List<String> names = List();
    for(int i = 0; i < locations.length; i++) {
      names.add(locations[i].name);
    }

    return names;
  }

  static void setupLocations(Function callback) {
    Location.fetchLocationList().then(
      (locations) {
        if (locations == null) {
          Location.getCurrentCoordinates((location) {
            DataManager.locations.add(location);
            callback();
          });
        } else {
          DataManager.locations = locations;
          callback();
        }
      }
    );
  }

  static void getCurrentCoordinates(Function callback) {
    Geolocator.checkPermission().then((value) => {
      if (value != LocationPermission.denied && value != LocationPermission.deniedForever) {
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) async {
          try {
            List<Address> p = await Geocoder.local.findAddressesFromCoordinates(new Coordinates(position.latitude, position.longitude));
            callback(Location(p[0].locality + ", " + p[0].adminArea + ", " + p[0].countryName, position.latitude, position.longitude));
          } catch (e) {
            print(e);
          }
        }).catchError((e) {
          print(e);
        })
      } else {
        Geolocator.requestPermission().then((value) => {
          getCurrentCoordinates(callback)
        })
      }
    });
  }

  static void locationLookup(String keyLocation, Function callback) {
    ServerSide("https://maps.googleapis.com/maps/api/place/autocomplete/json", "input=$keyLocation&types=(cities)").access("PLACES").then(
                    (response) {
        List<String> _displayResults = [];
        final predictions = response.data['predictions'];

        for (var i = 0; i < predictions.length; i++) {
          _displayResults.add(predictions[i]['description']);
        }

        callback(_displayResults);
      }
    );
  }

  static void reverseGeocode(String name) {
    ServerSide("https://maps.googleapis.com/maps/api/geocode/json", "address=$name").access("PLACES").then(
      (response) {
        final coordinates = response.data['results'][0]['geometry']['location'];
        DataManager.locations.add(Location(name, coordinates['lat'], coordinates['lng']));
        Weather.fetchData();
      }
    );
  }

  static void saveLocationList(List<Location> locations) async {
    List<String> data = List();
    for(int i = 0; i < locations.length; i++) {
      data.add(locations[i].stringify());
    }

    (await SharedPreferences.getInstance()).setStringList(DataManager.PREFRENCES_KEY, data);
  }

  static Future<List<Location>> fetchLocationList() async {
    List<String> data = (await SharedPreferences.getInstance()).getStringList(DataManager.PREFRENCES_KEY);
    if (data != null) {
      List<Location> locations = List();
      for(int i = 0; i < data.length; i++) {
        locations.add(Location.parseString(data[i]));
      }

      return locations;
    } else {
      return null;
    }
  }
}