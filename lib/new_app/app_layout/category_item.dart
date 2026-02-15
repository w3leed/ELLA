import 'package:flutter/material.dart';

/// A beautiful category item widget for mobile screens
/// Displays photo and name with click functionality

class CategoryItem extends StatelessWidget {
  final String name;
  final String ?photoUrl;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const CategoryItem({
    super.key,
    required this.name,
     this.photoUrl,
    this.onTap,
    this.backgroundColor,
    this.width = 120,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          height: 150,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Photo
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                  child:photoUrl ==null ?Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ):Image.network(
                    photoUrl!,
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
              ),

              // Name
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 8.0,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16.0),
                  ),
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 1.0,
//             ),
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               final category = categories[index];
//               return CategoryItem(
//                 name: category['name']!,
//                 photoUrl: category['photoUrl']!,
//                 onTap: () {
//                   print('Category ${category['name']} tapped!');
//                 },
//               );
//             },
//           ),
//         ),
// Sample data
final List<Map<String, String>> categories = [
  {
    'name': 'Electronics',
    'photoUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
  },
  {
    'name': 'Fashion',
    'photoUrl': 'https://images.unsplash.com/photo-1483985988355-763728e1935b',
  },
  {
    'name': 'Home & Kitchen',
    'photoUrl': 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15',
  },
  {
    'name': 'Sports',
    'photoUrl': 'https://images.unsplash.com/photo-1517649763962-0c623066013b',
  },
  {
    'name': 'Beauty',
    'photoUrl': 'https://images.unsplash.com/photo-1599351431202-1e0f0137899a',
  },
  {
    'name': 'Books',
    'photoUrl': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
  },
];
