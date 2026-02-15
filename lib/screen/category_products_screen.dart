import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final supabase = Supabase.instance.client;

  Map<String, dynamic>? category;
  List subCategories = [];
  List products = [];
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    category = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (category != null) {
      loadData();
    }
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    // 1️⃣ جلب الأقسام الفرعية
    final subs = await supabase
        .from("subcategories")
        .select()
        .eq("parent_id", category!['id']);

    if (subs.isNotEmpty) {
      setState(() {
        subCategories = subs;
        loading = false;
      });
      return;
    }

    // 2️⃣ جلب المنتجات الخاصة بهذا القسم
    final prods = await supabase
        .from("products")
        .select()
        .eq("category_id", category!['id']);

    setState(() {
      products = prods;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = category?['name'] ?? "القسم";
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : subCategories.isNotEmpty
              ? _buildSubCategories()
              : products.isNotEmpty
                  ? _buildProducts()
                  : _buildEmptyState(),
    );
  }

  /// 🧱 واجهة الأقسام الفرعية
  Widget _buildSubCategories() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: subCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1,
      ),
      itemBuilder: (_, i) {
        final s = subCategories[i];
        return InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, "/category", arguments: s);
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: s['image'] != null && s['image'] != ''
                        ? Image.network(s['image'], fit: BoxFit.cover, width: double.infinity)
                        : Container(color: Colors.grey[200], child: const Icon(Icons.category)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🧱 واجهة المنتجات
  Widget _buildProducts() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 230,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (_, i) {
        final p = products[i];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/product-details", arguments: p);
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(p['image'], fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text("${p['price']} جنيه", style: const TextStyle(color: Colors.blue)),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🧱 واجهة عند عدم وجود بيانات
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "لا توجد منتجات حالياً",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text("سيتم إضافة المنتجات قريباً", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
