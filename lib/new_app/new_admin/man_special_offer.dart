// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';

// // class ManageSpecialOfferScreen extends StatefulWidget {
// //   const ManageSpecialOfferScreen({super.key});

// //   @override
// //   State<ManageSpecialOfferScreen> createState() => _ManageSpecialOfferScreenState();
// // }

// // class _ManageSpecialOfferScreenState extends State<ManageSpecialOfferScreen> {
// //   final supabase = Supabase.instance.client;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("إدارة العروض الخاصة")),
// //       body: StreamBuilder(
// //         // Listening to the special_offer table
// //         stream: supabase.from('special_offer').stream(primaryKey: ['id']).limit(1),
// //         builder: (context, snapshot) {
// //           if (snapshot.hasError) return Center(child: Text("خطأ: ${snapshot.error}"));
// //           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

// //           final offers = snapshot.data!;
// //           if (offers.isEmpty) return _buildEmptyState();

// //           final offer = offers.first;
// //           return _buildOfferCard(offer);
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Icon(Icons.star_outline, size: 80, color: Colors.amber),
// //           const SizedBox(height: 10),
// //           const Text("لا يوجد عرض خاص نشط"),
// //           const SizedBox(height: 20),
// //           ElevatedButton.icon(
// //             onPressed: () => _showOfferDialog(),
// //             icon: const Icon(Icons.add),
// //             label: const Text("إضافة عرض خاص جديد"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildOfferCard(Map<String, dynamic> offer) {
// //     return Padding(
// //       padding: const EdgeInsets.all(15.0),
// //       child: Column(
// //         children: [
// //           Card(
// //             clipBehavior: Clip.antiAlias,
// //             elevation: 4,
// //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Image.network(
// //                   offer['images'] ?? '',
// //                   height: 220,
// //                   width: double.infinity,
// //                   fit: BoxFit.cover,
// //                   errorBuilder: (c, e, s) => Container(height: 220, color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.all(12.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Text(offer['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //                           Text("${offer['price']} ر.س", style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 5),
// //                       Text(offer['description'] ?? '', style: TextStyle(color: Colors.grey[700])),
// //                       if (offer['dis'] != null) ...[
// //                         const SizedBox(height: 10),
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                           decoration: BoxDecoration(color: Colors.red[100], borderRadius: BorderRadius.circular(5)),
// //                           child: Text("خصم: ${offer['dis']}%", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //             children: [
// //               ElevatedButton.icon(
// //                 onPressed: () => _showOfferDialog(offer: offer),
// //                 icon: const Icon(Icons.edit),
// //                 label: const Text("تعديل العرض"),
// //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
// //               ),
// //               ElevatedButton.icon(
// //                 onPressed: () => _deleteOffer(offer['id']),
// //                 icon: const Icon(Icons.delete),
// //                 label: const Text("حذف"),
// //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
// //               ),
// //             ],
// //           )
// //         ],
// //       ),
// //     );
// //   }

// //   void _showOfferDialog({Map<String, dynamic>? offer}) {
// //     showDialog(context: context, builder: (context) => SpecialOfferDialog(offer: offer));
// //   }

// //   Future<void> _deleteOffer(dynamic id) async {
// //     await supabase.from('special_offer').delete().eq('id', id);
// //     if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم حذف العرض بنجاح")));
// //   }
// // }

// // class SpecialOfferDialog extends StatefulWidget {
// //   final Map<String, dynamic>? offer;
// //   const SpecialOfferDialog({super.key, this.offer});

// //   @override
// //   State<SpecialOfferDialog> createState() => _SpecialOfferDialogState();
// // }

// // class _SpecialOfferDialogState extends State<SpecialOfferDialog> {
// //   final _nameController = TextEditingController();
// //   final _priceController = TextEditingController();
// //   final _disController = TextEditingController();
// //   final _descController = TextEditingController();
// //   File? _imageFile;
// //   bool _loading = false;
// //   final supabase = Supabase.instance.client;

// //   @override
// //   void initState() {
// //     super.initState();
// //     if (widget.offer != null) {
// //       _nameController.text = widget.offer!['name'] ?? '';
// //       _priceController.text = widget.offer!['price'].toString();
// //       _disController.text = widget.offer!['dis']?.toString() ?? '';
// //       _descController.text = widget.offer!['description'] ?? '';
// //     }
// //   }

// //   Future<void> _save() async {
// //     if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

// //     setState(() => _loading = true);
// //     try {
// //       String? imageUrl = widget.offer?['images'];

