import 'package:GUConnect/src/models/User.dart';

/// Represents a user in the application.
class Usability {
  late String user_email; // acts as the user's id
  late String user_type;
  late List<UserEvent>? events;
  late List<ScreenTime>? screenTimes;

  Usability({required this.user_email, this.events, this.screenTimes}) {
    this.user_type = getUserType();
  }

  String getUserType() {
    try {
      String split = this.user_email.split('@')[1];
      split = split.split('.')[0];
      split = split.toLowerCase();
      if (split == 'student') {
        return UserType.student;
      } else if (split == 'gucconnect') {
        return UserType.admin;
      } else {
        return UserType.staff;
      }
    } catch (e) {
      return UserType.staff;
    }
  }

  Usability.fromJson(Map<String, dynamic> json) {
    user_email = json['user_email'];
    user_type = json['user_type'];
    if (json['events'] != null) {
      events = List<UserEvent>.from(
        json['events'].map((event) => UserEvent.fromJson(event)),
      );
    }

    // Deserialize screen times
    if (json['screenTimes'] != null) {
      screenTimes = List<ScreenTime>.from(
        json['screenTimes'].map((time) => ScreenTime.fromJson(time)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_email'] = user_email;
    data['user_type'] = user_type;
    if (events != null) {
      data['events'] = events!.map((event) => event.toJson()).toList();
    }

    // Serialize screen times
    if (screenTimes != null) {
      data['screenTimes'] = screenTimes!.map((time) => time.toJson()).toList();
    }
    return data;
  }
}

class UserEvent {
  late String eventName; //button_click, screen_view, scroll
  late DateTime timeStampe = DateTime.now();

  UserEvent({
    required this.eventName,
  });
  UserEvent.fromJson(Map<String, dynamic> json) {
    eventName = json['eventName'];
    timeStampe = json['timeStampe'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventName'] = eventName;
    data['timeStampe'] = timeStampe.toString();
    return data;
  }
}

class ScreenTime {
  late String screenName;
  late DateTime startTime;
  late DateTime endTime;
  late double duration;

  ScreenTime({
    required this.startTime,
    required this.endTime,
    required this.screenName,
  }) {
    this.duration = endTime.difference(startTime).inSeconds.toDouble();
  }
  ScreenTime.fromJson(Map<String, dynamic> json) {
    screenName = json['screenName'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    duration = json['duration'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['screenName'] = screenName;
    data['startTime'] = startTime.toString();
    data['endTime'] = endTime.toString();
    data['duration'] = duration;
    return data;
  }
}
