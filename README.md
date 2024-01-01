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




### 💻️ Languages & Libraries Used


<p align="right">(<a href="#top">back to top</a>)</p>


### Flutter Folder Structure

```
lib/
|-- main.dart
|-- src/
|   |-- screens/
|   |   |-- home_screen.dart
|   |   |-- profile_screen.dart
|   |-- widgets/
|   |   |-- custom_button.dart
|   |   |-- app_drawer.dart
|   |-- models/
|   |   |-- user.dart
|   |-- services/
|   |   |-- api_service.dart
|   |-- utils/
|   |   |-- constants.dart
|   |   |-- helpers.dart
|-- themes/
|   |-- app_theme.dart
|-- main_app.dart
```

### ⚠️ Disclaimer

Users who will Use this Data should only use it for Practice and <strong>not for Commercial Purposes !</strong>

<p align="right">(<a href="#top">back to top</a>)</p>

### 📷 Screenshots


### Database Structures and Firebase Schema

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

### ImportantEmail Class
- Description: Represents an important email contact for staff.
- Schema:
  - title: String
  - email: String
- Roles in Firestore Database:
  - Collection: importantEmails
  - Document fields: title, email

### ImportantPhoneNumber Class
- Description: Represents an important phone number contact.
- Schema:
  - title: String
  - phoneNumber: String
- Roles in Firestore Database:
  - Collection: importantPhoneNumbers
  - Document fields: title, phoneNumber

### LostAndFound Class
- Description: Represents a lost and found item.
- Schema:
  - contact: String (optional)
  - likes: Set<String>
  - comments: List<Comment>
- Roles in Firestore Database:
  - Collection: lostAndFoundItems
  - Document fields: contact, likes, comments

### OfficeAndLocation Class
- Description: Represents an office location.
- Schema:
  - name: String
  - latitude: double
  - longitude: double
  - location: String
  - isOffice: bool
- Roles in Firestore Database:
  - Collection: officeLocations
  - Document fields: name, latitude, longitude, location, isOffice

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
  - Collection: staffMembers
  - Document fields: fullName, image, email, officeLocation, staffType, bio, description, speciality, courses, ratings

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

### AcademicQuestion Class
- Description: Represents an academic question posted by a user.
- Schema:
  - likes: Set<String>
  - comments: List<Comment>
- Roles in Firestore Database:
  - Collection: academicQuestions
  - Document fields: likes, comments

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
  - 
