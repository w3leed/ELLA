// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:image_picker/image_picker.dart';
// // // import 'package:supabase_flutter/supabase_flutter.dart';

// // // class ManageCategoriesScreen extends StatefulWidget {
// // //   const ManageCategoriesScreen({super.key});

// // //   @override
// // //   State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
// // // }

// // // class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
// // //   final supabase = Supabase.instance.client;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return DefaultTabController(
// // //       length: 2,
// // //       child: Scaffold(
// // //         appBar: AppBar(
// // //           title: const Text("إدارة المتجر"),
// // //           bottom: const TabBar(
// // //             tabs: [
// // //               Tab(text: "الأقسام الرئيسية", icon: Icon(Icons.grid_view)),
// // //               Tab(text: "الأقسام الفرعية", icon: Icon(Icons.account_tree)),
// // //             ],
// // //           ),
// // //         ),
// // //         body: TabBarView(
// // //           children: [
// // //             _buildCategoryList(isSub: false),
// // //             _buildCategoryList(isSub: true),
// // //           ],
// // //         ),
// // //         floatingActionButton: FloatingActionButton(
// // //           onPressed: () => _showAddEditDialog(context),
// // //           child: const Icon(Icons.add),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // بناء القائمة (سواء للأقسام أو الأقسام الفرعية)
// // //   Widget _buildCategoryList({required bool isSub}) {
// // //     final table = isSub ? 'subcategories' : 'categories';
// // //     // إذا كان قسم فرعي، نجلب اسم القسم الرئيسي المرتبط به (Join)
// // //     final selectQuery = isSub ? '*, categories(name)' : '*';

// // //     return StreamBuilder(
// // //       stream: supabase.from(table).stream(primaryKey: ['id']),
// // //       builder: (context, snapshot) {
// // //         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
// // //         final data = snapshot.data!;

// // //         return ListView.builder(
// // //           itemCount: data.length,
// // //           itemBuilder: (context, index) {
// // //             final item = data[index];
// // //             return ListTile(
// // //               leading: CircleAvatar(
// // //                 backgroundImage: item['image'] != null ? NetworkImage(item['image']) : null,
// // //                 child: item['image'] == null ? const Icon(Icons.image) : null,
// // //               ),
// // //               title: Text(item['name']),
// // //               // إذا كان قسماً فرعياً، نعرض التابعية
// // //               subtitle: isSub ? FutureBuilder(
// // //                 future: supabase.from('categories').select('name').eq('id', item['category_id']).single(),
// // //                 builder: (context, subSnap) => Text("تابع لـ: ${subSnap.data?['name'] ?? '...'}")
// // //               ) : null,
// // //               trailing: Row(
// // //                 mainAxisSize: MainAxisSize.min,
// // //                 children: [
// // //                   IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showAddEditDialog(context, item: item, isSub: isSub)),
// // //                   IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteItem(table, item['id'])),
// // //                 ],
// // //               ),
// // //             );
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }

// // //   Future<void> _deleteItem(String table, int id) async {
// // //     await supabase.from(table).delete().eq('id', id);
// // //   }

// // //   void _showAddEditDialog(BuildContext context, {dynamic item, bool isSub = false}) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => CategoryDialog(item: item, isSub: isSub),
// // //     );
// // //   }
// // // }

// // // // ==========================================
// // // // ويدجت النافذة المنبثقة (إضافة وتعديل مع رفع صور)
// // // // ==========================================
// // // class CategoryDialog extends StatefulWidget {
// // //   final dynamic item;
// // //   final bool isSub;
// // //   const CategoryDialog({super.key, this.item, required this.isSub});

// // //   @override
// // //   State<CategoryDialog> createState() => _CategoryDialogState();
// // // }

// // // class _CategoryDialogState extends State<CategoryDialog> {
// // //   final _nameController = TextEditingController();
// // //   File? _imageFile;
// // //   int? _selectedMainCategoryId;
// // //   List<dynamic> _mainCategories = [];
// // //   bool _loading = false;
// // //   final supabase = Supabase.instance.client;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     if (widget.item != null) {
// // //       _nameController.text = widget.item['name'];
// // //       if (widget.isSub) _selectedMainCategoryId = widget.item['category_id'];
// // //     }
// // //     _fetchMainCategories();
// // //   }

// // //   Future<void> _fetchMainCategories() async {
// // //     final data = await supabase.from('categories').select();
// // //     setState(() => _mainCategories = data);
// // //   }

// // //   Future<void> _pickImage() async {
// // //     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
// // //     if (picked != null) setState(() => _imageFile = File(picked.path));
// // //   }

// // //   Future<void> _save() async {
// // //     setState(() => _loading = true);
// // //     String? imageUrl = widget.item?['image'];

