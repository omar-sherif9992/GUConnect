/*

ImportantPhoneNumber	- Title
- Phone number	- Search for number
- Call number
- Add phone number
- Retrieve all phone numbers
  */

class ImportantPhoneNumber {
  late String title;
  late String phoneNumber;

  ImportantPhoneNumber({
    required this.title,
    required this.phoneNumber,
  });

  ImportantPhoneNumber.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['phoneNumber'] = phoneNumber;
    return data;
  }

  @override
  String toString() {
    return 'title: $title,  phoneNumber: $phoneNumber ';
  }
}
