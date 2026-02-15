// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:raf/cubit/admin_cubit/admin_cubit.dart';
// // import 'package:raf/models/subcategory_model.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';

// // class ManageSubCategoriesScreen extends StatefulWidget {
// //   const ManageSubCategoriesScreen({super.key});

// //   @override
// //   State<ManageSubCategoriesScreen> createState() => _ManageSubCategoriesScreenState();
// // }

// // class _ManageSubCategoriesScreenState extends State<ManageSubCategoriesScreen> {
// //   List<Map<String, dynamic>> _subcats = [];
// //   List<Map<String, dynamic>> _categories = [];
// //   final ImagePicker picker = ImagePicker();
// //   File? selectedImage;
// //   bool _loading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadAll();
// //   }

// //   Future<void> _loadAll() async {
// //     setState(() => _loading = true);
// //     try {
// //       final adminCubit = context.read<AdminCubit>();
 
// //       final cats = await adminCubit.getCategories();
      
// //       final subs = await adminCubit.loadSubCategories();

// //       if (!mounted) return;
// //       setState(() {
// //         _categories = cats.map((e) => Map<String, dynamic>.from(e)).toList();
// //         _subcats = subs.map((e) => Map<String, dynamic>.from(e)).toList();
// //         _loading = false;
// //       });
// //     } catch (e) {
// //       if (!mounted) return;
// //       setState(() => _loading = false);
// //       debugPrint("Error loading categories/subcategories: $e");
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ في تحميل البيانات: $e")));
// //     }
// //   }

// //   /// رفع الصورة إلى bucket اسمه 'subcategories' — تأكد أن هذا الباكت موجود في Supabase
// //   Future<String?> uploadImage(File file) async {
// //     try {
// //       final fileName = "subcat_${DateTime.now().millisecondsSinceEpoch}.jpg";
// //       // upload expects bytes or File depending on SDK version; passing File works in many setups
// //       await Supabase.instance.client.storage.from("subcategories").upload(fileName, file);
// //       final url = Supabase.instance.client.storage.from("subcategories").getPublicUrl(fileName);
// //       return url;
// //     } catch (e) {
// //       debugPrint("Upload error: $e");
// //       return null;
// //     }
// //   }

// //   void _showAddEditDialog({SubCategoryModel? model}) {
// //     final nameCtl = TextEditingController(text: model?.name ?? "");
// //     String? parentId = model?.categoryId?.toString();
// //     selectedImage = null;

// //     showDialog(
// //       context: context,
// //       builder: (_) => StatefulBuilder(
// //         builder: (contextDialog, setStateDialog) {
// //           return AlertDialog(
// //             title: Text(model == null ? "إضافة قسم فرعي" : "تعديل قسم فرعي"),
// //             content: SingleChildScrollView(
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   // Dropdown - ensure values are String
// //                   DropdownButtonFormField<String>(
// //                     value: parentId,
// //                     items: _categories.map<DropdownMenuItem<String>>((cat) {
// //                       final idStr = cat['id'].toString();
// //                       final name = cat['name']?.toString() ?? '';
// //                       return DropdownMenuItem<String>(
// //                         value: idStr,
// //                         child: Text(name),
// //                       );
// //                     }).toList(),
// //                     onChanged: (v) => setStateDialog(() => parentId = v),
// //                     decoration: const InputDecoration(labelText: "القسم الرئيسي"),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   TextField(
// //                     controller: nameCtl,
// //                     decoration: const InputDecoration(labelText: "اسم القسم الفرعي"),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   InkWell(
// //                     onTap: () async {
// //                       final p = await picker.pickImage(source: ImageSource.gallery);
// //                       if (p != null) {
// //                         setStateDialog(() => selectedImage = File(p.path));
// //                       }
// //                     },
// //                     child: Container(
// //                       height: 120,
// //                       width: double.infinity,
// //                       alignment: Alignment.center,
// //                       decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
// //                       child: selectedImage != null
// //                           ? Image.file(selectedImage!, fit: BoxFit.cover)
// //                           : (model != null && model.image.isNotEmpty)
// //                               ? Image.network(model.image, fit: BoxFit.cover)
// //                               : const Text("اختر صورة"),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             actions: [
// //               TextButton(onPressed: () => Navigator.pop(contextDialog), child: const Text("إلغاء")),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   final name = nameCtl.text.trim();
// //                   if (name.isEmpty) {
// //                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("أدخل اسم القسم الفرعي")));
// //                     return;
// //                   }
// //                   if (parentId == null || parentId!.isEmpty) {
// //                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("اختر القسم الرئيسي")));
// //                     return;
// //                   }

