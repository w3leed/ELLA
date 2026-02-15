// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:raf/cubit/admin_cubit/admin_cubit.dart';
// // import '../../models/offer_model.dart'; 
// // import 'add_offer.dart';

// // class ManageOffersScreen extends StatefulWidget {
// //   const ManageOffersScreen({super.key});
// //   @override
// //   State<ManageOffersScreen> createState() => _ManageOffersScreenState();
// // }

// // class _ManageOffersScreenState extends State<ManageOffersScreen> {
// //   List<OfferModel> _offers = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     context.read<AdminCubit>().loadSalesReport('daily'); // use loadOffers if exists
// //   }

// //   void _onEdit(OfferModel o) {
// //     Navigator.push(context, MaterialPageRoute(builder: (_) => AddOfferScreen(offer: o)));
// //   }

// //   void _onDelete(OfferModel o) {
// //     showDialog(context: context, builder: (_) => AlertDialog(
// //       title: const Text('تأكيد الحذف'),
// //       content: Text('هل تريد حذف العرض "${o.title}"؟'),
// //       actions: [
// //         TextButton(onPressed: () => Navigator.pop(context), child: const Text('لا')),
// //         ElevatedButton(onPressed: () {
// //           context.read<AdminCubit>().deleteOffer(o.id);
// //           Navigator.pop(context);
// //         }, child: const Text('حذف'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
// //       ],
// //     ));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('إدارة العروض')),
// //       body: BlocConsumer<AdminCubit, AdminState>(
// //         listener: (context, state) {
// //           if (state is AdminLoading) {
// //             final raw = state.props;
// //             // _offers = raw.map((e) => e is OfferModel ? e : OfferModel.fromMap(Map<String, dynamic>.from(e))).toList();
// //           _offers = raw
// //     .map((e) => OfferModel.fromMap((e as Map).cast<String, dynamic>()))
// //     .toList();

// //           } else if (state is AdminSuccess) {
// //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
// //             context.read<AdminCubit>().loadOffers();
// //           } else if (state is AdminError) {
// //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: Colors.red));
// //           }
// //         },
// //         builder: (context, state) {
// //           return Column(
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.all(12),
// //                 child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddOfferScreen())), icon: const Icon(Icons.add), label: const Text('إضافة عرض')),
// //               ),
// //               Expanded(
// //                 child: _offers.isEmpty ? const Center(child: Text('لا توجد عروض')) : ListView.builder(
// //                   itemCount: _offers.length,
// //                   itemBuilder: (ctx, i) {
// //                     final o = _offers[i];
// //                     return Card(
// //                       child: ListTile(
// //                         leading: o.image != null && o.image!.isNotEmpty ? Image.network(o.image!, width: 56, height: 56, fit: BoxFit.cover) : null,
// //                         title: Text(o.title),
// //                         subtitle: Text('خصم ${o.discountPercentage}% - حد أدنى: ${o.minPurchase}'),
// //                         trailing: Row(mainAxisSize: MainAxisSize.min, children: [
// //                           IconButton(icon: const Icon(Icons.edit), onPressed: () => _onEdit(o)),
// //                           IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _onDelete(o)),
// //                         ]),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:raf/cubit/admin_cubit/admin_cubit.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../models/offer_model.dart';

// class ManageOffersScreen extends StatefulWidget {
//   const ManageOffersScreen({super.key});

//   @override
//   State<ManageOffersScreen> createState() => _ManageOffersScreenState();
// }

// class _ManageOffersScreenState extends State<ManageOffersScreen> {
//   List _offers = [];
//   final picker = ImagePicker();
//   File? selectedImage;

//   @override
//   void initState() {
//     super.initState();
//     context.read<AdminCubit>().loadOffers();
    
//              context.read<AdminCubit>().loadOffers().then((v) {
//               print(v);
//               setState(() => _offers = v);} );
//   }

//   Future<String?> uploadImage(File file) async {
//     try {
//       final fileName = "offer_${DateTime.now().millisecondsSinceEpoch}.jpg";

//       await Supabase.instance.client.storage
//           .from("offers")
//           .upload(fileName, file);

//       final url =
//           Supabase.instance.client.storage.from("offers").getPublicUrl(fileName);

//       return url;
//     } catch (e) {
//       debugPrint("Upload Offer error: $e");
//       return null;
//     }
//   }

//   void _showAddEditDialog({OfferModel? offer}) {
//     final titleCtl = TextEditingController(text: offer?.title ?? '');
//     final discountCtl =
//         TextEditingController(text: offer?.discountPercentage.toString() ?? "");
//     final minAmountCtl =
//         TextEditingController(text: offer?.minPurchase.toString() ?? "");
//     final descCtl = TextEditingController(text: offer?.description ?? "");

