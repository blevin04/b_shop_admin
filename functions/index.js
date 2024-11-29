/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const functions = require("firebase-functions");
admin.initializeApp();

exports.pushNotification = functions.firestore.
    onDocumentCreated("message/{messageId}",
        (snapshot) => {
          const orderData = snapshot.data;
          const head = orderData.data().title;
          const body_ = orderData.data().body;
          const message = {
            notification: {
              title: head,
              body: body_,
            },
            topic: "all",
          };
          admin.messaging().send(message).then((response)=>{
            console.log("Successfully sent notification", response);
          }).catch((error)=>{
            console.log("error sending message", error);
          });
        });
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
