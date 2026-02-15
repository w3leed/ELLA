//  import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:raf/cubit/admin_cubit/admin_cubit.dart';
// import 'package:raf/models/category_model.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ManageCategoriesScreen extends StatefulWidget {
//   const ManageCategoriesScreen({super.key});

//   @override
//   State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
// }

// class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
//   List _categories = [];
//   final picker = ImagePicker();
//   File? selectedImage;

//   @override
//   void initState() {
//     super.initState();
//     context.read<AdminCubit>().getCategories();
//   }

//   Future<String?> uploadImage(File file) async {
//     try {
//       final fileName = "cat_${DateTime.now().millisecondsSinceEpoch}.jpg";

//       await Supabase.instance.client.storage
//           .from("categories")
//           .upload(fileName, file);

//       final url = Supabase.instance.client.storage
//           .from("categories")
//           .getPublicUrl(fileName);

//       return url;
//     } catch (e) {
//       debugPrint("Upload error: $e");
//       return null;
//     }
//   }

//   void _showAddEditDialog({CategoryModel? category}) {
//     final nameCtl = TextEditingController(text: category?.name ?? '');

//     selectedImage = null;

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setStateDialog) => AlertDialog(
//           title: Text(category == null ? "إضافة قسم" : "تعديل قسم"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameCtl,
//                 decoration: const InputDecoration(labelText: "اسم القسم"),
//               ),
//               const SizedBox(height: 10),

//               // Image Picker
//               InkWell(
//                 onTap: () async {
//                   final picked = await picker.pickImage(source: ImageSource.gallery);
//                   if (picked != null) {
//                     setStateDialog(() {
//                       selectedImage = File(picked.path);
//                     });
//                   }
//                 },
//                 child: Container(
//                   height: 120,
//                   width: double.infinity,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: selectedImage != null
//                       ? Image.file(selectedImage!, fit: BoxFit.cover)
//                       : category != null
//                           ? Image.network(category.image, fit: BoxFit.cover)
//                           : const Text("اختر صورة"),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("إلغاء"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String imageUrl = category?.image ?? "";

//                 if (selectedImage != null) {
//                   final uploaded = await uploadImage(selectedImage!);
//                   if (uploaded != null) imageUrl = uploaded;
//                 }

//                 final newCat = CategoryModel(
//                   id: category?.id ??
//                       DateTime.now().millisecondsSinceEpoch.toString(),
//                   name: nameCtl.text.trim(),
//                   image: imageUrl,
//                   createdAt: DateTime.now(),
//                 );

//                 final cubit = context.read<AdminCubit>();
//                 category == null
//                     ? cubit.addCategory(newCat)
//                     : cubit.updateCategory(newCat);

//                 Navigator.pop(context);
//               },
//               child: Text(category == null ? "إضافة" : "حفظ"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("إدارة الأقسام")),
//       body: BlocConsumer<AdminCubit, AdminState>(
//         listener: (context, state) {
//           if (state is AdminLoading) {
//             print(state.props );
//             // setState(() => _categories = state.props as List<CategoryModel> );
//           }

//           if (state is AdminLoading) {
          
//             context.read<AdminCubit>().getCategories().then((v){
//                print(v);
//              setState(() => _categories = v );
//             });
//             // print(state.props);
//             //  setState(() => _categories = state.props as List<CategoryModel> );
//           }
//         },
//         builder: (context, state) {
//           return Column(
//             children: [
//               const SizedBox(height: 10),
//               ElevatedButton.icon(
//                 onPressed: () => _showAddEditDialog(),
//                 icon: const Icon(Icons.add),
//                 label: const Text("إضافة قسم"),
//               ),
//               Expanded(
//                 child: state is AdminLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                         itemCount: _categories.length,
//                         itemBuilder: (_, i) {
//                           final c = _categories[i];
//                           return Card(
//                             child: ListTile(
//                               leading: c['image_url'] !=''|| c['image_url'] != null
//                                   ? Image.network(c['image_url'] , width: 60, height: 60)
//                                   : null,
//                               title: Text(c['name']),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.edit),
//                                     onPressed: () => _showAddEditDialog(category:
//                                      CategoryModel(id: c['id'], name: c['name'],
//                                       image: c['image_url'], createdAt: DateTime.parse(c['created_at']  ))),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete, color: Colors.red),
//                                     onPressed: () {
//                                       context.read<AdminCubit>().deleteCategory(c.id);
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