// //                   String imageUrl = model?.image ?? "";

// //                   if (selectedImage != null) {
// //                     final uploaded = await uploadImage(selectedImage!);
// //                     if (uploaded != null) imageUrl = uploaded;
// //                   }

// //                   final sub = SubCategoryModel(
// //                     id: model?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
// //                     name: name,
// //                     categoryId: parentId!,
// //                     image: imageUrl,
// //                     createdAt: model?.createdAt ?? DateTime.now(),
// //                   );

// //                   final cubit = context.read<AdminCubit>();
// //                   try {
// //                     if (model == null) {
// //                       await cubit.addSubCategory(sub);
// //                     } else {
// //                       await cubit.updateSubCategory(sub);
// //                     }

// //                     if (!mounted) return;
// //                     Navigator.pop(contextDialog);
// //                     await _loadAll(); // reload lists
// //                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تمت العملية بنجاح")));
// //                   } catch (e) {
// //                     if (!mounted) return;
// //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فشل العملية: $e")));
// //                   }
// //                 },
// //                 child: Text(model == null ? "إضافة" : "حفظ"),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("إدارة الأقسام الفرعية")),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () => _showAddEditDialog(),
// //         child: const Icon(Icons.add),
// //       ),
// //       body: _loading
// //           ? const Center(child: CircularProgressIndicator())
// //           : _subcats.isEmpty
// //               ? Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: const [
// //                       Icon(Icons.inbox_outlined, size: 72, color: Colors.grey),
// //                       SizedBox(height: 12),
// //                       Text("لا توجد أقسام فرعية حالياً", style: TextStyle(fontSize: 16)),
// //                     ],
// //                   ),
// //                 )
// //               : RefreshIndicator(
// //                   onRefresh: _loadAll,
// //                   child: ListView.builder(
// //                     padding: const EdgeInsets.all(8),
// //                     itemCount: _subcats.length,
// //                     itemBuilder: (_, i) {
// //                       final s = _subcats[i];
// //                       final imageUrl = (s['image_url'] ?? s['image'] ?? '').toString();
// //                       final name = s['name']?.toString() ?? '';
// //                       final catId = s['category_id']?.toString() ?? s['categoryId']?.toString() ?? '';
// //                       final createdAtStr = s['created_at']?.toString() ?? '';

// //                       return Card(
// //                         child: ListTile(
// //                           leading: (imageUrl.isNotEmpty)
// //                               ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
// //                               : const Icon(Icons.category, size: 48),
// //                           title: Text(name),
// //                           subtitle: Text("تابع لـ: $catId\n${createdAtStr.isNotEmpty ? createdAtStr : ''}"),
// //                           isThreeLine: true,
// //                           trailing: Row(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               IconButton(
// //                                 icon: const Icon(Icons.edit),
// //                                 onPressed: () {
// //                                   final model = SubCategoryModel(
// //                                     id: s['id'].toString(),
// //                                     name: s['name']?.toString() ?? '',
// //                                     categoryId: catId,
// //                                     image: imageUrl,
// //                                     createdAt: DateTime.tryParse(createdAtStr) ?? DateTime.now(),
// //                                   );
// //                                   _showAddEditDialog(model: model);
// //                                 },
// //                               ),
// //                               IconButton(
// //                                 icon: const Icon(Icons.delete, color: Colors.red),
// //                                 onPressed: () async {
// //                                   final confirmed = await showDialog<bool>(
// //                                     context: context,
// //                                     builder: (_) => AlertDialog(
// //                                       title: const Text("تأكيد الحذف"),
// //                                       content: const Text("هل تريد حذف هذا القسم الفرعي؟"),
// //                                       actions: [
// //                                         TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("لا")),
// //                                         ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("نعم")),
// //                                       ],
// //                                     ),
// //                                   );
// //                                   if (confirmed == true) {
// //                                     try {
// //                                       await context.read<AdminCubit>().deleteSubCategory(s['id'].toString());
// //                                       if (!mounted) return;
// //                                       await _loadAll();
// //                                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم الحذف")));
// //                                     } catch (e) {
// //                                       if (!mounted) return;
// //                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فشل الحذف: $e")));
// //                                     }
// //                                   }
// //                                 },
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:raf/cubit/admin_cubit/admin_cubit.dart';
// import 'package:raf/models/subcategory_model.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ManageSubCategoriesScreen extends StatefulWidget {
//   const ManageSubCategoriesScreen({super.key});

