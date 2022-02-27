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

  //get stream all rents in users post collectiongroup order by postdate

  Stream<List<RentModel>> getStreamOfRentPosts({String? city}) {
    if (city != null) {
      return _firebaseFirestore
          .collectionGroup('rent_posts')
          .where('city', isEqualTo: city)
          .orderBy('postdate')
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
    } else {
      return _firebaseFirestore.collectionGroup('rent_posts').snapshots().map(
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

  //add new rent post to users collection then a document collection rent_posts by user_id
  addNewRentPost(String id, RentModel rentModel) async {
    final theDocReference = _firebaseFirestore
        .collection('users')
        .doc(id)
        .collection('rent_posts')
        .doc();
    Map<String, dynamic> therentModelMap = rentModel.toMap();
    therentModelMap['id'] = theDocReference.id;
    await theDocReference.set(therentModelMap);
  }

  //delete from rent_posts collection by id
  deleteRentPost(String userId, String rentId) async {
    await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('rent_posts')
        .doc(rentId)
        .delete();
  }
}
