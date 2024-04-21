import 'package:flutter/material.dart';
import 'package:myline_car/model/result.dart';
import 'package:myline_car/service/firebase_services.dart';

import '../model/car.dart';

class CarsProvider extends ChangeNotifier {
  Result<List<Car>> _cars = Result.initial();

  Result<List<Car>> get cars => _cars;

  void loadCars(String phone) async {
    // Search own car by phone number
    _cars = await FirebaseService.getCarsByPhone(phone);
    notifyListeners();
  }

  Future<Result<Car>> uploadCar(Car car) async {
    var result = await FirebaseService.createNewCar(car);
    _cars.data!.add(car);
    notifyListeners();
    return result;
  }

  Future<Result<Car>> updateCar(Car car) async {
    var result = await FirebaseService.updateCar(car);
    int carIndex = _cars.data!.indexWhere((element) => element.id == car.id);
    if (carIndex != -1) {
      _cars.data![carIndex] = car;
      notifyListeners();
    } else {
      return Result.error('This item cannot be found in the old list.');
    }
    return result;
  }
}