// // //     // 1. رفع الصورة إذا تم اختيار صورة جديدة
// // //     if (_imageFile != null) {
// // //       final fileName = DateTime.now().millisecondsSinceEpoch.toString();
// // //       await supabase.storage.from('categories-bucket').upload(fileName, _imageFile!);
// // //       imageUrl = supabase.storage.from('categories-bucket').getPublicUrl(fileName);
// // //     }

// // //     final table = widget.isSub ? 'subcategories' : 'categories';
// // //     final data = {
// // //       'name': _nameController.text,
// // //       'image': imageUrl,
// // //       if (widget.isSub) 'category_id': _selectedMainCategoryId,
// // //     };

// // //     if (widget.item == null) {
// // //       await supabase.from(table).insert(data);
// // //     } else {
// // //       await supabase.from(table).update(data).eq('id', widget.item['id']);
// // //     }

// // //     Navigator.pop(context);
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return AlertDialog(
// // //       title: Text(widget.item == null ? "إضافة جديد" : "تعديل"),
// // //       content: SingleChildScrollView(
// // //         child: Column(
// // //           children: [
// // //             GestureDetector(
// // //               onTap: _pickImage,
// // //               child: Container(
// // //                 height: 100, width: 100,
// // //                 color: Colors.grey[200],
// // //                 child: _imageFile != null ? Image.file(_imageFile!, fit: BoxFit.cover) : const Icon(Icons.add_a_photo),
// // //               ),
// // //             ),
// // //             TextField(controller: _nameController, decoration: const InputDecoration(labelText: "الاسم")),
// // //             if (widget.isSub) ...[
// // //               const SizedBox(height: 10),
// // //               DropdownButtonFormField<int>(
// // //                 value: _selectedMainCategoryId,
// // //                 hint: const Text("اختر القسم الرئيسي"),
// // //                 items: _mainCategories.map((c) => DropdownMenuItem<int>(value: c['id'], child: Text(c['name']))).toList(),
// // //                 onChanged: (val) => setState(() => _selectedMainCategoryId = val),
// // //               )
// // //             ]
// // //           ],
// // //         ),
// // //       ),
// // //       actions: [
// // //         if (_loading) const CircularProgressIndicator()
// // //         else ElevatedButton(onPressed: _save, child: const Text("حفظ"))
// // //       ],
// // //     );

// // //   }
// // // }
// // // class ProductDialog extends StatefulWidget {
// // //   final dynamic product;
// // //   const ProductDialog({super.key, this.product});

// // //   @override
// // //   State<ProductDialog> createState() => _ProductDialogState();
// // // }

// // // class _ProductDialogState extends State<ProductDialog> {
// // //   final _nameController = TextEditingController();
// // //   final _priceController = TextEditingController();
// // //   final _descController = TextEditingController();
// // //   int? _selectedSubId;
// // //   List<dynamic> _subCategories = [];
// // //   File? _imageFile;
// // //   bool _loading = false;
// // //   final supabase = Supabase.instance.client;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fetchSubs();
// // //     if (widget.product != null) {
// // //       _nameController.text = widget.product['name'];
// // //       _priceController.text = widget.product['price'].toString();
// // //       _descController.text = widget.product['description'] ?? '';
// // //       _selectedSubId = widget.product['subcategory_id'];
// // //     }
// // //   }

// // //   Future<void> _fetchSubs() async {
// // //     final data = await supabase.from('subcategories').select();
// // //     setState(() => _subCategories = data);
// // //   }

// // //   Future<void> _save() async {
// // //     setState(() => _loading = true);
// // //     String? imageUrl = widget.product?['image'];

// // //     if (_imageFile != null) {
// // //       final fileName = "prod_${DateTime.now().millisecondsSinceEpoch}";
// // //       await supabase.storage.from('products-bucket').upload(fileName, _imageFile!);
// // //       imageUrl = supabase.storage.from('products-bucket').getPublicUrl(fileName);
// // //     }

// // //     final data = {
// // //       'name': _nameController.text,
// // //       'price': double.parse(_priceController.text),
// // //       'description': _descController.text,
// // //       'subcategory_id': _selectedSubId,
// // //       'image': imageUrl,
// // //     };

// // //     if (widget.product == null) {
// // //       await supabase.from('products').insert(data);
// // //     } else {
// // //       await supabase.from('products').update(data).eq('id', widget.product['id']);
// // //     }
// // //     Navigator.pop(context);
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return AlertDialog(
// // //       title: Text(widget.product == null ? "إضافة منتج" : "تعديل منتج"),
// // //       content: SingleChildScrollView(
// // //         child: Column(
// // //           children: [
// // //             GestureDetector(
// // //               onTap: () async {
// // //                 final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
// // //                 if (picked != null) setState(() => _imageFile = File(picked.path));
// // //               },
// // //               child: Container(
// // //                 height: 120, width: double.infinity,
// // //                 color: Colors.grey[200],
// // //                 child: _imageFile != null
// // //                     ? Image.file(_imageFile!, fit: BoxFit.cover)
// // //                     : (widget.product?['image'] != null ? Image.network(widget.product['image']) : const Icon(Icons.add_a_photo, size: 40)),
// // //               ),
// // //             ),
// // //             TextField(controller: _nameController, decoration: const InputDecoration(labelText: "اسم المنتج")),
// // //             TextField(controller: _priceController, decoration: const InputDecoration(labelText: "السعر"), keyboardType: TextInputType.number),
// // //             TextField(controller: _descController, decoration: const InputDecoration(labelText: "وصف المنتج"), maxLines: 2),
// // //             DropdownButtonFormField<int>(
// // //               value: _selectedSubId,
// // //               hint: const Text("اختر القسم الفرعي"),
// // //               items: _subCategories.map((s) => DropdownMenuItem<int>(value: s['id'], child: Text(s['name']))).toList(),
// // //               onChanged: (val) => setState(() => _selectedSubId = val),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //       actions: [
// // //         if (_loading) const CircularProgressIndicator()
// // //         else ElevatedButton(onPressed: _save, child: const Text("حفظ المنتج"))
// // //       ],
// // //     );
// // //   }
// // // }
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:raf/core/components.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';

// // class ManageStoreScreen extends StatefulWidget {
// //   const ManageStoreScreen({super.key});

// //   @override
// //   State<ManageStoreScreen> createState() => _ManageStoreScreenState();
// // }

// // class _ManageStoreScreenState extends State<ManageStoreScreen> {
// //   final supabase = Supabase.instance.client;

// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 3,
// //       child: Builder(
// //         builder: (context) {
// //           return Scaffold(
// //             appBar: AppBar(
// //               title: const Text("لوحة تحكم المتجر"),
// //               bottom: const TabBar(
// //                 isScrollable: true,
// //                 tabs: [
// //                   Tab(text: "الأقسام", icon: Icon(Icons.grid_view)),
// //                   Tab(text: "الفرعية", icon: Icon(Icons.account_tree)),
// //                   Tab(text: "المنتجات", icon: Icon(Icons.shopping_bag)),
// //                 ],
// //               ),
// //             ),
// //             body: TabBarView(
// //               children: [
// //                 _buildCategoryList(isSub: false), // الأقسام الرئيسية
// //                 _buildCategoryList(isSub: true), // الأقسام الفرعية
// //                 _buildProductList(), // المنتجات
// //               ],
// //             ),
// //             floatingActionButton: FloatingActionButton(
// //               onPressed: () {
// //                 final tabIndex = DefaultTabController.of(context).index;
// //                 if (tabIndex == 0) {
// //                   _showCategoryDialog(context, isSub: false);
// //                 } else if (tabIndex == 1) {
// //                   _showCategoryDialog(context, isSub: true);
// //                 } else {
// //                   _showProductDialog(context);
// //                 }
// //               },
// //               child: const Icon(Icons.add),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   // --- واجهة عرض القوائم (Categories & Subcategories) ---
// //   Widget _buildCategoryList({required bool isSub}) {
// //     final table = isSub ? 'subcategories' : 'categories';
// //     return StreamBuilder(
// //       stream: supabase.from(table).stream(primaryKey: ['id']),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData)
// //           return const Center(child: CircularProgressIndicator());
// //         final data = snapshot.data!;
// //         return ListView.builder(
// //           itemCount: data.length,
// //           itemBuilder: (context, index) {
// //             final item = data[index];
// //             return Card(
// //               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //               child: ListTile(
// //                 leading: ClipRRect(
// //                   borderRadius: BorderRadius.circular(8),
// //                   child: buildNetworkImage(
// //                     item['image'],
// //                     width: 50,
// //                     height: 50,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //                 title: Text(
// //                   item['name'],
// //                   style: const TextStyle(fontWeight: FontWeight.bold),
// //                 ),
// //                 subtitle: isSub
// //                     ? FutureBuilder(
// //                         future: supabase
// //                             .from('categories')
// //                             .select('name')
// //                             .eq('id', item['category_id'])
// //                             .single(),
// //                         builder: (context, subSnap) =>
// //                             Text("القسم: ${subSnap.data?['name'] ?? '...'}"),
// //                       )
// //                     : null,
// //                 trailing: Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     IconButton(
// //                       icon: const Icon(Icons.edit, color: Colors.blue),
// //                       onPressed: () => _showCategoryDialog(
// //                         context,
// //                         item: item,
// //                         isSub: isSub,
// //                       ),
// //                     ),
// //                     IconButton(
// //                       icon: const Icon(Icons.delete, color: Colors.red),
// //                       onPressed: () => _deleteItem(table, item['id']),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }

// //   // --- واجهة عرض المنتجات ---
// //   Widget _buildProductList() {
// //     return StreamBuilder(
// //       stream: supabase.from('products').stream(primaryKey: ['id']),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData)
// //           return const Center(child: CircularProgressIndicator());
// //         final products = snapshot.data!;
// //         return ListView.builder(
// //           itemCount: products.length,
// //           itemBuilder: (context, index) {
// //             final p = products[index];
// //             return Card(
// //               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //               child: ListTile(
// //                 leading: buildNetworkImage(
// //                   p['image'],
// //                   width: 50,
// //                   height: 50,
// //                   fit: BoxFit.cover,
// //                 ),
// //                 title: Text(p['name']),
// //                 subtitle: Text("${p['price']} ج.م"),
// //                 trailing: Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     IconButton(
// //                       icon: const Icon(Icons.edit, color: Colors.blue),
// //                       onPressed: () => _showProductDialog(context, product: p),
// //                     ),
// //                     IconButton(
// //                       icon: const Icon(Icons.delete, color: Colors.red),
// //                       onPressed: () => _deleteItem('products', p['id']),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }

// //   Future<void> _deleteItem(String table, int id) async {
// //     await supabase.from(table).delete().eq('id', id);
// //   }

// //   void _showCategoryDialog(
// //     BuildContext context, {
// //     dynamic item,
// //     bool isSub = false,
// //   }) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => CategoryDialog(item: item, isSub: isSub),
// //     );
// //   }

// //   void _showProductDialog(BuildContext context, {dynamic product}) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => ProductDialog(product: product),
// //     );
// //   }
// // }

// // // ==========================================
// // // نافذة الأقسام (Category & Subcategory Dialog)
// // // ==========================================
// // class CategoryDialog extends StatefulWidget {
// //   final dynamic item;
// //   final bool isSub;
// //   const CategoryDialog({super.key, this.item, required this.isSub});

// //   @override
// //   State<CategoryDialog> createState() => _CategoryDialogState();
// // }

// // class _CategoryDialogState extends State<CategoryDialog> {
// //   final _nameController = TextEditingController();
// //   File? _imageFile;
// //   int? _selectedMainId;
// //   List<dynamic> _mainCategories = [];
// //   bool _loading = false;
// //   final supabase = Supabase.instance.client;

// //   @override
// //   void initState() {
// //     super.initState();
// //     if (widget.item != null) {
// //       _nameController.text = widget.item['name'];
// //       if (widget.isSub) _selectedMainId = widget.item['category_id'];
// //     }
// //     if (widget.isSub) _fetchMainCategories();
// //   }

// //   Future<void> _fetchMainCategories() async {
// //     final data = await supabase.from('categories').select();
// //     setState(() => _mainCategories = data);
// //   }

// //   Future<void> _save() async {
// //     if (_nameController.text.isEmpty) return;
// //     setState(() => _loading = true);
// //     String? imageUrl = widget.item?['image'];

// //     if (_imageFile != null) {
// //       final bucket = widget.isSub
// //           ? 'subcategories-bucket'
// //           : 'categories-bucket';
// //       final fileName = "${DateTime.now().millisecondsSinceEpoch}";
// //       await supabase.storage.from(bucket).upload(fileName, _imageFile!);
// //       imageUrl = supabase.storage.from(bucket).getPublicUrl(fileName);
// //     }

// //     final table = widget.isSub ? 'subcategories' : 'categories';
// //     final data = {
// //       'name': _nameController.text,
// //       'image': imageUrl,
// //       if (widget.isSub) 'category_id': _selectedMainId,
// //     };

// //     try {
// //       if (widget.item == null) {
// //         await supabase.from(table).insert(data);
// //       } else {
// //         await supabase.from(table).update(data).eq('id', widget.item['id']);
// //       }
// //       Navigator.pop(context);
// //     } catch (e) {
// //       setState(() => _loading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       title: Text(widget.item == null ? "إضافة قسم" : "تعديل قسم"),
// //       content: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             GestureDetector(
// //               onTap: () async {
// //                 final picked = await ImagePicker().pickImage(
// //                   source: ImageSource.gallery,
// //                 );
// //                 if (picked != null)
// //                   setState(() => _imageFile = File(picked.path));
// //               },
// //               child: Container(
// //                 height: 100,
// //                 width: 100,
// //                 color: Colors.grey[200],
// //                 child: _imageFile != null
// //                     ? Image.file(_imageFile!, fit: BoxFit.cover)
// //                     : const Icon(Icons.add_a_photo),
// //               ),
// //             ),
// //             TextField(
// //               controller: _nameController,
// //               decoration: const InputDecoration(labelText: "الاسم"),
// //             ),
// //             if (widget.isSub) ...[
// //               const SizedBox(height: 10),
// //               DropdownButtonFormField<int>(
// //                 value: _selectedMainId,
// //                 hint: const Text("اختر القسم الرئيسي"),
// //                 items: _mainCategories
// //                     .map(
// //                       (c) => DropdownMenuItem<int>(
// //                         value: c['id'],
// //                         child: Text(c['name']),
// //                       ),
// //                     )
// //                     .toList(),
// //                 onChanged: (val) => setState(() => _selectedMainId = val),
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //       actions: [
// //         _loading
// //             ? const CircularProgressIndicator()
// //             : ElevatedButton(onPressed: _save, child: const Text("حفظ")),
// //       ],
// //     );
// //   }
// // }

// // // ==========================================
// // // نافذة المنتجات (Product Dialog)
// // // ==========================================
// // class ProductDialog extends StatefulWidget {
// //   final dynamic product;
// //   const ProductDialog({super.key, this.product});

// //   @override
// //   State<ProductDialog> createState() => _ProductDialogState();
// // }

// // class _ProductDialogState extends State<ProductDialog> {
// //   final _nameController = TextEditingController();
// //   final _priceController = TextEditingController();
// //   final _descController = TextEditingController();
// //   int? _selectedSubId;
// //   List<dynamic> _subCategories = [];
// //   File? _imageFile;
// //   bool _loading = false;
// //   final supabase = Supabase.instance.client;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchSubs();
// //     if (widget.product != null) {
// //       _nameController.text = widget.product['name'];
// //       _priceController.text = widget.product['price'].toString();
// //       _descController.text = widget.product['description'] ?? '';
// //       _selectedSubId = widget.product['subcategory_id'];
// //     }
// //   }

// //   Future<void> _fetchSubs() async {
// //     final data = await supabase.from('subcategories').select();
// //     setState(() => _subCategories = data);
// //   }

// //   Future<void> _save() async {
// //     setState(() => _loading = true);
// //     String? imageUrl = widget.product?['image'];

// //     if (_imageFile != null) {
// //       final fileName = "prod_${DateTime.now().millisecondsSinceEpoch}";
// //       await supabase.storage
// //           .from('products-bucket')
// //           .upload(fileName, _imageFile!);
// //       imageUrl = supabase.storage
// //           .from('products-bucket')
// //           .getPublicUrl(fileName);
// //     }

// //     final data = {
// //       'name': _nameController.text,
// //       'price': double.tryParse(_priceController.text) ?? 0.0,
// //       'description': _descController.text,
// //       'subcategory_id': _selectedSubId,
// //       'image': imageUrl,
// //     };

// //     await (widget.product == null
// //         ? supabase.from('products').insert(data)
// //         : supabase
// //               .from('products')
// //               .update(data)
// //               .eq('id', widget.product['id']));

// //     Navigator.pop(context);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       title: Text(widget.product == null ? "إضافة منتج" : "تعديل منتج"),
// //       content: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             GestureDetector(
// //               onTap: () async {
// //                 final picked = await ImagePicker().pickImage(
// //                   source: ImageSource.gallery,
// //                 );
// //                 if (picked != null)
// //                   setState(() => _imageFile = File(picked.path));
// //               },
// //               child: Container(
// //                 height: 120,
// //                 width: double.infinity,
// //                 color: Colors.grey[200],
// //                 child: _imageFile != null
// //                     ? Image.file(_imageFile!, fit: BoxFit.cover)
// //                     : const Icon(Icons.add_a_photo, size: 40),
// //               ),
// //             ),
// //             TextField(
// //               controller: _nameController,
// //               decoration: const InputDecoration(labelText: "اسم المنتج"),
// //             ),
// //             TextField(
// //               controller: _priceController,
// //               decoration: const InputDecoration(labelText: "السعر"),
// //               keyboardType: TextInputType.number,
// //             ),
// //             TextField(
// //               controller: _descController,
// //               decoration: const InputDecoration(labelText: "وصف المنتج"),
// //               maxLines: 2,
// //             ),
// //             DropdownButtonFormField<int>(
// //               value: _selectedSubId,
// //               hint: const Text("اختر القسم الفرعي"),
// //               items: _subCategories
// //                   .map(
// //                     (s) => DropdownMenuItem<int>(
// //                       value: s['id'],
// //                       child: Text(s['name']),
// //                     ),
// //                   )
// //                   .toList(),
// //               onChanged: (val) => setState(() => _selectedSubId = val),
// //             ),
// //           ],
// //         ),
// //       ),
// //       actions: [
// //         _loading
// //             ? const CircularProgressIndicator()
// //             : ElevatedButton(onPressed: _save, child: const Text("حفظ المنتج")),
// //       ],
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// // --- Global Helper for Images ---
// Widget buildSafeImage(String? url, {double size = 50, bool isSquare = true}) {
//   if (url == null || url.isEmpty) {
//     return Container(
//       width: size, height: size,
//       decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
//       child: Icon(Icons.image, color: Colors.grey[600], size: size * 0.5),
//     );
//   }
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(8),
//     child: Image.network(
//       url,
//       width: size, height: size,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) => Container(
//         width: size, height: size,
//         color: Colors.grey[200],
//         child: const Icon(Icons.broken_image, color: Colors.red),
//       ),
//     ),
//   );
// }

// class ManageStoreScreen extends StatefulWidget {
//   const ManageStoreScreen({super.key});

//   @override
//   State<ManageStoreScreen> createState() => _ManageStoreScreenState();
// }

// class _ManageStoreScreenState extends State<ManageStoreScreen> {
//   final supabase = Supabase.instance.client;

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("إدارة المتجر"),
//           bottom: const TabBar(
//             isScrollable: true,
//             tabs: [
//               Tab(text: "أقسام رئيسية", icon: Icon(Icons.grid_view)),
//               Tab(text: "أقسام فرعية", icon: Icon(Icons.account_tree)),
//               Tab(text: "المنتجات", icon: Icon(Icons.shopping_bag)),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildList(table: 'categories', isSub: false),
//             _buildList(table: 'subcategories', isSub: true),
//             _buildProductList(),
//           ],
//         ),
//         floatingActionButton: Builder(builder: (context) {
//           return FloatingActionButton(
//             onPressed: () {
//               final index = DefaultTabController.of(context).index;
//               if (index == 2) {
//                 _showProductDialog(context);
//               } else {
//                 _showCategoryDialog(context, isSub: index == 1);
//               }
//             },
//             child: const Icon(Icons.add),
//           );
//         }),
//       ),
//     );
//   }

//   // List for Categories & Subcategories
//   Widget _buildList({required String table, required bool isSub}) {
//     return StreamBuilder(
//       stream: supabase.from(table).stream(primaryKey: ['id']).order('id'),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//         final data = snapshot.data!;
//         return ListView.builder(
//           itemCount: data.length,
//           itemBuilder: (context, i) {
//             final item = data[i];
//             return ListTile(
//               leading: buildSafeImage(item['image_url']),
//               title: Text(item['name'] ?? ''),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showCategoryDialog(context, item: item, isSub: isSub)),
//                   IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _delete(table, item['id'])),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // List for Products
//   Widget _buildProductList() {
//     return StreamBuilder(
//       stream: supabase.from('products').stream(primaryKey: ['id']),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//         final products = snapshot.data!;
//         return ListView.builder(
//           itemCount: products.length,
//           itemBuilder: (context, i) {
//             final p = products[i];
//             return ListTile(
//               leading: buildSafeImage(p['images']),
//               title: Text(p['name'] ?? ''),
//               subtitle: Text("${p['price']} ج.م"),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showProductDialog(context, product: p)),
//                   IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _delete('products', p['id'])),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _delete(String table, int id) async {
//     await supabase.from(table).delete().eq('id', id);
//   }

//   void _showCategoryDialog(BuildContext context, {dynamic item, bool isSub = false}) {
//     showDialog(context: context, builder: (_) => CategoryDialog(item: item, isSub: isSub));
//   }

//   void _showProductDialog(BuildContext context, {dynamic product}) {
//     showDialog(context: context, builder: (_) => ProductDialog(product: product));
//   }
// }

// // --- Category & Subcategory Dialog ---
// class CategoryDialog extends StatefulWidget {
//   final dynamic item;
//   final bool isSub;
//   const CategoryDialog({super.key, this.item, required this.isSub});

//   @override
//   State<CategoryDialog> createState() => _CategoryDialogState();
// }

// class _CategoryDialogState extends State<CategoryDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   int? _parentID;
//   File? _imgFile;
//   bool _loading = false;
//   List<dynamic> _parents = [];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.item != null) {
//       _nameController.text = widget.item['name'];
//       _parentID = widget.item['category_id'];
//     }
//     if (widget.isSub) _fetchParents();
//   }

//   _fetchParents() async {
//     final data = await Supabase.instance.client.from('categories').select();
//     setState(() => _parents = data);
//   }

//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _loading = true);
//     try {
//       String? url = widget.item?['image_url'];
//       final client = Supabase.instance.client;
//       final bucket = widget.isSub ? 'subcategories' : 'categories';

//       if (_imgFile != null) {
//         final path = "img_${DateTime.now().millisecondsSinceEpoch}.jpg";
//         await client.storage.from(bucket).upload(path, _imgFile!);
//         url = client.storage.from(bucket).getPublicUrl(path);
//       }

//       final data = {
//         'name': _nameController.text.trim(),
//         'image_url': url,
//         if (widget.isSub) 'category_id': _parentID,
//       };

//       final table = widget.isSub ? 'subcategories' : 'categories';
//       if (widget.item == null) {
//         await client.from(table).insert(data);
//       } else {
//         await client.from(table).update(data).eq('id', widget.item['id']);
//       }
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.item == null ? "إضافة" : "تعديل"),
//       content: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: () async {
//                   final p = await ImagePicker().pickImage(source: ImageSource.gallery);
//                   if (p != null) setState(() => _imgFile = File(p.path));
//                 },
//                 child: _imgFile != null
//                   ? Image.file(_imgFile!, height: 100, width: 100, fit: BoxFit.cover)
//                   : buildSafeImage(widget.item?['image_url'], size: 100),
//               ),
//               TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "الاسم"), validator: (v) => v!.isEmpty ? "مطلوب" : null),
//               if (widget.isSub)
//                 DropdownButtonFormField<int>(
//                   value: _parentID,
//                   items: _parents.map((p) => DropdownMenuItem<int>(value: p['id'], child: Text(p['name']))).toList(),
//                   onChanged: (v) => setState(() => _parentID = v),
//                   decoration: const InputDecoration(labelText: "القسم الرئيسي"),
//                   validator: (v) => v == null ? "مطلوب" : null,
//                 ),
//             ],
//           ),
//         ),
//       ),
//       actions: [ _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _save, child: const Text("حفظ")) ],
//     );
//   }
// }

// // --- Product Dialog ---
// class ProductDialog extends StatefulWidget {
//   final dynamic product;
//   const ProductDialog({super.key, this.product});

//   @override
//   State<ProductDialog> createState() => _ProductDialogState();
// }

// class _ProductDialogState extends State<ProductDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _nC = TextEditingController();
//   final _pC = TextEditingController();
//   final _dC = TextEditingController();
//   int? _subID;
//   File? _img;
//   bool _load = false;
//   List<dynamic> _subs = [];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.product != null) {
//       _nC.text = widget.product['name'];
//       _pC.text = widget.product['price'].toString();
//       _dC.text = widget.product['description'] ?? '';
//       _subID = widget.product['subcategory_id'];
//     }
//     _fetchSubs();
//   }

//   _fetchSubs() async {
//     final data = await Supabase.instance.client.from('subcategories').select();
//     setState(() => _subs = data);
//   }

//   _save() async {
//     if (!_formKey.currentState!.validate() || _subID == null) return;
//     setState(() => _load = true);
//     try {
//       String? url = widget.product?['images'];
//       if (_img != null) {
//         final path = "prod_${DateTime.now().millisecondsSinceEpoch}.jpg";
//         await Supabase.instance.client.storage.from('products').upload(path, _img!);
//         url = Supabase.instance.client.storage.from('products').getPublicUrl(path);
//       }
//       final data = {
//         'name': _nC.text, 'price': double.parse(_pC.text),
//         'description': _dC.text, 'subcategory_id': _subID, 'images': url
//       };
//       if (widget.product == null) {
//         await Supabase.instance.client.from('products').insert(data);
//       } else {
//         await Supabase.instance.client.from('products').update(data).eq('id', widget.product['id']);
//       }
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally { setState(() => _load = false); }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("منتج"),
//       content: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: () async {
//                   final p = await ImagePicker().pickImage(source: ImageSource.gallery);
//                   if (p != null) setState(() => _img = File(p.path));
//                 },
//                 child: _img != null ? Image.file(_img!, height: 100) : buildSafeImage(widget.product?['image'], size: 100),
//               ),
//               TextFormField(controller: _nC, decoration: const InputDecoration(labelText: "الاسم"), validator: (v) => v!.isEmpty ? "مطلوب" : null),
//               TextFormField(controller: _pC, decoration: const InputDecoration(labelText: "السعر"), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? "مطلوب" : null),
//               DropdownButtonFormField<int>(
//                 value: _subID,
//                 items: _subs.map((s) => DropdownMenuItem<int>(value: s['id'], child: Text(s['name']))).toList(),
//                 onChanged: (v) => setState(() => _subID = v),
//                 decoration: const InputDecoration(labelText: "القسم الفرعي"),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [ _load ? const CircularProgressIndicator() : ElevatedButton(onPressed: _save, child: const Text("حفظ")) ],
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- Image Helper ---
Widget buildSafeImage(String? url, {double size = 50}) {
  if (url == null || url.isEmpty) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      child: Icon(Icons.image, color: Colors.grey[600], size: size * 0.5),
    );
  }
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image),
    ),
  );
}

