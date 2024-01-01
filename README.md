<div id="top"></div>

<h1 align="center">Welcome to GUConnect</h1>

<div align="center">
    <img src="./app/assets/images/GUConnect-Logo.png" alt="Logo" width="150" height="140">




  <p align="center">
 Student and Staff App is a multifunctional platform catering to the German University in Cairo community, integrating essential features like anonymous confessions, academic queries, lost and found, location services, and user-controlled news/events, while tracking usability data for continual improvement.
	  <br />
	·  
   <a href="">Demo Video</a>
   ·	  
   <a href="https://www.figma.com/file/fjW8vTZtumP8PWdHbwwErI/GUConnect?type=design&node-id=0%3A1&mode=design&t=NdpYR8ra6wORu8Fs-1">Figma </a>  
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



## 💡 Description
The GUConnect is a Student and Staff App that is a dynamic platform tailored for the German University in Cairo community. Emphasizing user engagement and utility, the app requires GUC email verification for signup and includes an admin account. Its versatile features encompass Confessions for anonymous posts, academic inquiries with image uploads and ratings, Lost and Found, location services for university offices and outlets, essential phone number databases, and an editable News/Events section managed by approved users. The app's intuitive design strategically organizes functions while ensuring push notifications for updates. Admin control can be managed within the app. Crucially, the app collects usability data, tracking user interactions and behaviors to enhance functionality and user experience continually.


### Open the App
- clone the repo ```git clone```

- ```cd app```

- Install dependencies ``` flutter pub get```

- run the project ```flutter run```


### 📷 Screenshots

### Objectives: 
- User Engagement: To create an app that appeals to GUC students and staff, encouraging active participation and usage.
- Functionality and Utility: Providing diverse functionalities catering to academic, social, and emergency needs within the GUC community.
- Administrative Control: Efficient admin tools to add, edit, delete university staff and course information,  manage, moderate, and approve user-generated content.
- Usability Enhancement: Gathering and analyzing user behavior data to enhance app usability and user experience over time.

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

### Database Structures and Firebase Schema
The database will store user profiles, posts (confessions, academic queries, lost and found items, news, events), admin approvals, user behavior logs, and other necessary data to support the functionalities mentioned above.
### CustomUser Class
- Description: Represents a user in the application.
- Schema:
  - fullName: String
  - userName: String
  - phoneNumber: String (optional)
  - image: String (optional)
  - email: String
  - password: String
  - biography: String (optional)
  - userType: String (admin, student, staff)
  - user_id: String
  - token: String (optional)
- Firestore Database:
  - Collection: users
  - Document fields: fullName, userName, phoneNumber, image, email, password, biography, userType, user_id, token
  - Restriction: Only authorized users can read and write to this collection.

### Comment Class
- Description: Represents a comment made by a user on a post.
- Schema:
  - id: String
  - content: String
  - commenter: CustomUser
  - createdAt: DateTime
  - postType: int
- Roles in Firestore Database:
  - Collection: comments
  - Document fields: id, content, commenter, createdAt, postType
  - only authorized users.
  - Restriction: Only authorized users can read and write to this collection.

### Confession Class
- Description: Represents a confession made by a user.
- Schema:
  - isAnonymous: bool
  - mentionedPeople: List<CustomUser> (optional)
  - comments: List<Comment>
  - likes: Set<String>
- Roles in Firestore Database:
  - Collection: confessions
  - Document fields: isAnonymous, mentionedPeople, comments, likes
  - Restriction: Only authorized users can read and write to this collection.
    
### Rating Class
- Description: Represents the ratings for a course or staff.
- Schema:
  - id: String
  - ratingSum: double
  - ratingAverage: double
  - ratingCount: int
- Roles in Firestore Database:
  - Collection: ratings
  - Document fields: id, ratingSum, ratingAverage, ratingCount
  - Restriction: Only authorized users can read and write to this collection.

### Course Class
- Description: Represents a course in the application.
- Schema:
  - courseCode: String
  - courseName: String
  - image: String (optional)
  - ratings: List<Rating>
  - description: String
- Roles in Firestore Database:
  - Collection: courses
  - Document fields: courseCode, courseName, image, ratings, description
  - Restriction: Only authorized users can read and write to this collection.

### ImportantEmail Class
- Description: Represents an important email contact for staff.
- Schema:
  - title: String
  - email: String
- Roles in Firestore Database:
  - Collection: importantEmails
  - Document fields: title, email
  - Restriction: Only authorized users can read and write to this collection.

