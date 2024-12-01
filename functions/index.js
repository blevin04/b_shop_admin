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
        async (snapshot) => {
          const orderData = snapshot.data;
          const head = orderData.data().title;
          const body_ = orderData.data().body;
          const bucket = admin.storage().bucket();
          // const messageId = snapshot.params.messageId;
          const folderPath =
          `/messages/0275c730-afd6-11ef-a994-614d16ba7b67/
          JPEG_20241201_141833_4919703518714523812.jpg`;
          const files = await bucket.file(folderPath);
          const url = await files.getSignedUrl({
            action: "read",
            expires: "03-01-2500", // Specify your expiration date
          });
          const decodedUrl = decodeURIComponent(url[0]);
          console.log(typeof decodedUrl, decodedUrl);
          // if (files.length > 0) {
          //   const file = files[0];
          //   // Assuming there is only one image in the folder
          //   const [url] = await file.getDownloadURL;
          //   console.log("Url is ", url);
          // }
          const message = {
            notification: {
              title: head,
              body: body_,
            },
            android: {
              notification: {
                image: decodedUrl,
              }},
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
        const itemMap = new Map();
        let body0 = "";
        for (const [key, value] of Object.entries(Orderitems)) {
          itemMap.set(key.toString(), value.toString());
          body0 += `${value[2]}X ${value[0]} `;
        }
        body0 += paymentMode;
        const message = {
          notification: {
            title: "New Order",
            body: body0,
          },
          topic: "admin",
          data: itemMap,
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