//   @override
//   State<ManageSubCategoriesScreen> createState() => _ManageSubCategoriesScreenState();
// }

// class _ManageSubCategoriesScreenState extends State<ManageSubCategoriesScreen> {
//   List<Map<String, dynamic>> _subcats = [];
//   List<Map<String, dynamic>> _categories = [];
//   final ImagePicker picker = ImagePicker();
//   File? selectedImage;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadAll();
//   }

//   Future<void> _loadAll() async {
//     setState(() => _loading = true);
//     try {
//       final adminCubit = context.read<AdminCubit>();

//       // جلب الأقسام الرئيسية
//       final cats = await adminCubit.getCategories();
//       // جلب الأقسام الفرعية
//       final subs = await adminCubit.loadSubCategories();

//       if (!mounted) return;
//       setState(() {
//         _categories = cats.map((e) => Map<String, dynamic>.from(e)).toList();
//         _subcats = subs.map((e) => Map<String, dynamic>.from(e)).toList();
//         _loading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _loading = false);
//       debugPrint("Error loading categories/subcategories: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ في تحميل البيانات: $e")));
//     }
//   }

//   /// رفع الصورة إلى bucket اسمه 'subcategories' — تأكد أن هذا الباكت موجود في Supabase
//   Future<String?> uploadImage(File file) async {
//     try {
//       final fileName = "subcat_${DateTime.now().millisecondsSinceEpoch}.jpg";
//       // upload expects bytes or File depending on SDK version; passing File works in many setups
//       await Supabase.instance.client.storage.from("subcategories").upload(fileName, file);
//       final url = Supabase.instance.client.storage.from("subcategories").getPublicUrl(fileName);
//       return url;
//     } catch (e) {
//       debugPrint("Upload error: $e");
//       return null;
//     }
//   }

//   void _showAddEditDialog({SubCategoryModel? model}) {
//     final nameCtl = TextEditingController(text: model?.name ?? "");
//     String? parentId = model?.categoryId.toString();
//     selectedImage = null;

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (contextDialog, setStateDialog) {
//           return AlertDialog(
//             title: Text(model == null ? "إضافة قسم فرعي" : "تعديل قسم فرعي"),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Dropdown - ensure values are String
//                   DropdownButtonFormField<String>(
//                     initialValue: parentId,
//                     items: _categories.map<DropdownMenuItem<String>>((cat) {
//                       final idStr = cat['id'].toString();
//                       final name = cat['name']?.toString() ?? '';
//                       return DropdownMenuItem<String>(
//                         value: idStr,
//                         child: Text(name),
//                       );
//                     }).toList(),
//                     onChanged: (v) => setStateDialog(() => parentId = v),
//                     decoration: const InputDecoration(labelText: "القسم الرئيسي"),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: nameCtl,
//                     decoration: const InputDecoration(labelText: "اسم القسم الفرعي"),
//                   ),
//                   const SizedBox(height: 10),
//                   InkWell(
//                     onTap: () async {
//                       final p = await picker.pickImage(source: ImageSource.gallery);
//                       if (p != null) {
//                         setStateDialog(() => selectedImage = File(p.path));
//                       }
//                     },
//                     child: Container(
//                       height: 120,
//                       width: double.infinity,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
//                       child: selectedImage != null
//                           ? Image.file(selectedImage!, fit: BoxFit.cover)
//                           : (model != null && model.image.isNotEmpty)
//                               ? Image.network(model.image, fit: BoxFit.cover)
//                               : const Text("اختر صورة"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(onPressed: () => Navigator.pop(contextDialog), child: const Text("إلغاء")),
//               ElevatedButton(
//                 onPressed: () async {
//                   final name = nameCtl.text.trim();
//                   if (name.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("أدخل اسم القسم الفرعي")));
//                     return;
//                   }
//                   if (parentId == null ) {
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("اختر القسم الرئيسي")));
//                     return;
//                   }

