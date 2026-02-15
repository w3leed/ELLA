// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ManageOfferScreen extends StatefulWidget {
//   const ManageOfferScreen({super.key});

//   @override
//   State<ManageOfferScreen> createState() => _ManageOfferScreenState();
// }

// class _ManageOfferScreenState extends State<ManageOfferScreen> {
//   final supabase = Supabase.instance.client;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("إدارة العرض الترويجي")),
//       body: StreamBuilder(
//         stream: supabase.from('offers').stream(primaryKey: ['id']).limit(1),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final offers = snapshot.data!;

//           if (offers.isEmpty) {
//             return _buildEmptyState();
//           }

//           final offer = offers.first;
//           return _buildOfferCard(offer);
//         },
//       ),
//     );
//   }

//   // واجهة عند عدم وجود عرض
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.local_offer_outlined, size: 80, color: Colors.grey),
//           const SizedBox(height: 10),
//           const Text("لا يوجد عرض نشط حالياً"),
//           ElevatedButton.icon(
//             onPressed: () => _showOfferDialog(),
//             icon: const Icon(Icons.add),
//             label: const Text("إضافة عرض جديد"),
//           ),
//         ],
//       ),
//     );
//   }

//   // واجهة عرض العرض الحالي
//   Widget _buildOfferCard(dynamic offer) {
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Column(
//         children: [
//           Card(
//             clipBehavior: Clip.antiAlias,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             child: Column(
//               children: [
//                 Image.network(offer['image'] ?? '', height: 200, width: double.infinity, fit: BoxFit.cover,
//                   errorBuilder: (c,e,s) => Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.image))),
//                 ListTile(
//                   title: Text(offer['title'] ?? 'بدون عنوان', style: const TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Text(offer['description'] ?? ''),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () => _showOfferDialog(offer: offer),
//                 icon: const Icon(Icons.edit),
//                 label: const Text("تعديل العرض"),
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () => _deleteOffer(offer['id']),
//                 icon: const Icon(Icons.delete),
//                 label: const Text("حذف"),
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   void _showOfferDialog({dynamic offer}) {
//     showDialog(context: context, builder: (context) => OfferDialog(offer: offer));
//   }

//   Future<void> _deleteOffer(int id) async {
//     await supabase.from('offers').delete().eq('id', id);
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم حذف العرض")));
//   }
// }

// // ==========================================
// // نافذة الإضافة والتعديل
// // ==========================================
// class OfferDialog extends StatefulWidget {
//   final dynamic offer;
//   const OfferDialog({super.key, this.offer});

//   @override
//   State<OfferDialog> createState() => _OfferDialogState();
// }

// class _OfferDialogState extends State<OfferDialog> {
//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();
//   File? _imageFile;
//   bool _loading = false;
//   final supabase = Supabase.instance.client;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.offer != null) {
//       _titleController.text = widget.offer['title'] ?? '';
//       _descController.text = widget.offer['description'] ?? '';
//     }
//   }

//   Future<void> _save() async {
//     setState(() => _loading = true);
//     String? imageUrl = widget.offer?['image'];

//     if (_imageFile != null) {
//       final fileName = "offer_${DateTime.now().millisecondsSinceEpoch}";
//       await supabase.storage.from('products-bucket').upload(fileName, _imageFile!);
//       imageUrl = supabase.storage.from('products-bucket').getPublicUrl(fileName);
//     }

//     final data = {
//       'title': _titleController.text,
//       'description': _descController.text,
//       'image': imageUrl,
//     };

//     if (widget.offer == null) {
//       await supabase.from('offers').insert(data);
//     } else {
//       await supabase.from('offers').update(data).eq('id', widget.offer['id']);
//     }
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.offer == null ? "إضافة عرض" : "تعديل العرض"),
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () async {
//                 final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//                 if (picked != null) setState(() => _imageFile = File(picked.path));
//               },
//               child: Container(
//                 height: 120, width: double.infinity, color: Colors.grey[200],
//                 child: _imageFile != null ? Image.file(_imageFile!, fit: BoxFit.cover) : (widget.offer?['image'] != null ? Image.network(widget.offer['image']) : const Icon(Icons.add_a_photo, size: 40)),
//               ),
//             ),
//             TextField(controller: _titleController, decoration: const InputDecoration(labelText: "عنوان العرض (مثال: خصم 50%)")),
//             TextField(controller: _descController, decoration: const InputDecoration(labelText: "الوصف"), maxLines: 2),
//           ],
//         ),
//       ),
//       actions: [_loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _save, child: const Text("حفظ العرض"))],
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageOfferScreen extends StatefulWidget {
  const ManageOfferScreen({super.key});

  @override
  State<ManageOfferScreen> createState() => _ManageOfferScreenState();
}

class _ManageOfferScreenState extends State<ManageOfferScreen> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Promo Offer Management")),
      body: StreamBuilder(
        stream: supabase.from('offers').stream(primaryKey: ['id']).limit(1),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final offers = snapshot.data!;
          if (offers.isEmpty) return _buildEmptyState();

          final offer = offers.first;
          return _buildOfferCard(offer);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_offer_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 10),
          const Text("No active offer currently"),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _showOfferDialog(),
            icon: const Icon(Icons.add),
            label: const Text("Add New Offer"),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Image.network(
                  offer['image'] ?? '',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image)),
                ),
                ListTile(
                  title: Text(
                    "${offer['discount_percent']}% Off on orders above ${offer['min_amount']} EGP",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(offer['description'] ?? ''),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showOfferDialog(offer: offer),
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
              ),
              ElevatedButton.icon(
                onPressed: () => _deleteOffer(offer['id']),
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showOfferDialog({Map<String, dynamic>? offer}) {
    showDialog(
        context: context, builder: (context) => OfferDialog(offer: offer));
  }

  Future<void> _deleteOffer(dynamic id) async {
    await supabase.from('offers').delete().eq('id', id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Offer deleted successfully")));
    }
  }
}

class OfferDialog extends StatefulWidget {
  final Map<String, dynamic>? offer;
  const OfferDialog({super.key, this.offer});

  @override
  State<OfferDialog> createState() => _OfferDialogState();
}

class _OfferDialogState extends State<OfferDialog> {
  final _minAmountController = TextEditingController();
  final _discountController = TextEditingController();
  final _descController = TextEditingController();
  File? _imageFile;
  bool _loading = false;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    if (widget.offer != null) {
      _minAmountController.text = widget.offer!['min_amount'].toString();
      _discountController.text = widget.offer!['discount_percent'].toString();
      _descController.text = widget.offer!['description'] ?? '';
    }
  }

  Future<void> _save() async {
    if (_minAmountController.text.isEmpty || _discountController.text.isEmpty)
      return;

    setState(() => _loading = true);
    try {
      String? imageUrl = widget.offer?['image'];

      if (_imageFile != null) {
        final fileName = "promo_${DateTime.now().millisecondsSinceEpoch}.jpg";
        // Updated bucket name to 'offers'
        await supabase.storage.from('offers').upload(fileName, _imageFile!);
        imageUrl = supabase.storage.from('offers').getPublicUrl(fileName);
      }

      final data = {
        'min_amount': double.parse(_minAmountController.text),
        'discount_percent': double.parse(_discountController.text),
        'description': _descController.text,
        'image': imageUrl,
      };

      if (widget.offer == null) {
        await supabase.from('offers').insert(data);
      } else {
        await supabase
            .from('offers')
            .update(data)
            .eq('id', widget.offer!['id']);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.offer == null ? "Add Offer" : "Edit Offer"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    : (widget.offer?['image'] != null
                        ? Image.network(widget.offer!['image'],
                            fit: BoxFit.cover)
                        : const Icon(Icons.add_a_photo, size: 40)),
              ),
            ),
            TextField(
              controller: _minAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Minimum Amount"),
            ),
            TextField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: "Discount Percent %"),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Offer Description"),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(onPressed: _save, child: const Text("Save Offer")),
      ],
    );
  }
}
