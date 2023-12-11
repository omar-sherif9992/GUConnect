/*
OfficeLocation	- Name
- Latitude
- Langitude
- Building
- Room
- Type (enum professor,, TA, office, food outlet)	- Search for location
- Get directions
*/

class OfficeAndLocation {
  late String name; // acts as the office's id
  late double latitude;
  late double longitude;
  late String location;
  late bool isOffice;
  OfficeAndLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.isOffice,
  });

  OfficeAndLocation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
    isOffice = json['isOffice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['location'] = location;
    data['isOffice'] = isOffice;
    return data;
  }

  @override
  String toString() {
    return 'name: $name, latitude: $latitude, longitude: $longitude, location: $location, isOffice: $isOffice';
  }
}
