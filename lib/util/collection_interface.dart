import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class CollectionInterface {
  const CollectionInterface._();

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final support = firestore.collection(CollectionConstants.helpCenter).withConverter<SupportModel>(
        fromFirestore: (snapshot, _) => SupportModel.fromMap(snapshot.data()!),
        toFirestore: (data, _) => data.toMap(),
      );

  static final orders = firestore.collection(CollectionConstants.orders).withConverter<OrderModel>(
        fromFirestore: (snapshot, _) => OrderModel.fromMap(snapshot.data()!),
        toFirestore: (data, _) => data.toMap(),
      );

  static final categories = firestore.collection(CollectionConstants.categories).withConverter<CategoryModel>(
        fromFirestore: (snapshot, _) => CategoryModel.fromMap(snapshot.data()!),
        toFirestore: (data, _) => data.toMap(),
      );

  static CollectionReference<PropertyConfigModel> properties(String categoryId) => firestore
      .collection(CollectionConstants.categories)
      .doc(categoryId)
      .collection(CollectionConstants.properties)
      .withConverter<PropertyConfigModel>(
        fromFirestore: (snapshot, _) => PropertyConfigModel.fromMap(snapshot.data()!),
        toFirestore: (data, _) => data.toMap(),
      );

  static final subcategories = firestore.collection(CollectionConstants.subcategories).withConverter<SubcategoryConfigModel>(
        fromFirestore: (snapshot, _) => SubcategoryConfigModel.fromMap(snapshot.data()!),
        toFirestore: (data, _) => data.toMap(),
      );
}
