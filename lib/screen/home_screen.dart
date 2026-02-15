// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:raf/cubit/product/product_cubit.dart';
// import 'package:raf/cubit/product/product_state.dart';
// import 'package:raf/widgets/category_tile.dart';
// import 'package:raf/widgets/offer_carousel.dart';
// import '../../widgets/product_card.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProductCubit>().loadInitialData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("المتجر"),
//         centerTitle: true,
//       ),
//       body: BlocBuilder<ProductCubit, ProductState>(
//         builder: (context, state) {

//           if (state is ProductLoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is ProductsLoadedState) {
//             final offers = state.offers;
//             final categories = state.categories;
//             final products = state.products;

//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   /// ==== Offers Slider ====
//                   if (offers.isNotEmpty)
//                     OfferCarousel(offers: offers)
//                   else
//                     const SizedBox.shrink(),

//                   const SizedBox(height: 15),
//                   const Text("الأقسام", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),

//                   /// ==== Categories ====
//                   SizedBox(
//                     height: 120,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: categories.length,
//                       separatorBuilder: (_, __) => const SizedBox(width: 10),
//                       itemBuilder: (ctx, i) {
//                         return CategoryTile(category: categories[i]);
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 20),
//                   const Text("أحدث المنتجات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),

//                   /// ==== Products ====
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: products.length,
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: .7,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemBuilder: (ctx, i) {
//                       return ProductCard(product: products[i]);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           }

//           return const Center(child: Text("حدث خطأ، حاول مجدداً"));
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raf/core/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  List offers = [];
  List categories = [];
  List products = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final offerData = await supabase.from("offers").select();
    final catData = await supabase.from("categories").select();
    final prodData = await supabase.from("products").select().limit(10);
    setState(() {
      offers = offerData;
      categories = catData;
      products = prodData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ELLA 🛍️"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              // TODO: go to cart page
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 العروض
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Offers",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offers.length,
                  itemBuilder: (_, i) {
                    final o = offers[i];
                    return Container(
                      width: 280,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: getNetworkImageProvider(o['image_url']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6)
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(o['title'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 🔹 الأقسام
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Categories",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (_, i) {
                    final c = categories[i];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/category",
                        );
                      },
                      child: Container(
                        width: 90,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  getNetworkImageProvider(c['image_url']),
                            ),
                            const SizedBox(height: 6),
                            Text(c['name'],
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 🔹 المنتجات
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Featured Products",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                      Navigator.pushNamed(context, "/product-details",
                          arguments: p);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Expanded(
                          //   child: ClipRRect(
                          //     borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          //     child: Image.network(p['image_url'], fit: BoxFit.cover, width: double.infinity),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(6.0),
                          //   child: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          //   child: Text("${p['price']} جنيه", style: const TextStyle(color: Colors.blue)),
                          // ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
