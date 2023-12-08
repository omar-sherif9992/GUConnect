const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const fcm = admin.messaging();

exports.checkHealth = functions.https.onCall((data, context) => {
  return {success: true, response: "GUC Connect is up and running"};
});

exports.sendNotification = functions.https.onCall((data, context) => {
  const body = data.body;
  const title = data.title;
  const token = data.token;
  const image = data.image;
  try {
    const message = {
      notification: {
        title: title,
        image: image,
      },
      token: token,
      data: {
        body: body,
      },
    };
    return fcm.send(message).then((response) => {
      return {success: true, response: "Notification sent successfully"};
    }).catch((error) => {
      return {success: false, response: error};
    });
  } catch (error) {
    return {success: false, response: error};
  }
});
