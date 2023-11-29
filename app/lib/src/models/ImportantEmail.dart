/*

ImportantPhoneNumber	- Title
- Phone number	- Search for number
- send email
- Add email
- Retrieve all Emails
  */

class ImportantEmail {
  late String title;
  late String email;

  ImportantEmail({
    required this.title,
    required this.email,
  });

  ImportantEmail.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['email'] = email;
    return data;
  }

  @override
  String toString() {
    return 'title: $title,  email: $email ';
  }
}
