import 'package:flutter/material.dart'; 

class SubcategoryScreen extends StatelessWidget {
  final String categoryTitle;
  final String categoryImage;
  final List<Product> products;

  const SubcategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryImage,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with category image and title
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Category Image
                  Image.network(
                    categoryImage,
                    fit: BoxFit.cover,
                  ),
                  // Dark overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Category Title
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: Text(
                      categoryTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Grid
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Product Card Widget
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ProductDetailScreen(product: product),
        //   ),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Price
                  Row(
                    children: [
                      // Original Price (if discounted)
                      if (product.discount > 0)
                        Text(
                          '₪${product.originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      
                      if (product.discount > 0)
                        const SizedBox(width: 6),
                      
                      // Current Price
                      Text(
                        '₪${product.currentPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Discount Badge
                      if (product.discount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red[600],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product.discount}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      
                      // Add to Cart Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.shopping_cart, size: 14, color: Colors.blue),
                            SizedBox(width: 4),
                            Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
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
}

/// Product Data Model
class Product {
  final String name;
  final String imageUrl;
  final double originalPrice;
  final double currentPrice;
  final double discount;
  final double rating;
  final String description;

  const Product({
    required this.name,
    required this.imageUrl,
    required this.originalPrice,
    required this.currentPrice,
    this.discount = 0.0,
    this.rating = 0.0,
    this.description = '',
  });

  // Calculate discount percentage
  double get discountPercentage => discount > 0 ? discount : 0.0;
}

// Example usage
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SubcategoryScreen(
        categoryTitle: 'Wireless Headphones',
        categoryImage: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
        products: products,
      ),
    );
  }
}

// Sample Products Data
final List<Product> products = [
  Product(
    name: 'Premium Wireless Headphones with Noise Cancelling',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
    originalPrice: 199.99,
    currentPrice: 149.99,
    discount: 25.0,
    rating: 4.8,
    description: 'High-quality wireless headphones with active noise cancelling technology.',
  ),
  Product(
    name: 'Bluetooth Earbuds Pro',
    imageUrl: 'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb',
    originalPrice: 89.99,
    currentPrice: 69.99,
    discount: 22.0,
    rating: 4.5,
    description: 'Compact Bluetooth earbuds with excellent sound quality.',
  ),
  Product(
    name: 'Gaming Headset with RGB Lighting',
    imageUrl: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12',
    originalPrice: 129.99,
    currentPrice: 129.99,
    rating: 4.7,
    description: 'Professional gaming headset with RGB lighting effects.',
  ),
  Product(
    name: 'Sports Wireless Headphones',
    imageUrl: 'https://images.unsplash.com/photo-1579227114347-15d08fc37bdd',
    originalPrice: 79.99,
    currentPrice: 59.99,
    discount: 25.0,
    rating: 4.3,
    description: 'Waterproof sports headphones perfect for workouts.',
  ),
  Product(
    name: 'Studio Monitor Headphones',
    imageUrl: 'https://images.unsplash.com/photo-1578943468174-47641c3d566b',
    originalPrice: 249.99,
    currentPrice: 199.99,
    discount: 20.0,
    rating: 4.9,
    description: 'Professional studio monitor headphones for audio production.',
  ),
  Product(
    name: 'Kids Wireless Headphones',
    imageUrl: 'https://images.unsplash.com/photo-1590658268033-d600d87f2d10',
    originalPrice: 49.99,
    currentPrice: 39.99,
    discount: 20.0,
    rating: 4.2,
    description: 'Safe and comfortable wireless headphones for kids.',
  ),
];
