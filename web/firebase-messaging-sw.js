// importScripts("https://www.gstatic.com/firebasejs/9.18.0/firebase-app.js");
// importScripts("https://www.gstatic.com/firebasejs/9.18.0/firebase-messaging.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

const hostname = location.hostname;

if (hostname == 'vc-space.web.app') { // production
  firebase.initializeApp({
    apiKey: "AIzaSyDqYX7JqTTv8UNz1Hbxpo2lpLyDmStjegY",
    authDomain: "vc-space.firebaseapp.com",
    projectId: "vc-space",
    storageBucket: "vc-space.appspot.com",
    messagingSenderId: "247037295656",
    appId: "1:247037295656:web:e7520d92087a972a67091d",
    measurementId: "G-V03Y9JPEDV"
  });
} else {
  firebase.initializeApp({ // development
    apiKey: "AIzaSyCuAhmlNQWSfFbVdLYxpOP3iT3KT3RFfXc",
    authDomain: "vc-space-dev.firebaseapp.com",
    projectId: "vc-space-dev",
    storageBucket: "vc-space-dev.appspot.com",
    messagingSenderId: "180668270503",
    appId: "1:180668270503:web:9112a68005a0e6b32f1882",
    measurementId: "G-KEFW9TXS2Y"
  });
}

const messaging = firebase.messaging();
