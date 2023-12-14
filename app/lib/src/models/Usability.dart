import 'package:GUConnect/src/models/User.dart';

/// Represents a user in the application.
class Usability {
  late String user_email; // acts as the user's id
  late String user_type;
  late List<UserEvent> ?events;

  Usability({
    required this.user_email,
     this.events
  }
  ) {
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

  /// Constructs a User object from a JSON map.
  Usability.fromJson(Map<String, dynamic> json) {
    user_email = json['user_email'];
    user_type = json['user_type'];
  }

  /// Converts the User object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_email'] = user_email;
    data['user_type'] = user_type;
    return data;
  }
}
class UserEvent {
  late String eventName; //button_click, screen_view, scroll
  late double value;

  UserEvent({
    required this.eventName,
    required this.value,
  });
  UserEvent.fromJson(Map<String, dynamic> json) {
    eventName = json['eventName'];
    value = json['value'];
    }
  Map<String, dynamic>toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventName'] = eventName;
    data['value'] = value;
    return data;
  }
  }
