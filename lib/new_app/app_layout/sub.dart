// import 'package:flutter/material.dart';
// import 'package:raf/models/product_model.dart';

// class CategoryDetailScreen extends StatelessWidget {
//   final Map<dynamic, dynamic> data; // The JSON you provided

//   const CategoryDetailScreen({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final category = data['category'];
//     final categoryProducts = (data['category_products'] as List).map((p) => Product.fromJson(p)).toList();
//     final subcategories = (data['subcategories'] as List).map((s) => SubCategory.fromJson(s)).toList();

//     return Scaffold(
//       body: Directionality(
//         textDirection: TextDirection.rtl, // Set to RTL for Arabic
//         child: CustomScrollView(
//           slivers: [
//             // 1. BEAUTIFUL HEADER
//             SliverAppBar(
//               expandedHeight: 200,
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(category['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
//                 background: Image.network(category['image_url'], fit: BoxFit.cover),
//               ),
//             ),

//             // 2. DIRECT PRODUCTS SECTION (Horizontal Scroll)
//             if (categoryProducts.isNotEmpty)
//               SliverToBoxAdapter(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Text("منتجات مميزة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     ),
//                     SizedBox(
//                       height: 220,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: categoryProducts.length,
//                         itemBuilder: (context, index) => _buildProductCard(categoryProducts[index], width: 160),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//             // 3. SUBCATEGORIES SECTION
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   final sub = subcategories[index];
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Subcategory Header
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           children: [
//                             CircleAvatar(backgroundImage: NetworkImage(sub.imageUrl)),
//                             const SizedBox(width: 12),
//                             Text(sub.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ),
//                       // Subcategory Products Grid
//                       GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 0.75,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 10,
//                         ),
//                         itemCount: sub.products.length,
//                         itemBuilder: (context, pIndex) => _buildProductCard(sub.products[pIndex]),
//                       ),
//                     ],
//                   );
//                 },
//                 childCount: subcategories.length,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // REUSABLE PRODUCT CARD
//   Widget _buildProductCard(Product product, {double? width}) {
//     return Container(
//       width: width,
//       margin: width != null ? const EdgeInsets.only(left: 12) : null,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//             child: Image.network(product.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(product.name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 Text(product.description, maxLines: 2, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                 const SizedBox(height: 5),
//                 Text("${product.price} ج.م", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raf/core/components.dart';
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/cubit/app/app_state.dart';
import 'package:raf/new_app/app_layout/pro.dart';
import 'package:raf/new_app/cart.dart';

class StoreCategoryScreen extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  const StoreCategoryScreen({super.key, required this.data});

  @override
  State<StoreCategoryScreen> createState() => _StoreCategoryScreenState();
}

class _StoreCategoryScreenState extends State<StoreCategoryScreen> {
  int selectedSubId =0; // للتحكم في الفلترة

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    // استخراج البيانات من الـ JSON
    final categoryName = widget.data['category']['name'];
    final subcategories = widget.data['subcategories'] as List;
    final directProducts =[];

    // دمج المنتجات للعرض
    List displayProducts = [];
    if (selectedSubId == 0) {
      displayProducts = [...directProducts];
      for (var sub in subcategories) {
        displayProducts.addAll(sub['products']);
      }
    } else {
      displayProducts = subcategories.firstWhere(
        (s) => s['id'] == selectedSubId,
      )['products'];
    }

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              categoryName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
       
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search, color: Colors.black),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: CircleAvatar(
            backgroundColor: Colors.green,
            
            child: IconButton(onPressed: (){
              navigateTo(context, CartScreen());
            }, icon: Icon(Icons.shopping_cart)),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // قسم الشركات
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "الشركات",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // قائمة دائرية أفقية
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: subcategories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0)
                        return _buildBrandItem("الكل", 0, null);
                      final sub = subcategories[index - 1];
                      return _buildBrandItem(
                        sub['name'],
                        sub['id'],
                        sub['image_url'],
                      );
                    },
                  ),
                ),

                // عداد المنتجات
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    "يوجد ${displayProducts.length} منتج",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                // شبكة المنتجات
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: displayProducts.length,
                    itemBuilder: (context, index) =>
                        InkWell(
                          onTap: () => navigateTo(context, ProductDetailsScreen(product: displayProducts[index],)),
                          child: _buildProductCard(displayProducts[index])),
                  ),
                ),
              ],
            ),
          ),
  
     );
      },
    );
  }

  // ويدجت دائرة الشركة
  Widget _buildBrandItem(String name, int id, String? imageUrl) {
    bool isSelected = selectedSubId == id;
    return GestureDetector(
      onTap: () => setState(() => selectedSubId = id),
      child: Container(
        width: 80,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[200]!,
                  width: 2,
                ),
                color: Colors.white,
                image: imageUrl != null
                    ? DecorationImage(
                        image: getNetworkImageProvider(imageUrl),
                        fit: BoxFit.contain,
                      )
                    : null,
              ),
              child: imageUrl == null
                  ? Center(
                      child: Text(
                        "كل الشركات",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.blue[900]),
                      ),
                    )
                  : null,
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت كرت المنتج
  Widget _buildProductCard(dynamic product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: buildNetworkImage(
                    product['images'],
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "جاري تفعيل حسابك",
                      style: TextStyle(color: Colors.orange, fontSize: 10),
                    ),
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${product['price']} ج.م",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // زر الإضافة الأزرق
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
