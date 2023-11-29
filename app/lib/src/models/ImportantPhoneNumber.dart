/*

ImportantPhoneNumber	- Title
- Phone number	- Search for number
- Call number
- Add phone number
- Retrieve all phone numbers
  */

class ImportantPhoneNumber {
  late String title;
  late String helpText;
  late String phoneNumber;

  ImportantPhoneNumber({
    required this.title,
    required this.helpText,
    required this.phoneNumber,
  });

  ImportantPhoneNumber.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    helpText = json['helpText'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['helpText'] = helpText;
    data['phoneNumber'] = phoneNumber;
    return data;
  }

  @override
  String toString() {
    return 'title: $title,  phoneNumber: $phoneNumber , helpText: $helpText';
  }
}
