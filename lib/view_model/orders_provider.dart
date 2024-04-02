import 'package:flutter/material.dart';
import 'package:myline_car/service/firebase_services.dart';
import 'package:myline_car/view_model/cars_provider.dart';
import 'package:provider/provider.dart';

import '../model/order.dart';
import '../model/result.dart';

class OrdersProvider extends ChangeNotifier {
  Result<List<OrderItem>> _orders = Result.initial();

  Result<List<OrderItem>> get orders => _orders;

  void loadOrders(BuildContext context) {
    _orders.status = Status.loading;
    notifyListeners();
    var cars = Provider.of<CarsProvider>(context, listen: false).cars;
    FirebaseService.getAllCarOrders().then((result) {
      List<OrderItem> myOrders = [];
      if (result.status == Status.success && cars.status == Status.success) {
        for (var car in cars.data!) {
          var matchedOrder = result.data!.where((order) => order.carId == car.id);
          myOrders.addAll(matchedOrder);
        }
        _orders = result;
        _orders.data = myOrders;
      }
      notifyListeners();
    });
  }

  updateCarOrderStatus(OrderItem order) {
    FirebaseService.updateCarOrderStatus(order);
    int orderIndex = _orders.data!.indexWhere((element) => element.id == order.id);
    _orders.data![orderIndex].status = order.status;
    notifyListeners();
  }
}
