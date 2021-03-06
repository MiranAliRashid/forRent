import 'package:flutter/material.dart';
import 'package:forrent/widgets/buttons.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class VisiteProfile extends StatefulWidget {
  const VisiteProfile({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  State<VisiteProfile> createState() => _VisiteProfileState();
}

class _VisiteProfileState extends State<VisiteProfile> {
  @override
  Widget build(BuildContext context) {
    Provider.of<AuthService>(context).getUserById(widget.userId);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 248, 248),
        foregroundColor: const Color.fromARGB(255, 62, 128, 177),
        centerTitle: true,
        elevation: 0,
        title: const Text('Profile'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder(
          future: Provider.of<AuthService>(context, listen: false)
              .getUserById(widget.userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Container(
                    color: const Color.fromARGB(255, 239, 248, 248),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 87),
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(105, 0, 0, 0),
                            offset: Offset(0, -2),
                            blurRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 90,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data.username,
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("phone : "),
                                ),
                                Text(
                                  snapshot.data.phone,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Center(
                            child: general_button(
                                onpressed: () {
                                  _makePhoneCall(snapshot.data.phone);
                                },
                                text: "call",
                                backgroundColor:
                                    const Color.fromARGB(255, 159, 205, 236)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          snapshot.data.imgurl != ""
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        const Color.fromARGB(255, 62, 128, 177),
                                    radius: 80,
                                    backgroundImage: NetworkImage(
                                      snapshot.data.imgurl,
                                    ),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 62, 128, 177),
                                    radius: 80,
                                    child: Text(
                                      "image",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }
}
