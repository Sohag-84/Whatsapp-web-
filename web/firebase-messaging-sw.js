importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');


  const firebaseConfig = {
    apiKey: "AIzaSyCGvkqSuQh9m3kTENVVTQ7hdppEjHEFRs4",
    authDomain: "whatsapp-web-clone-a29aa.firebaseapp.com",
    projectId: "whatsapp-web-clone-a29aa",
    storageBucket: "whatsapp-web-clone-a29aa.appspot.com",
    messagingSenderId: "581397415635",
    appId: "1:581397415635:web:a4d2a5df38f0cfcb8d3626",
    };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();


  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });