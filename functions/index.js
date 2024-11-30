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
            data: {
              noteid: snapshot.params.messageId,
            },
          };
          admin.messaging().send(message).then((response)=>{
            console.log("Successfully sent notification", response);
            console.log(message);
          }).catch((error)=>{
            console.log("error sending message", error);
          });
        });


exports.newOrder = functions.firestore.onDocumentCreated(
    "orders/{orderNum}",
    async (snapshot) => {
      const orderd = snapshot.data;
      const liveStatus = orderd.data().Live;
      if (liveStatus == true) {
        const Orderitems = orderd.data().items;
        const ondelivery = orderd.data().OndeliveryPayment;
        const paymentMode = ondelivery?"On delivery payment":"Payment Complete";
        const message = {
          notification: {
            title: "New Order",
            body: paymentMode,
          },
          topic: "admin",
          data: Orderitems,
        };
        admin.messaging().send(message).then((response) => {
          console.log("Successfully sent notification", response);
          console.log(message);
        }).catch((error)=>{
          console.log("Error occured ", error);
        });
      }
    },
);
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
