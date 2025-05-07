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
          const assetName = snapshot.params.messageId;
          const folderPath =
          "messages/";
          const files = await bucket.file(folderPath+assetName+"/image");
          const url = await files.getSignedUrl({
            action: "read",
            expires: "03-01-2500", // Specify your expiration date
          });
          const decodedUrl = url[0];
          console.log(decodedUrl);
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

exports.httpsTest =functions.https.onRequest(async (req, res) => {
  const name = req.body.name;
  const number = req.body.number;
  if (!name) {
    return res.status(400).send("Missing 'name' ");
  }
  if (!number) {
    return res.status(400).send("Missing 'number'");
  }
  console.log(typeof(name), typeof(number));
  try {
    const userRef = admin.firestore().collection("code_Sprint_Users").doc(name);
    const doc = await userRef.get();
    console.log(name);
    if (doc.exists) {
      const currentScore = doc.data().Score || 0;
      await userRef.update({
        Score: currentScore + number,
      });
    } else {
      await userRef.set({
        Score: number,
      });
    }
    return res.status(200).send("Score updated");
  } catch (error) {
    console.error("Error occured", error);
    return res.status(500).send("internal server error");
  }
},
);
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
