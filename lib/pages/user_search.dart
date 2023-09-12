import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserSearch extends StatefulWidget {
  UserSearch({super.key});
  final TextEditingController _searchController = TextEditingController();
  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  String? _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(69),
        child: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            centerTitle: true,
            title: const Text(
              "Chat@",
              textAlign: TextAlign.center,
              style: TextStyle(
                //fontFamily: 'Borel',
                fontSize: 30,
                fontWeight: FontWeight.w200,
              ),
            )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: textInputDecoration.copyWith(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  onPressed: () {
                    //_searchQuery!.clear();
                  },
                  icon: const Icon(Icons.clear),
                  color: Colors.black,
                ),
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: getDataRealTime(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              var documents = snapshot.data!.docs;
              // Filter data based on searchQuery
              var filteredData = documents.where((doc) {
                var data = doc.data() as Map<String, dynamic>;
                String title = data['username'].toString().toLowerCase();
                return title.contains(_searchQuery!.toLowerCase());
              }).toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var data =
                        filteredData[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['username']),
                      subtitle: Text(data['email']),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getDataRealTime() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }
}