// //       if (_imageFile != null) {
// //         final fileName = "special_${DateTime.now().millisecondsSinceEpoch}.jpg";
// //         // Using the special_offer bucket
// //         await supabase.storage.from('special_offer').upload(fileName, _imageFile!);
// //         imageUrl = supabase.storage.from('special_offer').getPublicUrl(fileName);
// //       }

// //       final data = {
// //         'name': _nameController.text,
// //         'price': double.parse(_priceController.text),
// //         'dis': _disController.text.isNotEmpty ? int.parse(_disController.text) : null,
// //         'description': _descController.text,
// //         'images': imageUrl,
// //       };

// //       if (widget.offer == null) {
// //         await supabase.from('special_offer').insert(data);
// //       } else {
// //         await supabase.from('special_offer').update(data).eq('id', widget.offer!['id']);
// //       }
// //       if (mounted) Navigator.pop(context);
// //     } catch (e) {
// //       setState(() => _loading = false);
// //       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ: $e")));
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       title: Text(widget.offer == null ? "إضافة عرض خاص" : "تعديل العرض الخاص"),
// //       content: SingleChildScrollView(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             GestureDetector(
// //               onTap: () async {
// //                 final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
// //                 if (picked != null) setState(() => _imageFile = File(picked.path));
// //               },
// //               child: Container(
// //                 height: 140, width: double.infinity, color: Colors.grey[200],
// //                 margin: const EdgeInsets.only(bottom: 10),
// //                 child: _imageFile != null
// //                   ? Image.file(_imageFile!, fit: BoxFit.cover)
// //                   : (widget.offer?['images'] != null
// //                       ? Image.network(widget.offer!['images'], fit: BoxFit.cover)
// //                       : const Icon(Icons.add_a_photo, size: 40)),
// //               ),
// //             ),
// //             TextField(controller: _nameController, decoration: const InputDecoration(labelText: "اسم العرض (Name)")),
// //             TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "السعر (Price)")),
// //             TextField(controller: _disController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "الخصم % (Dis)")),
// //             TextField(controller: _descController, decoration: const InputDecoration(labelText: "الوصف"), maxLines: 2),
// //           ],
// //         ),
// //       ),
// //       actions: [
// //         TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
// //         _loading
// //           ? const CircularProgressIndicator()
// //           : ElevatedButton(onPressed: _save, child: const Text("حفظ البيانات")),
// //       ],
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ManageSpecialOfferScreen extends StatefulWidget {
//   const ManageSpecialOfferScreen({super.key});

//   @override
//   State<ManageSpecialOfferScreen> createState() => _ManageSpecialOfferScreenState();
// }

// class _ManageSpecialOfferScreenState extends State<ManageSpecialOfferScreen> {
//   final supabase = Supabase.instance.client;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("إدارة العروض الخاصة")),
//       body: StreamBuilder(
//         stream: supabase.from('special_offer').stream(primaryKey: ['id']).limit(1),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) return Center(child: Text("خطأ: ${snapshot.error}"));
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

//           final offers = snapshot.data!;
//           if (offers.isEmpty) return _buildEmptyState();

//           final offer = offers.first;
//           return _buildOfferCard(offer);
//         },
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.star_outline, size: 80, color: Colors.amber),
//           const SizedBox(height: 10),
//           const Text("لا يوجد عرض خاص نشط"),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: () => _showOfferDialog(),
//             icon: const Icon(Icons.add),
//             label: const Text("إضافة عرض خاص جديد"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOfferCard(Map<String, dynamic> offer) {
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Card(
//               clipBehavior: Clip.antiAlias,
//               elevation: 4,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.network(
//                     offer['images'] ?? '',
//                     height: 220,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (c, e, s) => Container(height: 220, color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(offer['name'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                             Text("${offer['price']} ر.س", style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         // عرض الكمية والحد الأقصى في الكارت
//                         Row(
//                           children: [
//                             _buildInfoBadge("الكمية المتاحة: ${offer['qou'] ?? 0}", Colors.blue),
//                             const SizedBox(width: 8),
//                             _buildInfoBadge("الحد للشراء: ${offer['limt'] ?? 0}", Colors.orange),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Text(offer['description'] ?? '', style: TextStyle(color: Colors.grey[700])),
//                         if (offer['dis'] != null) ...[
//                           const SizedBox(height: 10),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(color: Colors.red[100], borderRadius: BorderRadius.circular(5)),
//                             child: Text("خصم: ${offer['dis']}%", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () => _showOfferDialog(offer: offer),
//                   icon: const Icon(Icons.edit),
//                   label: const Text("تعديل العرض"),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () => _deleteOffer(offer['id']),
//                   icon: const Icon(Icons.delete),
//                   label: const Text("حذف"),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoBadge(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color)),
//       child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
//     );
//   }

//   void _showOfferDialog({Map<String, dynamic>? offer}) {
//     showDialog(context: context, builder: (context) => SpecialOfferDialog(offer: offer));
//   }

//   Future<void> _deleteOffer(dynamic id) async {
//     await supabase.from('special_offer').delete().eq('id', id);
//     if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم حذف العرض بنجاح")));
//   }
// }

// class SpecialOfferDialog extends StatefulWidget {
//   final Map<String, dynamic>? offer;
//   const SpecialOfferDialog({super.key, this.offer});

//   @override
//   State<SpecialOfferDialog> createState() => _SpecialOfferDialogState();
// }

// class _SpecialOfferDialogState extends State<SpecialOfferDialog> {
//   final _nameController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _disController = TextEditingController();
//   final _descController = TextEditingController();
//   final _qouController = TextEditingController(); // حقل الكمية
//   final _limitController = TextEditingController(); // حقل الحد الأقصى
//   File? _imageFile;
//   bool _loading = false;
//   final supabase = Supabase.instance.client;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.offer != null) {
//       _nameController.text = widget.offer!['name'] ?? '';
//       _priceController.text = widget.offer!['price'].toString();
//       _disController.text = widget.offer!['dis']?.toString() ?? '';
//       _descController.text = widget.offer!['description'] ?? '';
//       _qouController.text = widget.offer!['qou']?.toString() ?? ''; // تعبئة الكمية
//       _limitController.text = widget.offer!['limt']?.toString() ?? ''; // تعبئة الحد
//     }
//   }

//   Future<void> _save() async {
//     if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

//     setState(() => _loading = true);
//     try {
//       String? imageUrl = widget.offer?['images'];

//       if (_imageFile != null) {
//         final fileName = "special_${DateTime.now().millisecondsSinceEpoch}.jpg";
//         await supabase.storage.from('special_offer').upload(fileName, _imageFile!);
//         imageUrl = supabase.storage.from('special_offer').getPublicUrl(fileName);
//       }

//       final data = {
//         'name': _nameController.text,
//         'price': double.parse(_priceController.text),
//         'dis': _disController.text.isNotEmpty ? int.parse(_disController.text) : null,
//         'description': _descController.text,
//         'images': imageUrl,
//         'qou': int.tryParse(_qouController.text) ?? 0, // حفظ الكمية
//         'limt': int.tryParse(_limitController.text) ?? 0, // حفظ الحد الأقصى
//       };

//       if (widget.offer == null) {
//         await supabase.from('special_offer').insert(data);
//       } else {
//         await supabase.from('special_offer').update(data).eq('id', widget.offer!['id']);
//       }
//       if (mounted) Navigator.pop(context);
//     } catch (e) {
//       setState(() => _loading = false);
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.offer == null ? "إضافة عرض خاص" : "تعديل العرض الخاص"),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onTap: () async {
//                 final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//                 if (picked != null) setState(() => _imageFile = File(picked.path));
//               },
//               child: Container(
//                 height: 140, width: double.infinity, color: Colors.grey[200],
//                 margin: const EdgeInsets.only(bottom: 10),
//                 child: _imageFile != null
//                   ? Image.file(_imageFile!, fit: BoxFit.cover)
//                   : (widget.offer?['images'] != null
//                       ? Image.network(widget.offer!['images'], fit: BoxFit.cover)
//                       : const Icon(Icons.add_a_photo, size: 40)),
//               ),
//             ),
//             TextField(controller: _nameController, decoration: const InputDecoration(labelText: "اسم العرض")),
//             TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "السعر")),

//             // إضافة صف يحتوي على الكمية والحد الأقصى
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _qouController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(labelText: "الكمية (qou)")
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     controller: _limitController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(labelText: "الحد الأقصى (limt)")
//                   ),
//                 ),
//               ],
//             ),

//             TextField(controller: _disController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "الخصم %")),
//             TextField(controller: _descController, decoration: const InputDecoration(labelText: "الوصف"), maxLines: 2),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
//         _loading
//           ? const CircularProgressIndicator()
//           : ElevatedButton(onPressed: _save, child: const Text("حفظ البيانات")),
//       ],
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageSpecialOfferScreen extends StatefulWidget {
  const ManageSpecialOfferScreen({super.key});

  @override
  State<ManageSpecialOfferScreen> createState() =>
      _ManageSpecialOfferScreenState();
}

class _ManageSpecialOfferScreenState extends State<ManageSpecialOfferScreen> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Special Offers Management"),
      ),
      body: StreamBuilder(
        // Now listening to all offers instead of just one
        stream: supabase
            .from('special_offer')
            .stream(primaryKey: ['id']).order('id'),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final offers = snapshot.data!;
          if (offers.isEmpty) return _buildEmptyState();

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              return _buildOfferItem(offers[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOfferDialog(),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_outline, size: 80, color: Colors.amber),
          const SizedBox(height: 10),
          const Text("No offers currently"),
        ],
      ),
    );
  }

  // Build individual offer item in the list
  Widget _buildOfferItem(Map<String, dynamic> offer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(
                offer['images'] ?? '',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image)),
              ),
              if (offer['dis'] != null)
                PositionRectangle(offer['dis'].toString()),
            ],
          ),
          ListTile(
            title: Text(offer['name'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle:
                Text("Price: ${offer['price']} | Quantity: ${offer['qou']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showOfferDialog(offer: offer),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteOffer(offer['id']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget PositionRectangle(String discount) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(5)),
        child: Text("$discount% Off",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showOfferDialog({Map<String, dynamic>? offer}) {
    showDialog(
        context: context,
        builder: (context) => SpecialOfferDialog(offer: offer));
  }

  Future<void> _deleteOffer(dynamic id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Offer"),
        content: const Text("Are you sure you want to delete this offer?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await supabase.from('special_offer').delete().eq('id', id);
    }
  }
}

// Add/Edit Dialog
class SpecialOfferDialog extends StatefulWidget {
  final Map<String, dynamic>? offer;
  const SpecialOfferDialog({super.key, this.offer});

  @override
  State<SpecialOfferDialog> createState() => _SpecialOfferDialogState();
}

class _SpecialOfferDialogState extends State<SpecialOfferDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _disController = TextEditingController();
  final _descController = TextEditingController();
  final _qouController = TextEditingController();
  final _limitController = TextEditingController();
  File? _imageFile;
  bool _loading = false;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (widget.offer != null) {
      _nameController.text = widget.offer!['name'] ?? '';
      _priceController.text = widget.offer!['price'].toString();
      _disController.text = widget.offer!['dis']?.toString() ?? '';
      _descController.text = widget.offer!['description'] ?? '';
      _qouController.text = widget.offer!['qou']?.toString() ?? '';
      _limitController.text = widget.offer!['limt']?.toString() ?? '';
    }
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;
    setState(() => _loading = true);

    try {
      String? imageUrl = widget.offer?['images'];
      if (_imageFile != null) {
        final fileName = "special_${DateTime.now().millisecondsSinceEpoch}.jpg";
        await supabase.storage
            .from('special_offer')
            .upload(fileName, _imageFile!);
        imageUrl =
            supabase.storage.from('special_offer').getPublicUrl(fileName);
      }

      final data = {
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'dis': _disController.text.isNotEmpty
            ? int.parse(_disController.text)
            : null,
        'description': _descController.text,
        'images': imageUrl,
        'qou': int.tryParse(_qouController.text) ?? 0,
        'limt': int.tryParse(_limitController.text) ?? 0,
      };

      if (widget.offer == null) {
        await supabase.from('special_offer').insert(data);
      } else {
        await supabase
            .from('special_offer')
            .update(data)
            .eq('id', widget.offer!['id']);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _loading = false);
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.offer == null ? "Add New Offer" : "Edit Offer"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildImagePicker(),
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Offer Name")),
            TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price")),
            Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: _qouController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Quantity"))),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                        controller: _limitController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Max Limit"))),
              ],
            ),
            TextField(
                controller: _disController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Discount %")),
            TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 2),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(onPressed: _save, child: const Text("Save")),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        final picked =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (picked != null) setState(() => _imageFile = File(picked.path));
      },
      child: Container(
        height: 120,
        width: double.infinity,
        color: Colors.grey[200],
        child: _imageFile != null
            ? Image.file(_imageFile!, fit: BoxFit.cover)
            : (widget.offer?['images'] != null
                ? Image.network(widget.offer!['images'], fit: BoxFit.cover)
                : const Icon(Icons.add_a_photo)),
      ),
    );
  }
}