### ImportantPhoneNumber Class
- Description: Represents an important phone number contact.
- Schema:
  - title: String
  - phoneNumber: String
- Roles in Firestore Database:
  - Collection: importantPhoneNumbers
  - Document fields: title, phoneNumber
  - Restriction: Only authorized users can read and write to this collection.

### LostAndFound Class
- Description: Represents a lost and found item.
- Schema:
  - contact: String (optional)
  - likes: Set<String>
  - comments: List<Comment>
- Roles in Firestore Database:
  - Collection: lostAndFound
  - Document fields: contact, likes, comments
  - Restriction: Only authorized users can read and write to this collection.

### OfficeAndLocation Class
- Description: Represents an office location.
- Schema:
  - name: String
  - latitude: double
  - longitude: double
  - location: String
  - isOffice: bool
- Roles in Firestore Database:
  - Collection: officeAndLocations
  - Document fields: name, latitude, longitude, location, isOffice
  - Restriction: Only authorized users can read and write to this collection.

### Post Class
- Description: Represents a post made by a user.
- Schema:
  - content: String
  - sender: CustomUser
  - createdAt: DateTime
  - id: String
  - image: String
  - likes: Set<String>
  - comments: List<Comment>
- Roles in Firestore Database:
  - Collection: posts
  - Document fields: content, sender, createdAt, id, image, likes, comments
  - Restriction: Only authorized users can read and write to this collection.

### Report Class
- Description: Represents a report made by a user.
- Schema:
  - id: String
  - reportedContentId: String
  - reportedUser: CustomUser
  - reportedContent: String
  - reportType: String
  - createdAt: DateTime
  - image: String (optional)
  - reason: String
  - clarification: String (optional)
- Roles in Firestore Database:
  - Collection: reports
  - Document fields: id, reportedContentId, reportedUser, reportedContent, reportType, createdAt, image, reason, clarification
  - Restriction: Only authorized users can read and write to this collection.

### Staff Class
- Description: Represents a staff member in the application.
- Schema:
  - fullName: String
  - image: String (optional)
  - email: String
  - officeLocation: String (optional)
  - staffType: String
  - bio: String (optional)
  - description: String
  - speciality: String
  - courses: List<String>
  - ratings: List<Rating>
- Roles in Firestore Database:
  - Collection: staffs
  - Document fields: fullName, image, email, officeLocation, staffType, bio, description, speciality, courses, ratings
  - Restriction: Only authorized users can read and write to this collection.

### UserRating Class
- Description: Represents a user rating for a course or staff member.
- Schema:
  - id: String
  - userId: String
  - rating: double
  - comment: String (optional)
  - createdAt: Timestamp
  - updatedAt: Timestamp
- Roles in Firestore Database:
  - Collection: userRatings
  - Document fields: id, userId, rating, comment, createdAt, updatedAt
  - Restriction: Only authorized users can read and write to this collection.

### AcademicQuestion Class
- Description: Represents an academic question posted by a user.
- Schema:
  - likes: Set<String>
  - comments: List<Comment>
- Roles in Firestore Database:
  - Collection: academicRelatedQuestions
  - Document fields: likes, comments
  - Restriction: Only authorized users can read and write to this collection.

### ScreenTime Class
- Description: Represents the screen time for usability tracking.
- Schema:
  - screenName: String
  - startTime: DateTime
  - endTime: DateTime
  - duration: double

### UserEvent Class
- Description: Represents a user event for usability tracking.
- Schema:
  - eventName: String
  - timeStampe: DateTime

### Usability Class
- Description: Represents the usability data for a user.
- Schema:
  - user_email: String
  - user_type: String
  - events: List<UserEvent> (optional)
  - screenTimes: List<ScreenTime> (optional)
- Firestore Database:
  - Collection: usabilityData
  - Document fields: user_email, user_type, events, screenTimes
  - Restriction: Only authorized users can read and write to this collection.

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
Certainly! Based on the provided usability data scheme for your Flutter app, here's a description:

---

**Usability Dataset Description:**

The usability dataset captures essential user interactions and screen time data within our application, enabling a comprehensive analysis of user behavior and engagement. The dataset includes three main components:

1. **User Information:**
   - **User Email:** This field serves as a unique identifier for users.
   - **User Type:** Specifies the type of user, providing insights into different user categories or roles.

