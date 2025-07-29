// [START initialize_firebase_in_sw]
importScripts('https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDfOJ5k-gm27wRlzPfNVAxKBDeWQBGrPRw",
  authDomain: "dating-app-ab2d9.firebaseapp.com",
  projectId: "dating-app-ab2d9",
  storageBucket: "dating-app-ab2d9.appspot.com",
  messagingSenderId: "42049923887",
  appId: "1:42049923887:web:3b52aa0357bf13b6f5cfda",
  measurementId: "G-M11HP82VYF"
});

const messaging = firebase.messaging();
// [END initialize_firebase_in_sw] 