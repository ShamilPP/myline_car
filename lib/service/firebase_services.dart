import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myline_car/model/car.dart';
import 'package:myline_car/model/result.dart';
import 'package:myline_car/model/user.dart';
import 'package:myline_car/utils/constants.dart';

import '../model/order.dart';
import '../view_model/utils/helper.dart';

class FirebaseService {
  static Future<Result<List<User>>> getClientUsers() async {
    try {
      List<User> users = [];
      var collection = FirebaseFirestore.instance.collection('users');
      var allDocs = await collection.get();
      for (var user in allDocs.docs) {
        if (user.get('userType') == UserType.client) {
          users.add(User(
            id: user.id,
            name: user.get('name'),
            phone: user.get('phone'),
          ));
        }
      }
      return Result.success(users);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<User?>> getUserWithPhone(String phone) async {
    try {
      var collection = FirebaseFirestore.instance.collection('users');
      var users = await collection.where('phone', isEqualTo: phone).get();
      for (var user in users.docs) {
        if (user.get('userType') == UserType.car_owner) {
          return Result.success(User(
            id: user.id,
            name: user.get('name'),
            phone: user.get('phone'),
          ));
        }
      }
      return Result.success(null);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<User>> getUserWithUserId(String userId) async {
    try {
      var collection = FirebaseFirestore.instance.collection('users');
      var user = await collection.doc(userId).get();
      if (user.exists) {
        if (user.get('userType') == UserType.car_owner) {
          return Result.success(User(
            id: userId,
            name: user.get('name'),
            phone: user.get('phone'),
          ));
        } else {
          return Result.error('Error : No users found');
        }
      } else {
        return Result.error('No users found');
      }
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<List<Car>>> getCarByPhone(String phone) async {
    try {
      List<Car> cars = [];

      var collection = FirebaseFirestore.instance.collection('cars');
      var allDocs = await collection.get();
      for (var car in allDocs.docs) {
        if (car.get('phone') == phone) {
          cars.add(Car(
            id: car.id,
            name: car.get('name'),
            km: car.get('km'),
            images: List<String>.from(car.get('images')),
            phone: car.get('phone'),
            price: car.get('price'),
            type: car.get('type'),
            year: car.get('year'),
            thumbUrl: car.get('thumbUrl'),
          ));
        }
      }
      return Result.success(cars);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<List<OrderItem>>> getAllCarOrders() async {
    try {
      List<OrderItem> orders = [];
      var collection = FirebaseFirestore.instance.collectionGroup("orders").where("type", isEqualTo: OrderType.car).orderBy("orderTime", descending: true);
      var allDocs = await collection.get();
      for (var doc in allDocs.docs) {
        orders.add(OrderItem(
          id: doc.id,
          userId: doc.reference.parent.parent!.id,
          carId: doc.get('carId'),
          token: doc.get('token'),
          status: doc.get('status'),
          type: doc.get('type'),
          orderTime: doc.get('orderTime').toDate(),
        ));
      }
      return Result.success(orders);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<User>> createNewCarOwner(User user) async {
    try {
      var users = FirebaseFirestore.instance.collection('users');
      var result = await users.add({
        'name': user.name,
        'phone': user.phone,
        'userType': UserType.car_owner,
      });
      user.id = result.id;
      return Result.success(user);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<Car>> createNewCar(Car car) async {
    try {
      var cars = FirebaseFirestore.instance.collection('cars');
      List<String> imagesUrls = [];
      // Images Upload
      for (var image in car.images) {
        // Set image name
        String imageExtension = image.substring(image.lastIndexOf("."));
        String imageName = Helper.commonImageName(imageExtension);
        String storePath = 'cars/$imageName';
        // Upload image to firebase storage
        Result<String> imageUrl = await uploadImage(image, storePath);
        // to add image list
        if (imageUrl.data != null && imageUrl.status == Status.success) imagesUrls.add(imageUrl.data!);
      }
      // Verifying all uploaded images for accuracy and compliance
      if (car.images.length == imagesUrls.length) {
        //Set image urls to car images
        car.images = imagesUrls;
        car.thumbUrl = imagesUrls.first;

        //Then upload
        var result = await cars.add({
          'thumbUrl': car.thumbUrl,
          'images': car.images,
          'name': car.name,
          'phone': car.phone,
          'price': car.price,
          'type': car.type,
          'year': car.year,
          'km': car.km,
        });
        car.id = result.id;
        return Result.success(car);
      } else {
        return Result.error('Image uploading error');
      }
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<Car>> updateCar(Car car) async {
    try {
      var cars = FirebaseFirestore.instance.collection('cars');
      await cars.doc(car.id).update({
        'name': car.name,
        'phone': car.phone,
        'price': car.price,
        'type': car.type,
        'year': car.year,
        'km': car.km,
      });
      return Result.success(car);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<String>> uploadImage(String imagePath, String storePath) async {
    try {
      final firebaseStorage = FirebaseStorage.instance;
      var file = File(imagePath);
      var snapshot = await firebaseStorage.ref().child(storePath).putFile(file);
      String imageUrl = await snapshot.ref.getDownloadURL();
      return Result.success(imageUrl);
    } catch (e) {
      return Result.error('Error detected : $e');
    }
  }

  static Future<Result<bool>> updateUser(User user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        'name': user.name,
        'phone': user.phone,
      });

      return Result.success(true);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  static Future<Result<bool>> updateCarOrderStatus(OrderItem order) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(order.userId).collection('orders').doc(order.id).update({
        'status': order.status,
      });

      return Result.success(true);
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}
