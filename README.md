<div id="top"></div>

<h1 align="center">Welcome to GUConnect</h1>

<div align="center">
    <img src="./app/assets/images/GUConnect-Logo.png" alt="Logo" width="150" height="140">



  <h3 align="center"></h3>

  <p align="center">
short description
    <br />
    <br />
	  📄<a href="" download target="_blank"><strong>View  App»</strong></a>
    <br />
	·  
   <a href="">Demo Video</a>
   ·	  
   <a href="https://www.figma.com/file/fjW8vTZtumP8PWdHbwwErI/GUConnect?type=design&node-id=0%3A1&mode=design&t=zlPSxTtHri8pzAZ6-1">Figma </a>  
 ·	  
   <a href="https://lucid.app/lucidchart/e678ad3f-d21e-473a-aeb1-ace8cea06b62/edit?viewport_loc=-2028%2C-46%2C3091%2C1487%2CHWEp-vi-RSFO&invitationId=inv_842808d6-f19f-4b1e-a7b9-9cd768dd9e86">UML </a>  
   ·	  
   <a href="https://docs.google.com/spreadsheets/d/1lI0hLmn0Jz3ZJwm410RHPvpFhJihtHBz-o7q4khgfYc/edit?usp=sharing">User Requirements </a>
   ·
   <a href="mailto:osa.helpme@gmail.com?subject=UnExpected%20Error%20Occured&body=Sorry%20for%20the%20inconvenience%2C%20Please%20describe%20Your%20situation%20and%20emphasis%20the%20Endpoint%20!%0A">Report Bug</a>
   	      ·
    <a href="mailto:osa.helpme@gmail.com?subject=I%20want%20to%20be%20a%20Contributor%20to%20Bachelor Thesis&body=Dear%20Omar%20Sherif">Be a Contributer</a>
  </p>
</div>

## Open the App
- clone the repo ```git clone```

- ```cd app```

- Install dependencies ``` flutter pub get```

- run the project ```flutter run```


## 💡 Description



### Motivation:
- Enhancing Campus Life: Empowering students and staff by providing a central platform for various needs.
- Encouraging Participation: Fostering a sense of community and collaboration within the GUC.
- Improving User Experience: Continuously evolving and adapting the app based on user behavior insights for a more user-friendly experience.

### 💻️ Languages & Libraries Used
- Flutter: is Google's open-source UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase, using the Dart programming language.

- Firebase SDK: is a comprehensive platform by Google that offers tools and services for mobile and web app development, including authentication, Firestore (a NoSQL cloud database), cloud functions, and more, simplifying backend infrastructure management.
	- Firestore is Firebase's NoSQL cloud database that provides real-time data synchronization and querying capabilities, allowing developers to structure and manage app data efficiently across various devices.

	- Firebase Authentication (FireAuth): is a secure authentication system within Firebase SDK, enabling easy integration of user authentication methods like email/password, social logins, and phone number authentication into mobile and web applications.

	- Cloud Functions: is a serverless computing service that allows developers to execute backend code in response to events triggered by Firebase features or HTTP requests, enabling custom server-side logic without managing servers directly.
 - 
	- Local Notifications: are alerts triggered and displayed directly on a user's device, enhancing user engagement by providing timely updates, reminders, or alerts within the app without requiring a server.
	- Google Maps: is a mapping service that, when integrated into Flutter using google_maps_flutter package, offers interactive maps, markers, routing, and geolocation services, enabling users to explore locations and navigate within mobile applications.


<p align="right">(<a href="#top">back to top</a>)</p>

### Database Structures:
The database will store user profiles, posts (confessions, academic queries, lost and found items, news, events), admin approvals, user behavior logs, and other necessary data to support the functionalities mentioned above.


### Flutter Folder Structure

