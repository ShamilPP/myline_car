import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myline_car/model/order.dart';
import 'package:provider/provider.dart';

import '../../../../model/car.dart';
import '../../../../model/user.dart';
import '../../../../utils/constants.dart';
import '../../../../view_model/cars_provider.dart';
import '../../../../view_model/orders_provider.dart';
import '../../../../view_model/user_provider.dart';

class OrderListCard extends StatelessWidget {
  final OrderItem order;

  const OrderListCard(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Car? car = getCarFromCarId(context, order.carId);
    User? orderedUser = getUser(context, order.userId);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        title: Text(
          car?.name ?? 'Error',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Ordered by: ${orderedUser?.name ?? 'Error'}',
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              'Status: ${getStatus(order.status)}',
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),
          ],
        ),
        trailing: Text(
          DateFormat('MMM d, hh:mm a').format(order.orderTime),
          style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13),
        ),
        onTap: () {
          showOrderDialog(context);
        },
      ),
    );
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
      default:
        return '';
    }
  }

  Car? getCarFromCarId(BuildContext context, String? carId) {
    var cars = Provider.of<CarsProvider>(context, listen: false).cars;
    int index = cars.data!.indexWhere((element) => element.id == carId);
    if (index != -1) {
      return cars.data![index];
    }
    return null;
  }

  User? getUser(BuildContext context, String? userId) {
    var users = Provider.of<UserProvider>(context, listen: false).allClientUsers;
    int index = users.indexWhere((element) => element.id == userId);
    if (index != -1) {
      return users[index];
    }
    return null;
  }

  void showOrderDialog(BuildContext context) {
    Car? car = getCarFromCarId(context, order.carId);
    User? orderedUser = getUser(context, order.userId);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(top: 7), child: Text('Car : ${car?.name ?? 'Error'}')),
              Padding(padding: const EdgeInsets.only(top: 7), child: Text('Client : ${orderedUser?.name ?? 'Error'}')),
              Padding(padding: const EdgeInsets.only(top: 7), child: Text('Client Phone: ${orderedUser?.phone ?? 'Error'}')),
              // const Padding(padding: EdgeInsets.only(top: 7), child: Text('Client Location: Unavailable')),
              Padding(padding: const EdgeInsets.only(top: 7), child: Text('Date: ${DateFormat('MMM d, yyyy').format(order.orderTime)}')),
              Padding(padding: const EdgeInsets.only(top: 7), child: Text('Time: ${DateFormat('hh:mm a').format(order.orderTime)}')),
              Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    'Status: ${getStatus(order.status)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),

              if (order.status == OrderStatus.pending)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: Material(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                Provider.of<OrdersProvider>(context, listen: false).updateCarOrderStatus(order, OrderStatus.accepted);
                                Navigator.pop(context);
                              },
                              child: Ink(
                                child: const Icon(Icons.check_rounded, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: Material(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                Provider.of<OrdersProvider>(context, listen: false).updateCarOrderStatus(order, OrderStatus.rejected);
                                Navigator.pop(context);
                              },
                              child: Ink(
                                child: const Icon(Icons.close_rounded, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
