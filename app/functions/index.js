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
  try {
    const message = {
      notification: {
        title: title,
      },
      token: token,
      data: {
        body: body,
        type: "general",
      },
    };
    return fcm
        .send(message)
        .then((response) => {
          return {
            success: true,
            response: "Notification sent successfully",
          };
        })
        .catch((error) => {
          return {success: false, response: error};
        });
  } catch (error) {
    return {success: false, response: error};
  }
});

exports.sendTagNotification = functions.https.onCall((data, context) => {
  /*
    data = {
        taggedUserName: string,
        taggedUserToken: string,
        confessionId: string,
        taggerName: string,
    }
    */

  const title = `${data.taggerName} tagged you in a confession`;
  const body = "Click to view the confession";
  const token = data.taggedUserToken;
  const confessionId = data.confessionId;

  try {
    const message = {
      notification: {
        title: title,
        body: body,
      },
      token: token,
      data: {
        confessionId: confessionId,
        type: "tag",
      },
    };
    return fcm
        .send(message)
        .then((response) => {
          return {
            success: true,
            response: "Notification sent successfully",
          };
        })
        .catch((error) => {
          return {success: false, response: error};
        });
  } catch (error) {
    return {success: false, response: error};
  }
});

exports.sendCommentNotification = functions.https.onCall((data, context) => {
  /*
        data = {
            postOwner: {
                name: string,
                token: string,
            },
            postId: string,
            type: string [confession, event post, announcement, ...],
            commenterName: string,
        }
  */

  const title = `${data.commenterName} commented on your ${data.type}`;
  const body = "Click to view the post";
  const token = data.postOwner.token;
  const postId = data.postId;


  try {
    const message = {
      notification: {
        title: title,
        body: body,
      },
      token: token,
      data: {
        confessionId: postId,
        type: "comment",
      },
    };
    return fcm
        .send(message)
        .then((response) => {
          return {
            success: true,
            response: "Notification sent successfully",
          };
        })
        .catch((error) => {
          return {success: false, response: error};
        });
  } catch (error) {
    return {success: false, response: error};
  }
});

exports.sendLikeNotification = functions.https.onCall((data, context) => {
  /*
            data = {
                postOwner: {
                    name: string,
                    token: string,
                },
                postId: string,
                type: string [confession, event post, announcement, ...],
                likerName: string,
            }
    */

  const title = `${data.likerName} liked your ${data.type}`;
  const body = "Click to view the post";
  const token = data.postOwner.token;
  const postId = data.postId;

  try {
    const message = {
      notification: {
        title: title,
        body: body,
      },
      token: token,
      data: {
        confessionId: postId,
      },
    };
    return fcm
        .send(message)
        .then((response) => {
          return {
            success: true,
            response: "Notification sent successfully",
          };
        })
        .catch((error) => {
          return {success: false, response: error};
        });
  } catch (error) {
    return {success: false, response: error};
  }
});

exports.sendPostApprovalNotification = functions.https.onCall(
    (data, context) => {
    /*
                data = {
                    postOwner: {
                        name: string,
                        token: string,
                    },
                    postId: string,
                }
    */

      const title = "Your last post was approved";
      const body = "Click to view the post";
      const token = data.postOwner.token;
      const postId = data.postId;

      try {
        const message = {
          notification: {
            title: title,
            body: body,
          },
          token: token,
          data: {
            announcementId: postId,
            type: "approval",
          },
        };

        return fcm
            .send(message)
            .then((response) => {
              return {
                success: true,
                response: "Notification sent successfully",
              };
            })
            .catch((error) => {
              return {success: false, response: error};
            });
      } catch (error) {
        return {success: false, response: error};
      }
    });

exports.sendBroadcastNotificationNewAnnouncement = functions.https.onCall(
    (data, context) => {
    /*
                data = {
                    postId: string,
                    postOwnerName: string,
                }
    */

      const title = "New announcement from " + data.postOwnerName;
      const body = "Click to view the announcement";
      const postId = data.postId;
      const userSnapshot = admin.firestore().collection("users");
      const users = userSnapshot.get().then((querySnapshot) => {
        const tokens = [];
        querySnapshot.forEach((doc) => {
          if (doc.data().token) tokens.push(doc.data().token);
        });
        try {
          const message = {
            notification: {
              title: title,
              body: body,
            },
            tokens: tokens,
            data: {
              announcementId: postId,
              type: "broadcast",
            },
          };

          return fcm
              .sendMulticast(message)
              .then((response) => {
                return {
                  success: true,
                  response: "Notification sent successfully",
                };
              })
              .catch((error) => {
                return {success: false, response: error};
              });
        } catch (error) {
          return {success: false, response: error};
        }
      });

      return users;
    }
);
