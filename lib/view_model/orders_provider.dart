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
        for (var order in result.data!) {
          bool matchedOrder = cars.data!.any((car) => car.id == order.carId);
          if (matchedOrder) myOrders.add(order);
        }
        _orders = result;
        _orders.data = myOrders;
      }
      notifyListeners();
    });
  }

  updateCarOrderStatus(OrderItem order, int orderStatus) {
    order.status = orderStatus;
    FirebaseService.updateCarOrderStatus(order);
    int orderIndex = _orders.data!.indexWhere((element) => element.id == order.id);
    _orders.data![orderIndex].status = order.status;
    notifyListeners();
  }
}
