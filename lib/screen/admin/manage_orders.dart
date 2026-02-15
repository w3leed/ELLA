// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:raf/cubit/admin_cubit/admin_cubit.dart'; 

// class ManageOrdersScreen extends StatefulWidget {
//   const ManageOrdersScreen({super.key});
//   @override
//   State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
// }

// class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
//   List _orders = [];

//   @override
//   void initState() {
//     super.initState();
//     context.read<AdminCubit>().loadAllOrders();
//   }

//   void _changeStatus(String orderId) {
//     showModalBottomSheet(context: context, builder: (_) {
//       return SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(title: const Text('تم الإرسال'), onTap: () { context.read<AdminCubit>().updateOrderStatus(orderId, 'sent'); Navigator.pop(context); }),
//             ListTile(title: const Text('قيد المراجعة'), onTap: () { context.read<AdminCubit>().updateOrderStatus(orderId, 'under_review'); Navigator.pop(context); }),
//             ListTile(title: const Text('تم التسليم'), onTap: () { context.read<AdminCubit>().updateOrderStatus(orderId, 'delivered'); Navigator.pop(context); }),
//           ],
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('إدارة الطلبات')),
//       body: BlocConsumer<AdminCubit, AdminState>(
//         listener: (context, state) {
//           if (state is AdminOrdersLoaded) {
//             _orders = state.orders;
//           } else if (state is AdminSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
//             context.read<AdminCubit>().loadAllOrders();
//           } else if (state is AdminError) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: Colors.red));
//           }
//         },
//         builder: (context, state) {
//           if (_orders.isEmpty) {
//             return const Center(child: Text('لا توجد طلبات'));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: _orders.length,
//             itemBuilder: (ctx, i) {
//               final o = _orders[i];
//               final id = o['id'] ?? o['order_id'] ?? o.id ?? 'unknown';
//               final total = o['final_amount'] ?? o['total'] ?? o.finalAmount ?? 0;
//               final status = o['status'] ?? o.status ?? 'unknown';
//               return Card(
//                 child: ListTile(
//                   title: Text('طلب #$id'),
//                   subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     Text('الاجمالي: $total'),
//                     Text('الحالة: $status'),
//                   ]),
//                   trailing: IconButton(icon: const Icon(Icons.change_circle), onPressed: () => _changeStatus(id.toString())),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
