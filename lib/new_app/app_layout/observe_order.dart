import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/cubit/app/app_state.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).getMyOrders();

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is UpdateStatusSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Order status updated successfully"),
                backgroundColor: Colors.green),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title:
                const Text("My Orders", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: state is GetOrdersLoadingState
              ? const Center(child: CircularProgressIndicator())
              : cubit.myOrders.isEmpty
                  ? _buildEmptyOrders()
                  : ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: cubit.myOrders.length,
                      itemBuilder: (context, index) =>
                          _buildOrderCard(cubit.myOrders[index], context),
                    ),
        );
      },
    );
  }

  Widget _buildOrderCard(dynamic order, BuildContext context) {
    int status = order['status'];

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order #${order['id']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                _buildStatusBadge(status),
              ],
            ),
            const Divider(height: 25),
            Text("Total Amount: ${order['total_price']} EGP",
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
                "Order Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(order['created_at']))}"),
            const SizedBox(height: 15),

            // زر تأكيد الاستلام يظهر فقط إذا كانت الحالة ليست 5
            if (status != 5)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => AppCubit.get(context)
                      .updateOrderStatusToReceived(order['id']),
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.white),
                  label: const Text("Confirm Receipt",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
            else
              const Center(
                child: Text("Order Received ✅",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(int status) {
    String text;
    Color color;
    switch (status) {
      case 0:
        text = "Pending Review";
        color = Colors.orange;
        break;
      case 2:
        text = "Received";
        color = Colors.green;
        break;
      default:
        text = "In Progress";
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyOrders() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text("No previous orders",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}
