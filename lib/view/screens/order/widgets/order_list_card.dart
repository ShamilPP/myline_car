import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myline_car/model/order.dart';
import 'package:myline_car/utils/colors.dart';
import 'package:myline_car/view_model/orders_provider.dart';
import 'package:myline_car/view_model/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../../model/car.dart';
import '../../../../model/user.dart';
import '../../../../utils/constants.dart';
import '../../../../view_model/cars_provider.dart';

class OrderListCard extends StatelessWidget {
  final OrderItem order;

  const OrderListCard(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    Car car = getCarFromCarId(context, order.carId);
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: colors.primaryColor),
          child: ListTile(
            title: Text(
              car.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: colors.foreColor),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order by : ${getUser(context, order.userId).name}',
                    style: TextStyle(color: colors.foreColor, fontStyle: FontStyle.italic, fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Status : ${getStatus(order.status)}',
                    style: TextStyle(color: colors.foreColor, fontStyle: FontStyle.italic, fontSize: 14),
                  ),
                  if (order.status == OrderStatus.pending)
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 30,
                            width: 45,
                            child: Material(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  order.status = OrderStatus.accepted;
                                  Provider.of<OrdersProvider>(context, listen: false).updateCarOrderStatus(order);
                                },
                                child: Ink(
                                  child: const Icon(Icons.check_rounded, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            width: 45,
                            child: Material(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  order.status = OrderStatus.rejected;
                                  Provider.of<OrdersProvider>(context, listen: false).updateCarOrderStatus(order);
                                },
                                child: Ink(
                                  child: const Icon(Icons.close_rounded, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
            trailing: Text(
              DateFormat('hh:mm a').format(order.orderTime),
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13),
            ),
          ),
        ));
  }

  String getStatus(int status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.rejected:
        return 'Rejected';
      case OrderStatus.done:
        return 'Done';
    }
    return '';
  }

  Car getCarFromCarId(BuildContext context, String? carId) {
    var cars = Provider.of<CarsProvider>(context, listen: false).cars;
    return cars.data!.singleWhere((element) => element.id == carId);
  }

  User getUser(BuildContext context, String? userId) {
    var users = Provider.of<UserProvider>(context, listen: false).allClientUsers;
    return users.singleWhere((element) => element.id == userId);
  }
}
