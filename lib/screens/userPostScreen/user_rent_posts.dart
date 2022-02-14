import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forrent/dataModels/rent_model.dart';
import 'package:forrent/services/rent_services.dart';

class UserRentPosts extends StatefulWidget {
  const UserRentPosts({Key? key}) : super(key: key);

  @override
  State<UserRentPosts> createState() => _UserRentPostsState();
}

class _UserRentPostsState extends State<UserRentPosts> {
  final RentServices _rentServices = RentServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/add-rent-post');
        },
      ),
      body: Container(
        color: Colors.amber,
        child: StreamBuilder<List<RentModel>>(
          stream: _rentServices
              .getStreamOfRentPostsByUserId(_auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('the error is : ${snapshot.error}');
            } else if (snapshot.data == null) {
              return const Center(
                child: Text("you don't post anything yet"),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("you don't post anything yet"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data![index].city),
                    subtitle: Text(snapshot.data![index].postdate.toString()),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
