import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/cubit/app/app_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب البيانات عند فتح الشاشة
    AppCubit.get(context).getCartItems();

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: const Text("Shopping Cart",
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: state is GetCartLoadingState
                ? const Center(child: CircularProgressIndicator())
                : cubit.cartItems.isEmpty
                    ? _buildEmptyCart()
                    : _buildCartList(cubit),
            bottomNavigationBar: cubit.cartItems.isEmpty
                ? null
                : _buildCheckoutBar(cubit, context),
          ),
        );
      },
    );
  }

  // 1. واجهة السلة الفارغة
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text("Your cart is currently empty",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 10),
          const Text("Start adding some great products!",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // 2. قائمة المنتجات في السلة
  Widget _buildCartList(AppCubit cubit) {
    return ListView.separated(
      padding: const EdgeInsets.all(15),
      itemCount: cubit.cartItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        var item = cubit.cartItems[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item['image_url'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text("${item['price']} EGP",
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                    Text("Quantity: ${item['quantity']}",
                        style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => cubit.removeFromCart(item['product_id']),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckoutBar(AppCubit cubit, context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cubit.discountAmount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Original Total:",
                      style: TextStyle(color: Colors.grey[600])),
                  Text("${cubit.totalPrice} EGP",
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough)),
                ],
              ),
            ),
          if (cubit.discountAmount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Discount Applied:",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
                Text("- ${cubit.discountAmount} EGP",
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          if (cubit.offerMessage.isNotEmpty)
            Text(cubit.offerMessage,
                style: const TextStyle(color: Colors.blue, fontSize: 12)),
          const Divider(height: 20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Final Amount",
                      style: TextStyle(color: Colors.grey)),
                  Text("${cubit.finalPrice} EGP",
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showConfirmOrderDialog(context, cubit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Checkout",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmOrderDialog(BuildContext context, AppCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Order"),
        content: Text(
            "Order will be shipped for ${cubit.finalPrice} EGP. Are you sure?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Edit")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.placeOrder(
                address: cubit.userProfile!['address'],
                phone: cubit.userProfile!['phone'],
              );
              // cubit.emptyCart();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
  // 3. شريط الدفع السفلي
  // Widget _buildCheckoutBar(AppCubit cubit) {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
  //     ),
  //     child: Row(
  //       children: [
  //         Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text("الإجمالي", style: TextStyle(color: Colors.grey)),
  //             Text("${cubit.totalPrice} ج.م", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
  //           ],
  //         ),
  //         const SizedBox(width: 30),
  //         Expanded(
  //           child: ElevatedButton(
  //             onPressed: () { /* اكمل الطلب */ },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.blue[700],
  //               padding: const EdgeInsets.symmetric(vertical: 15),
  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //             ),
  //             child: const Text("إتمام الشراء", style: TextStyle(color: Colors.white, fontSize: 18)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
