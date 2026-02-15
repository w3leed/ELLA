import 'package:flutter/material.dart';
import 'package:raf/core/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raf/core/components.dart';
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/cubit/app/app_state.dart';
import 'package:raf/new_app/about_us.dart';
import 'package:raf/new_app/app_layout/all_s_offer.dart';
import 'package:raf/new_app/app_layout/category_item.dart';
import 'package:raf/new_app/app_layout/offer_card.dart';
import 'package:raf/new_app/app_layout/s_offer.dart';
import 'package:raf/new_app/app_layout/search.dart';

class RafLayout extends StatelessWidget {
  const RafLayout({super.key});

  @override
  Widget build(Object context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getoffer()
        ..getCategory()
        ..getSpecialOffers(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is GetProductSuccess) {}
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("ELLA 🛍️"),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  navigateTo(context, ProductSearchScreen());
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    navigateTo(context, AboutUsScreen());
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Don't miss the chance 🔥  ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    //
                    cubit.offer.isEmpty
                        ? Column(
                            children: [
                              Text(
                                "Something great is cooking.. Stay tuned! ✨",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Image.asset('assets/images/490.jpg', height: 200),
                            ],
                          )
                        : SizedBox(
                            height: 205,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: cubit.offer.length,
                              itemBuilder: (context, index) => SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: OfferCard(
                                  description: cubit.offer[index]
                                      ['description'],
                                  photoUrl: cubit.offer[index]['image'],
                                  discount: cubit.offer[index]
                                      ['discount_percent'],
                                ),
                              ),
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 20),
                            ),
                          ),
                    Text(
                      "Browse and discover our categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: cubit.category.length,
                        itemBuilder: (context, index) {
                          //  final category = categories[index];
                          return CategoryItem(
                            name: cubit.category[index]['name'],
                            photoUrl: cubit.category[index]['image_url'],
                            onTap: () {
                              print(cubit.category[index]['id']!);
                              cubit.fetchCategory(
                                cubit.category[index]['id']!,
                                context,
                              );
                              print('ssssssssss');
                              print(cubit.data);

                              //   print('Category ${category['name']} tapped!');
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Special Offers 🔥",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllOffersScreen(),
                              ),
                            ),
                            child: const Text("More"),
                          ),
                        ],
                      ),
                    ),
                    // Text(cubit.specialOffers.length.toString()),
                    cubit.specialOffers.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Wait for the best offers ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 240, // Increased height to prevent overflow
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5, // Add vertical padding for shadow
                              ),
                              itemCount: cubit.specialOffers.length,
                              itemBuilder: (context, index) => _buildOfferCard(
                                context,
                                cubit.specialOffers[index],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildOfferCard(BuildContext context, dynamic offer) {
  double discountedPrice =
      offer['price'] - (offer['price'] * offer['dis'] / 100);

  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpecialOfferDetailsScreen(offer: offer),
      ),
    ),
    child: Container(
      width: 170, // Slightly wider
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: buildNetworkImage(
                  offer['images'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (offer['dis'] > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "-${offer['dis']}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  offer['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer['name_extra'] ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "$discountedPrice EGP",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// // Sample data
// final List<Map<String, String>> categories = [
//   {
//     'name': 'Electronics',
//     'photoUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
//   },
//   {
//     'name': 'Fashion',
//     'photoUrl': 'https://images.unsplash.com/photo-1483985988355-763728e1935b',
//   },
//   {
//     'name': 'Home & Kitchen',
//     'photoUrl': 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15',
//   },
//   {
//     'name': 'Sports',
//     'photoUrl': 'https://images.unsplash.com/photo-1517649763962-0c623066013b',
//   },
//   {
//     'name': 'Beauty',
//     'photoUrl': 'https://images.unsplash.com/photo-1599351431202-1e0f0137899a',
//   },
//   {
//     'name': 'Books',
//     'photoUrl': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
//   },
// ];
