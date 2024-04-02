import 'package:flutter/material.dart';
import 'package:myline_car/model/result.dart';
import 'package:myline_car/view/screens/car/car_screen.dart';
import 'package:myline_car/view/screens/order/orders_screen.dart';
import 'package:myline_car/view/screens/profile/profile_screen.dart';
import 'package:myline_car/view_model/cars_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyLine'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Orders':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
                  break;
                case 'Profile':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Orders', 'Profile'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Consumer<CarsProvider>(builder: (ctx, provider, child) {
        if (provider.cars.status == Status.success) {
          var cars = provider.cars.data!;
          if (cars.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text("Cars(${cars.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: cars.length,
                      separatorBuilder: (ctx, index) => const Divider(height: 0),
                      itemBuilder: (ctx, index) {
                        var car = cars[index];
                        return ListTile(
                          title: Text(
                            car.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => CarScreen(car: car)));
                          },
                        );
                      }),
                ],
              ),
            );
          } else {
            return const Center(
                child: Text(
              'No cars',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ));
          }
        } else if (provider.cars.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.cars.status == Status.loading) {
          return Center(child: Text(provider.cars.message.toString()));
        } else {
          return const SizedBox();
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CarScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
