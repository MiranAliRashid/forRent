import 'package:flutter/material.dart';

import '../dataModels/rent_model.dart';

Widget postCard(List<RentModel>? data, int index) {
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
    height: 400,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //show the image of the post while loading show a progress indicator
        Container(
          width: 400,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
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

        // Container(
        //   height: 200,
        //   decoration: BoxDecoration(
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(20),
        //       topRight: Radius.circular(20),
        //     ),
        //     image: DecorationImage(
        //       image: NetworkImage(data![index].imgurl),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                data[index].city,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              Text(
                "Price: " + data[index].rentprice,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          alignment: Alignment.center,
          width: 300,
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            data[index].address,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Text(
            data[index].discreption,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
          ),
        )
      ],
    ),
  );
}
