// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:raf/cubit/admin_cubit/admin_cubit.dart';
// import 'package:raf/models/product_model.dart'; 
// class AddProductScreen extends StatefulWidget {
//   final ProductModel? productToEdit;
//   const AddProductScreen({super.key, this.productToEdit});

//   @override
//   State<AddProductScreen> createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   final _form = GlobalKey<FormState>();
//   final _name = TextEditingController();
//   final _desc = TextEditingController();
//   final _price = TextEditingController();
//   final _image = TextEditingController();
//   final _stock = TextEditingController();
//   String? _categoryId;
//   String? _subcategoryId;
//   final List<Map<String, dynamic>> _categories = [];

//   @override
//   void initState() {
//     super.initState();
//     final p = widget.productToEdit;
//     if (p != null) {
//       _name.text = p.name;
//       _desc.text = p.description ?? '';
//       _price.text = p.price.toString();
//       _image.text = p.image; 
//       _categoryId = p.categoryId;
//       _subcategoryId = p.subCategoryId;
//     }
//     _loadCategories();
//   }

//   Future<void> _loadCategories() async {
//     // if cubit has method to get categories, call it; otherwise you can call adminRepo directly
//     // example:
//     // final cats = await context.read<AdminCubit>().adminRepo.getCategories();
//     // setState(() => _categories = cats);
//   }

//   void _submit() {
//     if (!_form.currentState!.validate()) return;
//     final cubit = context.read<AdminCubit>();
//     final product = ProductModel(
//       id: widget.productToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//       name: _name.text.trim(),
//       description: _desc.text.trim(),
//       price: double.tryParse(_price.text.trim()) ?? 0.0,
      
//       categoryId: _categoryId ?? '',
//       subCategoryId:_subcategoryId ,
     
//      image: _image.text.trim(), createdAt: DateTime.now(),
//     );

//     if (widget.productToEdit == null) {
//       cubit.addProduct(product);
//     } else {
//       cubit.updateProduct(product);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.productToEdit == null ? 'إضافة منتج' : 'تعديل المنتج')),
//       body: BlocConsumer<AdminCubit, AdminState>(
//         listener: (context, state) {
//           if (state is AdminSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
//             if (widget.productToEdit == null) {
//               _form.currentState?.reset();
//             }
//           } else if (state is AdminError) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: Colors.red));
//           }
//         },
//         builder: (context, state) {
//           final loading = state is AdminLoading;
//           return Padding(
//             padding: const EdgeInsets.all(12),
//             child: Form(
//               key: _form,
//               child: ListView(
//                 children: [
//                   TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'اسم المنتج'), validator: (v) => v!.isEmpty ? 'أدخل اسم المنتج' : null),
//                   const SizedBox(height: 12),
//                   TextFormField(controller: _desc, decoration: const InputDecoration(labelText: 'الوصف'), maxLines: 3),
//                   const SizedBox(height: 12),
//                   TextFormField(controller: _price, decoration: const InputDecoration(labelText: 'السعر'), keyboardType: TextInputType.number),
//                   const SizedBox(height: 12),
//                   TextFormField(controller: _stock, decoration: const InputDecoration(labelText: 'الكمية في المخزون'), keyboardType: TextInputType.number),
//                   const SizedBox(height: 12),
//                   TextFormField(controller: _image, decoration: const InputDecoration(labelText: 'رابط الصورة')),
//                   const SizedBox(height: 16),
//                   // categories dropdown (if loaded)
//                   ElevatedButton(onPressed: loading ? null : _submit, child: loading ? const CircularProgressIndicator() : Text(widget.productToEdit == null ? 'إضافة' : 'حفظ')),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
