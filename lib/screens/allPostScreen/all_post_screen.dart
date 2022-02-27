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

  // Initial Selected Value
  String fliterCity = 'City';

  // List of items in our dropdown menu
  var items = ['City', 'Sulaimaniyah', 'Hawler', 'Karkwk', 'Dhok', 'Halabja'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 248, 248),
        foregroundColor: const Color.fromARGB(255, 62, 128, 177),
        centerTitle: true,
        elevation: 0,
        title: Text('Rent Posts'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.filter_list,
                size: 30,
              ),
              onPressed: () {
                _buildFilterDialog(context);
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 247, 247, 247),
        child: StreamBuilder<List<RentModel>>(
          stream: _rentServices.getStreamOfRentPosts(
              city: fliterCity == "City" ? null : fliterCity),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('the error is : ${snapshot.error}');
            } else if (snapshot.data == null) {
              return const Center(
                child: Text("no post  yet 1"),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("no posts yet"),
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

  _buildFilterDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Filter by City'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton(
                  isExpanded: true,
                  underline: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  // Initial Value
                  value: fliterCity,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      fliterCity = newValue!;
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('Clear Filter'),
                onPressed: () {
                  setState(() {
                    fliterCity = 'City';
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
  }
}
