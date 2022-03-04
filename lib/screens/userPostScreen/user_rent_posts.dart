import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forrent/dataModels/rent_model.dart';
import 'package:forrent/screens/userPostScreen/edit_rent_post.dart';
import 'package:forrent/services/rent_services.dart';
import 'package:forrent/widgets/buttons.dart';
import 'package:forrent/widgets/posts.dart';

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
    if (_auth.currentUser!.phoneNumber != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 239, 248, 248),
          foregroundColor: const Color.fromARGB(255, 62, 128, 177),
          centerTitle: true,
          elevation: 0,
          title: const Text('My Rent Posts'),
        ),
        floatingActionButton: SizedBox(
          width: 80,
          height: 40,
          child: FloatingActionButton(
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: const Color.fromARGB(255, 62, 128, 177),
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addrentpost');
            },
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 247, 247, 247),
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
                    // return ListTile(
                    //   title: Text(snapshot.data![index].city),
                    //   subtitle: Text(DateFormat('dd-MM-yyyy')
                    //       .format(snapshot.data![index].postdate.toDate())),
                    // );
                    return Stack(
                      fit: StackFit.values[2],
                      children: [
                        postCard(snapshot.data, index, context),
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Container(
                            margin: const EdgeInsets.all(5),

                            alignment: Alignment.bottomCenter,
                            height: 40,

                            decoration: BoxDecoration(
                              color: const Color.fromARGB(120, 0, 0, 0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            //make a dropbdown menu to delete and edit
                            child: DropdownButton(
                              alignment: Alignment.bottomCenter,
                              underline: Container(
                                margin: const EdgeInsets.only(top: 60),
                                child: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              iconSize: 0.0,
                              items: const [
                                DropdownMenuItem(
                                  child: Text('Edit'),
                                  value: 'edit',
                                ),
                                DropdownMenuItem(
                                  child: Text('Delete'),
                                  value: 'delete',
                                ),
                              ],
                              onChanged: (value) {
                                if (value == 'edit') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditRentPost(
                                                mypost: snapshot.data![index],
                                              )));
                                } else if (value == 'delete') {
                                  _rentServices.deleteRentPost(
                                      _auth.currentUser!.uid,
                                      snapshot.data![index].id);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 239, 248, 248),
          foregroundColor: const Color.fromARGB(255, 62, 128, 177),
          centerTitle: true,
          elevation: 0,
          title: const Text('ForRent'),
        ),
        body: Container(
          color: const Color.fromARGB(255, 216, 216, 216),
          child: Center(
            child: Card(
                elevation: 1,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'You don\'t have an account \n Please Register or login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("for you to able to add posts"),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: general_button(
                          text: 'Register',
                          onpressed: () {
                            Navigator.pushNamed(context, '/register')
                                .then((value) {
                              setState(() {});
                            });
                          },
                          backgroundColor:
                              const Color.fromARGB(255, 136, 191, 233),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: general_button(
                          text: 'Login',
                          onpressed: () {
                            Navigator.pushNamed(context, '/login')
                                .then((value) {
                              setState(() {});
                            });
                          },
                          backgroundColor:
                              const Color.fromARGB(255, 136, 191, 233),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      );
    }
  }
}