```
├── firebase_options.dart
├── main.dart
├── routes.dart
├── src
│   ├── dummy_data
│   │   ├── importantEmails.dart
│   │   ├── importantNumbers.dart
│   │   ├── OfficeItems.dart
│   │   ├── posts.dart
│   │   └── user.dart
│   ├── models
│   │   ├── AcademicQuestion.dart
│   │   ├── Comment.dart
│   │   ├── Confession.dart
│   │   ├── Course.dart
│   │   ├── ImportantEmail.dart
│   │   ├── ImportantPhoneNumber.dart
│   │   ├── LostAndFound.dart
│   │   ├── NewsEventClub.dart
│   │   ├── OfficeAndLocation.dart
│   │   ├── Post.dart
│   │   ├── Rating.dart
│   │   ├── Reports.dart
│   │   ├── Staff.dart
│   │   ├── Usability.dart
│   │   ├── User.dart
│   │   └── UserRating.dart
│   ├── providers
│   │   ├── AcademicQuestionProvider.dart
│   │   ├── CommentProvider.dart
│   │   ├── ConfessionProvider.dart
│   │   ├── CourseProvider.dart
│   │   ├── ImportantEmailProvider.dart
│   │   ├── ImportantPhoneNumberProvider.dart
│   │   ├── LikesProvider.dart
│   │   ├── LostAndFoundProvider.dart
│   │   ├── NewsEventClubProvider.dart
│   │   ├── OfficeLocationProvider.dart
│   │   ├── PostProvider.dart
│   │   ├── RatingProvider.dart
│   │   ├── ReportsProvider.dart
│   │   ├── StaffProvider.dart
│   │   ├── UsabilityProvider.dart
│   │   └── UserProvider.dart
│   ├── screens
│   │   ├── admin
│   │   │   ├── pending_reports.dart
│   │   │   ├── pendings_screen.dart
│   │   │   ├── report_content.dart
│   │   │   ├── request_post_screen.dart
│   │   │   ├── search_course.dart
│   │   │   ├── search_staff.dart
│   │   │   ├── set_course_screen.dart
│   │   │   ├── set_important_contacts_screen.dart
│   │   │   ├── set_office_screen.dart
│   │   │   └── set_staff_screen.dart
│   │   ├── authentication
│   │   │   ├── login.dart
│   │   │   └── register.dart
│   │   ├── common
│   │   │   ├── about.dart
│   │   │   ├── AcademicRelated
│   │   │   │   ├── academicRelated.dart
│   │   │   │   ├── addAcademicQuestion.dart
│   │   │   │   └── editAcademicPost.dart
│   │   │   ├── confessions
│   │   │   │   ├── addConfessions.dart
│   │   │   │   └── confessions.dart
│   │   │   ├── important_contacts.dart
│   │   │   ├── L&F
│   │   │   │   ├── addLostAndFoundPost.dart
│   │   │   │   ├── editLostAndFoundPost.dart
│   │   │   │   └── lostAndFound.dart
│   │   │   ├── newsEvents
│   │   │   │   ├── addPostClubs.dart
│   │   │   │   ├── clubsAndEvents.dart
│   │   │   │   └── editPostClubs.dart
│   │   │   ├── officesAndOutlets.dart
│   │   │   └── splash.dart
│   │   ├── course
│   │   │   └── course_profile.dart
│   │   ├── staff
│   │   │   └── profile.dart
│   │   └── user
│   │       ├── profile.dart
│   │       ├── profile_edit.dart
│   │       ├── profile_edit_form.dart
│   │       ├── search.dart
│   │       └── settings.dart
│   ├── services
│   │   └── notification_api.dart
│   ├── utils
│   │   ├── dates.dart
│   │   ├── titleCase.dart
│   │   └── uploadImageToStorage.dart
│   └── widgets
│       ├── app_bar.dart
│       ├── bottom_bar.dart
│       ├── cached_image.dart
│       ├── comment.dart
│       ├── comment_popup_menu.dart
│       ├── comments_modal.dart
│       ├── confession_widget.dart
│       ├── drawer.dart
│       ├── edit_comment.dart
│       ├── email_field.dart
│       ├── error_essage.dart
│       ├── input_field.dart
│       ├── likable_image.dart
│       ├── loader.dart
│       ├── mention_field.dart
│       ├── message_dialog.dart
│       ├── password_field.dart
│       ├── phone_field.dart
│       ├── popup_menue_button.dart
│       ├── post.dart
│       ├── post_widget.dart
│       ├── RatingBar.dart
│       ├── report_modal.dart
│       ├── status_indicator.dart
│       └── user_image_picker.dart
└── themes
    ├── colors.dart
    ├── sizes.dart
    └── themes.dart

```

### ⚠️ Disclaimer

Users who will Use this Data should only use it for Practice and <strong>not for Commercial Purposes !</strong>

<p align="right">(<a href="#top">back to top</a>)</p>

### 📷 Screenshots
