// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:raf/cubit/auth/auth_cubit.dart';
// import 'package:raf/cubit/order_cubit/order_cubit.dart';
// import 'package:raf/cubit/order_cubit/order_state.dart'; 
// import '../../widgets/empty_message.dart';

// class OrdersScreen extends StatefulWidget {
//   const OrdersScreen({super.key});

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {

//   @override
//   void initState() {
//     super.initState();

//     final user = context.read<AuthCubit>().currentUser;
//     if (user != null) {
//       context.read<OrderCubit>().loadUserOrders(user.id);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("طلباتي")),

//       body: BlocBuilder<OrderCubit, OrderState>(
//         builder: (context, state) {

//           if (state is OrderLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is OrderError) {
//             return Center(child: Text(state.message));
//           }

//           if (state is OrderSuccess) {
//             final orders = state.orders;

//             if (orders.isEmpty) {
//               return const EmptyMessage(text: "لا توجد طلبات حالياً");
//             }

//             return ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: orders.length,
//               itemBuilder: (context, i) {
//                 final o = orders[i];

//                 return Card(
//                   elevation: 2,
//                   margin: const EdgeInsets.only(bottom: 12),
//                   child: ListTile(
//                     title: Text("طلب رقم: ${o.id}"),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("الإجمالي: ${o.finalTotal} ج.م"),
//                         Text("الحالة: ${o.status}"),
//                         Text("التاريخ: ${o.createdAt}"),
//                       ],
//                     ),
//                     trailing: Icon(
//                       o.status == "مكتمل"
//                           ? Icons.check_circle
//                           : Icons.hourglass_top,
//                       color: o.status == "مكتمل" ? Colors.green : Colors.orange,
//                     ),
//                   ),
//                 );
//               },
//             );
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }
