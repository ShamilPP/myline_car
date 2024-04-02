import 'package:flutter/material.dart';
import 'package:myline_car/view/screens/order/widgets/order_list_card.dart';
import 'package:provider/provider.dart';

import '../../../model/order.dart';
import '../../../model/result.dart';
import '../../../view_model/orders_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrdersProvider>(context, listen: false).loadOrders(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: Center(
        child: Consumer<OrdersProvider>(
          builder: (ctx, provider, child) {
            if (provider.orders.status == Status.success) {
              List<OrderItem> orders = provider.orders.data!;
              if (orders.isNotEmpty) {
                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (buildContext, index) {
                      return OrderListCard(orders[index]);
                    });
              } else {
                return const Text('No orders');
              }
            } else if (provider.orders.status == Status.loading) {
              return const CircularProgressIndicator();
            } else if (provider.orders.status == Status.error) {
              return Text('Error : ${provider.orders.message}');
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
