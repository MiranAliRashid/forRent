import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forrent/dataModels/rent_model.dart';

class RentServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //get stream all rents in users collection then a document collection rent_posts by user_id
  Stream<List<RentModel>> getStreamOfRentPostsByUserId(String id) {
    return _firebaseFirestore
        .collection('users')
        .doc(id)
        .collection('rent_posts')
        .snapshots()
        .map(
          (docValue) => docValue.docs
              .map(
                (e) => RentModel.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }
}
