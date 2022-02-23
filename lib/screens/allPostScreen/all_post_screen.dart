import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forrent/dataModels/rent_model.dart';
import 'package:forrent/services/rent_services.dart';
import 'package:forrent/widgets/posts.dart';

class AllPostScreen extends StatefulWidget {
  const AllPostScreen({Key? key}) : super(key: key);

  @override
  State<AllPostScreen> createState() => _UserRentPostsState();
}

class _UserRentPostsState extends State<AllPostScreen> {
  final RentServices _rentServices = RentServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 248, 248),
        foregroundColor: const Color.fromARGB(255, 62, 128, 177),
        centerTitle: true,
        elevation: 0,
        title: Text('Rent Posts'),
      ),
      body: Container(
        color: Color.fromARGB(255, 247, 247, 247),
        child: StreamBuilder<List<RentModel>>(
          stream: _rentServices.getStreamOfRentPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('the error is : ${snapshot.error}');
            } else if (snapshot.data == null) {
              return const Center(
                child: Text("you don't post anything yet 1"),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("you don't post anything yet 2"),
              );
            } else {
              snapshot.data!.sort((a, b) => b.postdate.compareTo(a.postdate));
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  // return ListTile(
                  //   title: Text(snapshot.data![index].city),
                  //   subtitle: Text(DateFormat('dd-MM-yyyy')
                  //       .format(snapshot.data![index].postdate.toDate())),
                  // );
                  return postCard(snapshot.data, index);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