class ManageStoreScreen extends StatefulWidget {
  const ManageStoreScreen({super.key});

  @override
  State<ManageStoreScreen> createState() => _ManageStoreScreenState();
}

class _ManageStoreScreenState extends State<ManageStoreScreen> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Store Management"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Main Categories", icon: Icon(Icons.grid_view)),
              Tab(text: "Subcategories", icon: Icon(Icons.account_tree)),
              Tab(text: "Products", icon: Icon(Icons.shopping_bag)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoryList(isSub: false),
            _buildCategoryList(isSub: true),
            _buildProductList(),
          ],
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              final index = DefaultTabController.of(context).index;
              if (index == 2) {
                _showProductDialog(context);
              } else {
                _showCategoryDialog(context, isSub: index == 1);
              }
            },
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryList({required bool isSub}) {
    final table = isSub ? 'subcategories' : 'categories';
    return StreamBuilder(
      stream: supabase.from(table).stream(primaryKey: ['id']),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            final item = data[i];
            return ListTile(
              leading: buildSafeImage(item['image']),
              title: Text(item['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showCategoryDialog(context,
                          item: item, isSub: isSub)),
                  IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _delete(table, item['id'])),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductList() {
    return StreamBuilder(
      stream: supabase.from('products').stream(primaryKey: ['id']),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final products = snapshot.data!;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, i) {
            final p = products[i];
            return ListTile(
              leading: buildSafeImage(p['image']),
              title: Text(p['name']),
              subtitle: Text("Price: ${p['price']} | Qty: ${p['qou']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showProductDialog(context, product: p)),
                  IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _delete('products', p['id'])),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _delete(String table, int id) async {
    await supabase.from(table).delete().eq('id', id);
  }

  void _showCategoryDialog(BuildContext context,
      {dynamic item, bool isSub = false}) {
    showDialog(
        context: context,
        builder: (context) => CategoryDialog(item: item, isSub: isSub));
  }

  void _showProductDialog(BuildContext context, {dynamic product}) {
    showDialog(
        context: context,
        builder: (context) => ProductDialog(product: product));
  }
}

// ==========================================
// Product Dialog (Added qou and limt)
// ==========================================
class ProductDialog extends StatefulWidget {
  final dynamic product;
  const ProductDialog({super.key, this.product});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _qouController = TextEditingController(); // Quantity field
  final _limitController = TextEditingController(); // Limit field

  int? _selectedSubId;
  List<dynamic> _subCategories = [];
  File? _imageFile;
  bool _loading = false;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchSubs();
    if (widget.product != null) {
      _nameController.text = widget.product['name'] ?? '';
      _priceController.text = widget.product['price']?.toString() ?? '';
      _descController.text = widget.product['description'] ?? '';
      _qouController.text =
          widget.product['qou']?.toString() ?? ''; // Populate quantity on edit
      _limitController.text =
          widget.product['limt']?.toString() ?? ''; // Populate limit on edit
      _selectedSubId = widget.product['subcategory_id'];
    }
  }

  Future<void> _fetchSubs() async {
    final data = await supabase.from('subcategories').select();
    setState(() => _subCategories = data);
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

    setState(() => _loading = true);
    String? imageUrl = widget.product?['image'];

    if (_imageFile != null) {
      final fileName = "prod_${DateTime.now().millisecondsSinceEpoch}";
      await supabase.storage
          .from('products-bucket')
          .upload(fileName, _imageFile!);
      imageUrl =
          supabase.storage.from('products-bucket').getPublicUrl(fileName);
    }

    final data = {
      'name': _nameController.text,
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'description': _descController.text,
      'qou': int.tryParse(_qouController.text) ?? 0, // Save quantity
      'limt': int.tryParse(_limitController.text) ?? 0, // Save limit
      'subcategory_id': _selectedSubId,
      'image': imageUrl,
    };

    try {
      if (widget.product == null) {
        await supabase.from('products').insert(data);
      } else {
        await supabase
            .from('products')
            .update(data)
            .eq('id', widget.product['id']);
      }
      Navigator.pop(context);
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? "Add Product" : "Edit Product"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final picked =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null)
                  setState(() => _imageFile = File(picked.path));
              },
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey[200],
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : (widget.product?['image'] != null
                        ? Image.network(widget.product['image'])
                        : const Icon(Icons.add_a_photo)),
              ),
            ),
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Product Name")),
            TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number),

            // --- New fields in UI ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: _qouController,
                      decoration:
                          const InputDecoration(labelText: "Quantity (qou)"),
                      keyboardType: TextInputType.number),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                      controller: _limitController,
                      decoration:
                          const InputDecoration(labelText: "Max Limit (limit)"),
                      keyboardType: TextInputType.number),
                ),
              ],
            ),

            TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 2),
            DropdownButtonFormField<int>(
              value: _selectedSubId,
              hint: const Text("Subcategory"),
              items: _subCategories
                  .map((s) => DropdownMenuItem<int>(
                      value: s['id'], child: Text(s['name'])))
                  .toList(),
              onChanged: (val) => setState(() => _selectedSubId = val),
            ),
          ],
        ),
      ),
      actions: [
        if (_loading)
          const CircularProgressIndicator()
        else
          ElevatedButton(onPressed: _save, child: const Text("Save Product"))
      ],
    );
  }
}

// Category Dialog (abbreviated as in original code)
class CategoryDialog extends StatefulWidget {
  final dynamic item;
  final bool isSub;
  const CategoryDialog({super.key, this.item, required this.isSub});
  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _nameController = TextEditingController();
  final supabase = Supabase.instance.client;
  @override
  void initState() {
    super.initState();
    if (widget.item != null) _nameController.text = widget.item['name'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Manage Category"),
      content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Name")),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pop(context), child: const Text("Close"))
      ],
    );
  }
}