//                   String imageUrl = model?.image ?? "";
//  SubCategoryModel sub;
//                   if (selectedImage != null) {
//                     final uploaded = await uploadImage(selectedImage!);
//                     if(uploaded != null) imageUrl = uploaded;
                   

                 
//                   }
//                     sub   = SubCategoryModel(
//                     id: model?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//                     name:   name,
//                     categoryId:  parentId!,
//                     image:   imageUrl,
//                     createdAt: model?.createdAt ?? DateTime.now(),
//                   );
//           final cubit = context.read<AdminCubit>();
//                 try {
//                     if (model == null) {
//                       await cubit.addSubCategory(sub);
//                     } else {
//                       print('up');
                      
//                       await cubit.updateSubCategory(sub);
//                     }

//                     if (!mounted) return;
//                     Navigator.pop(contextDialog);
//                     await _loadAll(); // reload lists
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تمت العملية بنجاح")));
//                   } catch (e) {
//                     if (!mounted) return;
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فشل العملية: $e")));
//                   }
        
//                 },
//                 child: Text(model == null ? "إضافة" : "حفظ"),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("إدارة الأقسام الفرعية")),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddEditDialog(),
//         child: const Icon(Icons.add),
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _subcats.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Icon(Icons.inbox_outlined, size: 72, color: Colors.grey),
//                       SizedBox(height: 12),
//                       Text("لا توجد أقسام فرعية حالياً", style: TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 )
//               : RefreshIndicator(
//                   onRefresh: _loadAll,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(8),
//                     itemCount: _subcats.length,
//                     itemBuilder: (_, i) {
//                       final s = _subcats[i];
//                       final imageUrl = (s['image_url'] ?? s['image'] ?? '').toString();
//                       final name = s['name']?.toString() ?? '';
//                       final catId = s['category_id']?.toString() ?? s['categoryId']?.toString() ?? '';
//                       final createdAtStr = s['created_at']?.toString() ?? '';

//                       return Card(
//                         child: ListTile(
//                           leading: (imageUrl.isNotEmpty)
//                               ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
//                               : const Icon(Icons.category, size: 48),
//                           title: Text(name),
//                           subtitle: Text("تابع لـ: $catId\n${createdAtStr.isNotEmpty ? createdAtStr : ''}"),
//                           isThreeLine: true,
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.edit),
//                                 onPressed: () {
//                                   final model = SubCategoryModel(
//                                     id: s['id'].toString(),
//                                     name: s['name']?.toString() ?? '',
//                                     categoryId: catId,
//                                     image: imageUrl,
//                                     createdAt: DateTime.tryParse(createdAtStr) ?? DateTime.now(),
//                                   );
//                                   _showAddEditDialog(model: model);
//                                 },
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () async {
//                                   final confirmed = await showDialog<bool>(
//                                     context: context,
//                                     builder: (_) => AlertDialog(
//                                       title: const Text("تأكيد الحذف"),
//                                       content: const Text("هل تريد حذف هذا القسم الفرعي؟"),
//                                       actions: [
//                                         TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("لا")),
//                                         ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("نعم")),
//                                       ],
//                                     ),
//                                   );
//                                   if (confirmed == true) {
//                                     try {
//                                       await context.read<AdminCubit>().deleteSubCategory(s['id'].toString());
//                                       if (!mounted) return;
//                                       await _loadAll();
//                                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم الحذف")));
//                                     } catch (e) {
//                                       if (!mounted) return;
//                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فشل الحذف: $e")));
//                                     }
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//     );
//   }
// }
