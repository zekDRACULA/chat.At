# Chat.At
 This is a chatting app.
The Changes made in requests.dart
Certainly, here's a comparison between the original code and the modified code I provided:

**Original Code:**
```dart
gettingUserData() async {
  await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
      .getUserRequests()
      .then((snapshot) {
    setState(() {
      recievedRequests = snapshot;
    });
  });
}
```

**Modified Code:**
```dart
gettingUserData() async {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final userDocument = FirebaseFirestore.instance.collection('users').doc(currentUserUid);

  // Assuming 'recieved_Requests' is an array field in the user's document
  userDocument.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      setState(() {
        recievedRequests = List<String>.from(docSnapshot['recieved_Requests']);
      });
    }
  });
}
```

**Original Code:**
```dart
Stream<QuerySnapshot> getDataRealTime() {
  return FirebaseFirestore.instance.collection('users').snapshots();
}
```

**Modified Code (Not Used):**
```dart
// Stream<QuerySnapshot> getDataRealTime() {
//  return FirebaseFirestore.instance.collection('users').snapshots();
// }
```

**Original Code:**
```dart
StreamBuilder(
  stream: recievedRequests,
  builder: (context, AsyncSnapshot snapshot) {
    // ...
  }
)
```

**Modified Code:**
```dart
StreamBuilder(
  stream: recievedRequests,
  builder: (context, AsyncSnapshot<List<String>> snapshot) {
    // ...
  }
)
```

**Original Code:**
```dart
showRecievedRequests(DocumentSnapshot userSnapshot) async {
  // ...
}
```

**Modified Code:**
```dart
showRecievedRequests(List<String> recievedRequests) {
  // ...
}
```

**Original Code:**
```dart
return FutureBuilder(
  future: getDataRealTime(),
  builder: ((context, snapshot) {
    return Text("Hello");
  }));
```

**Modified Code (Not Used):**
```dart
// return FutureBuilder(
//  future: getDataRealTime(),
//  builder: ((context, snapshot) {
//    return Text("Hello");
//  }));
```

**Original Code:**
```dart
if (snapshot.hasData) {
  if (snapshot.data['recieved_Requests'] != null) {
    if (snapshot.data['recieved_Requests'].length != 0) {
      return showRecievedRequests(userSnapshot);
    } else {
      return noRequestsWidget();
    }
  } else {
    return noRequestsWidget();
  }
} else {
  return const Center(
    child: CircularProgressIndicator(color: Colors.black),
  );
}
```

**Modified Code:**
```dart
if (recievedRequests.isEmpty) {
  return noRequestsWidget();
}

// ...
```

In summary, the modified code is adapted to work with the assumption that `recieved_Requests` is an array field in the user's document, and it fetches and processes the data accordingly. Additionally, some parts of the original code that were not necessary for the modified structure were removed. The modified code uses `List<String>` to store the UIDs of senders and fetches sender data asynchronously when needed.