import 'package:flutter/material.dart';
import 'package:forrent/screens/allPostScreen/goto_user_profile.dart';
import '../dataModels/rent_model.dart';
import 'package:intl/intl.dart';

var formatter = NumberFormat('###,000');

Widget postCard(List<RentModel>? data, int index, BuildContext context) {
  //get the username from user collection

  return Container(
    decoration: BoxDecoration(
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 7.0, // soften the shadow
          spreadRadius: 3.5, //extend the shadow
          offset: Offset(
            0.0, // Move to right 10  horizontally
            0.0, // Move to bottom 10 Vertically
          ),
        )
      ],
      borderRadius: BorderRadius.circular(20),
      color: const Color.fromARGB(255, 239, 248, 248),
    ),
    alignment: Alignment.center,
    // padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.all(12),
    width: 300,
    //height: 400,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //show the image of the post while loading show a progress indicator
          SizedBox(
            width: 400,
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Image.network(
                data![index].imgurl,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data[index].city,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w400),
                ),
                Text(
                  formatter.format(int.parse(data[index].rentprice)) + " IQD",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            alignment: Alignment.centerLeft,
            width: 300,
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              data[index].address,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text(
              data[index].discreption,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Posted by: ",
                      style:
                          TextStyle(color: Color.fromARGB(255, 114, 114, 114)),
                    ),
                    Text(data[index].username),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VisiteProfile(
                                    userId: data[index].userid,
                                  )));
                    },
                    child: const Text("User Profile"))
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
