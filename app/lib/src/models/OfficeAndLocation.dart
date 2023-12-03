/*
OfficeLocation	- Name
- Latitude
- Langitude
- Building
- Room
- Type (enum professor,, TA, office, food outlet)	- Search for location
- Get directions
*/
enum OfficeType { PROFESSOR, TA, OFFICE, FOOD_OUTLET }

class OfficeAndLocation {
  late String name; // acts as the office's id
  late double latitude;
  late double longitude;
  late String building;
  late String room;
  late OfficeType type;

  OfficeAndLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.building,
    required this.room,
    required this.type,
  });

  OfficeAndLocation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    building = json['building'];
    room = json['room'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['building'] = building;
    data['room'] = room;
    data['type'] = type;
    return data;
  }

  @override
  String toString() {
    return 'name: $name, latitude: $latitude, longitude: $longitude, building: $building, room: $room, type: $type';
  }
}