2. **User Events:**
   - **Event Name:** Describes various user interactions, such as button clicks and scrolls.
   - **Timestamp:** Records the exact date and time when the event occurred. This information is crucial for understanding the temporal aspects of user engagement.

3. **Screen Time:**
   - **Screen Name:** Identifies the specific screen or page within the Flutter app.
   - **Start Time:** Marks the beginning of the user's interaction with a particular screen.
   - **End Time:** Indicates when the user navigates away from the screen.
   - **Duration:** Measures the time spent on a given screen, providing insights into user engagement and preferences.

*User Events* encompass actions like button clicks and scrolls, offering valuable data on user interactions and preferences. This information is vital for assessing user engagement patterns and optimizing the user interface for enhanced usability.

---

### Logging User Events (Clicks and Scrolls):

#### 1. **Click/Scroll Event Logging:**
   - For user clicks and scrolls, a dedicated `logEvent` method is employed, capturing the user's email and the specific event type (e.g., button click/scroll) along with timestamp when the event happened.
   - This logging is strategically implemented on significant buttons throughout the app to capture user interactions.

#### 2. **Scroll Event Handling within a ListView Widget:**
   - The application incorporates a `NotificationListener` wrapped around a `ListView` widget to capture scroll events initiated by the user.

#### 3. **Scroll Direction Detection:**
   - The `onNotification` callback is triggered when a `UserScrollNotification` is received, allowing for the determination of the scroll direction.
   - If the direction is forward (upward), an event with the name 'Scroll_Up_Sreen_Name' is logged.
   - If the direction is reverse (downward), an event with the name 'Scroll_Down_Sreen_Name' is logged.

#### 4. **Non-blocking Logging funtions :**
   - Both `logEvent` function is designed to be non-blocking to prevent slowing down the application's main thread.
   - This non-blocking approach allows the app to continue processing user interactions and UI updates without waiting for database operations to complete.  

### Screen Time Logging:

#### 1. **`logScreenTime` Method:**
   - The `logScreenTime` method is responsible for updating the usability dataset with screen time information.
   - It first queries the Firestore database to check if a document with the user's email exists.
   - If the document doesn't exist, a new document is created with user details and an initial screen time entry.
   - If the document exists, the screen time entry is added to the existing `screenTimes` array.

#### 2. **`didPush` Override:**
   - Triggered when a new screen is pushed onto the navigator.
   - Captures the start time when a screen is entered.
   - Calculates and logs screen time for the previous screen(to handle case of back-to-back pushing to the navigation stack).

#### 3. **`didPop` Override:**
   - Triggered when a screen is popped from the navigator.
   - Captures the exit time when a screen is exited.
   - Calculates and logs screen time for the popped screen.
   - Captures the start time of the screen(route) that is currently at the top of navigation stack after popping.

#### 4. **`didReplace` Override:**
   - Triggered when a new screen replaces an existing screen.
   - Captures the exit time when a screen is replaced.
   - Calculates and logs screen time for the replaced screen.
   - Captures the start time of the screen(route) that is currently at the top of navigation stack after replacing.

#### 5. **Screen Time Calculation:**
   - The duration of screen time is calculated by taking the difference between the exit and enter times.
   - If the duration is zero seconds, the logging is skipped to avoid recording insignificant screen times, possibly caused by rapid navigation changes or logging out as logout function pops out all the routes in the navigation stack.

#### 6. **Additional Considerations:**
   - The screen name includes additional information for profile screens with visited user emails if it exists to distinguish whether the user surfing his own profile or others.

#### 7. **Integration with NavigatorObservers:**
   - The `UsabilityProvider` is integrated into the Flutter application as a `NavigatorObserver`, ensuring that the defined methodologies for screen time logging are seamlessly executed throughout the app's navigation flow.

#### 8. **Non-blocking Logging funtions :**
   - Both `logScreenTime` function is designed to be non-blocking to prevent slowing down the application's main thread.
   - This non-blocking approach allows the app to continue processing user interactions and UI updates without waiting for database operations to complete.   

This methodology ensures accurate and detailed tracking of user interactions and screen times, providing valuable data for usability analysis within the application.
It's a common practice to avoid blocking the main thread by not awaiting certain asynchronous functions, especially if they are not critical to the immediate user experience.

---

### ⚠️ Disclaimer

Users who will Use this Data should only use it for Practice and <strong>not for Commercial Purposes !</strong>

<p align="right">(<a href="#top">back to top</a>)</p>