//     selectedImage = null;

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setStateDialog) => AlertDialog(
//           title: Text(offer == null ? "إضافة عرض" : "تعديل عرض"),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: titleCtl,
//                   decoration: const InputDecoration(labelText: "عنوان العرض"),
//                 ),
//                 TextField(
//                   controller: discountCtl,
//                   decoration: const InputDecoration(labelText: "نسبة الخصم %"),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: minAmountCtl,
//                   decoration: const InputDecoration(labelText: "الحد الأدنى للمبلغ"),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: descCtl,
//                   decoration:
//                       const InputDecoration(labelText: "وصف العرض (اختياري)"),
//                 ),
//                 const SizedBox(height: 10),

//                 // Image picker box
//                 InkWell(
//                   onTap: () async {
//                     final picked =
//                         await picker.pickImage(source: ImageSource.gallery);
//                     if (picked != null) {
//                       setStateDialog(() => selectedImage = File(picked.path));
//                     }
//                   },
//                   child: Container(
//                     height: 120,
//                     width: double.infinity,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
//                     child: selectedImage != null
//                         ? Image.file(selectedImage!, fit: BoxFit.cover)
//                         : (offer != null)
//                             ? Image.network(offer.image, fit: BoxFit.cover)
//                             : const Text("اختر صورة"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("إلغاء"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String imageUrl = offer?.image ?? "";

//                 if (selectedImage != null) {
//                   final uploaded = await uploadImage(selectedImage!);
//                   if (uploaded != null) imageUrl = uploaded;
//                 }

//                 final newOffer = OfferModel(
//                   id: offer?.id ??
//                       DateTime.now().millisecondsSinceEpoch.toString(),
//                   title: titleCtl.text.trim(),
//                   description: descCtl.text.trim(),
//                   image: imageUrl,
//                   discountPercentage:
//                       double.tryParse(discountCtl.text.trim()) ?? 0.0,
//                   minPurchase:
//                       double.tryParse(minAmountCtl.text.trim()) ?? 0.0,
//                   createdAt: DateTime.now(),
//                 );

//                 final cubit = context.read<AdminCubit>();
//                 offer == null
//                     ? cubit.addOffer(newOffer)
//                     : cubit.updateOffer(newOffer);

//                 Navigator.pop(context);
//               },
//               child: Text(offer == null ? "إضافة" : "حفظ"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("إدارة العروض")),
//       body: BlocConsumer<AdminCubit, AdminState>(
//         listener: (context, state) {
//           //      if (state is AdminLoading) {
//           //   print(state.props );
//           //   // setState(() => _categories = state.props as List<CategoryModel> );
//           // }

//           if (state is AdminLoading) {
          
//              context.read<AdminCubit>().loadOffers().then((v) {
//               print(v);
//               setState(() => _offers = v);
//             });
//             // print(state.props);
//             //  setState(() => _categories = state.props as List<CategoryModel> );
//           }
//           if (state is AdminLoading) {
        
//           }
//         },
//         builder: (context, state) {
//           return Column(
//             children: [
//               const SizedBox(height: 10),
//               ElevatedButton.icon(
//                 onPressed: () => _showAddEditDialog(),
//                 icon: const Icon(Icons.add),
//                 label: const Text("إضافة عرض"),
//               ),
//               Expanded(
//                 child: state is AdminLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                         itemCount: _offers.length,
//                         itemBuilder: (_, i) {
//                           final o = _offers[i];
//                           return Card(
//                             child: ListTile(
//                               leading: o['image_url'] != null
//                                   ? Image.network(o['image_url'], width: 60, height: 60)
//                                   : null,
//                               title: Text(o['title']),
//                               subtitle: Text(
//                                   "خصم: ${o['discount_percent']}% - حد أدنى: ${o['min_order_amount']}"),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.edit),
//                                     onPressed: () => _showAddEditDialog(
//                                       offer: OfferModel(
//                                         id: o['id'],
//                                         title: o['title'],
//                                         image: o['image_url'],
//                                         description: o['description'],
//                                         discountPercentage:
//                                             double.parse(o['discount_percent'].toString()),
//                                         minPurchase:
//                                             double.parse(o['min_order_amount'].toString()),
//                                         createdAt: DateTime.parse(o['created_at']),
//                                       ),
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete, color: Colors.red),
//                                     onPressed: () {
//                                       context.read<AdminCubit>().deleteOffer(o['id']);
//                                     },
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
