// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:raf/cubit/admin_cubit/admin_cubit.dart'; 
// import '../../models/offer_model.dart';

// class AddOfferScreen extends StatefulWidget {
//   final OfferModel? offer;
//   const AddOfferScreen({super.key, this.offer});

//   @override
//   State<AddOfferScreen> createState() => _AddOfferScreenState();
// }

// class _AddOfferScreenState extends State<AddOfferScreen> {
//   final _title = TextEditingController();
//   final _discount = TextEditingController();
//   final _minAmount = TextEditingController();
//   final _image = TextEditingController();
//   final _description = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     if (widget.offer != null) {
//       _title.text = widget.offer!.title;
//       _discount.text = widget.offer!.discountPercentage.toString();
//       _minAmount.text = widget.offer!.minPurchase.toString();
//       _image.text = widget.offer!.image ?? '';
// _description.text=widget.offer!.description??'';
//     }
//   }

//   void _submit() {
//     final cubit = context.read<AdminCubit>();
//     final offer = OfferModel(
//       id: widget.offer?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//       title: _title.text.trim(),
    
//       image: _image.text.trim(),
//       discountPercentage: double.tryParse(_discount.text.trim()) ?? 0.0,
//       minPurchase: double.tryParse(_minAmount.text.trim()) ?? 0.0,
//        description: _description.text,
//         createdAt: DateTime.now(),
   
//     );
//     if (widget.offer == null) {
//       cubit.addOffer(offer);
//     } else {
//       cubit.updateOffer(offer);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.offer == null ? 'إضافة عرض' : 'تعديل العرض')),
//       body: BlocConsumer<AdminCubit, AdminState>(
//         listener: (context, state) {
//           if (state is AdminSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
//             if (widget.offer == null) {
//               _title.clear(); _discount.clear(); _minAmount.clear(); _image.clear();
//             }
//           } else if (state is AdminError) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: Colors.red));
//           }
//         },
//         builder: (context, state) {
//           final loading = state is AdminLoading;
//           return Padding(
//             padding: const EdgeInsets.all(12),
//             child: ListView(
//               children: [
//                 TextField(controller: _title, decoration: const InputDecoration(labelText: 'عنوان العرض')),
//                 const SizedBox(height: 8),
//                 TextField(controller: _discount, decoration: const InputDecoration(labelText: 'نسبة الخصم %'), keyboardType: TextInputType.number),
//                 const SizedBox(height: 8),
//                 TextField(controller: _minAmount, decoration: const InputDecoration(labelText: 'الحد الأدنى للمبلغ'), keyboardType: TextInputType.number),
//                 const SizedBox(height: 8),
//                 TextField(controller: _image, decoration: const InputDecoration(labelText: 'رابط صورة العرض')),
//                 const SizedBox(height: 16),
//                 ElevatedButton(onPressed: loading ? null : _submit, child: loading ? const CircularProgressIndicator() : const Text('حفظ')),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
