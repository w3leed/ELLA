


//    // The Category passed from the previous screen
// {
//   "categoryId": "101",
//   "name": "Electronics"
// }

// // Subcategories (Fetched based on categoryId: 101)
// [
//   { "id": "sub_1", "name": "Laptops" },
//   { "id": "sub_2", "name": "Headphones" },
//   { "id": "sub_3", "name": "Cameras" }
// ]

// // Products (Fetched based on categoryId: 101)
// [
//   { "id": "p1", "name": "MacBook Pro", "subCategoryId": "sub_1" },
//   { "id": "p2", "name": "Sony XM5", "subCategoryId": "sub_2" },
//   { "id": "p3", "name": "Dell XPS", "subCategoryId": "sub_1" }
// ]


import 'package:flutter/material.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryDetailsScreen({super.key, required this.categoryName});

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  // Dummy Data for demonstration
  final List<String> subCategories = ["All", "Laptops", "Phones", "Audio", "Accessories"];
  
  final List<Map<String, dynamic>> allProducts = [
    {"name": "MacBook Pro", "sub": "Laptops", "price": "\$1200"},
    {"name": "iPhone 14", "sub": "Phones", "price": "\$999"},
    {"name": "AirPods", "sub": "Audio", "price": "\$199"},
    {"name": "Dell XPS", "sub": "Laptops", "price": "\$1100"},
    {"name": "Charger", "sub": "Accessories", "price": "\$20"},
  ];

  // State variable to track active filter
  String selectedSubCat = "All";

  @override
  Widget build(BuildContext context) {
    // Logic to filter products based on selection
    List<Map<String, dynamic>> displayedProducts;
    if (selectedSubCat == "All") {
      displayedProducts = allProducts;
    } else {
      displayedProducts = allProducts.where((p) => p['sub'] == selectedSubCat).toList();
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Column(
        children: [
          // SECTION 1: Subcategories (Horizontal List)
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final subCat = subCategories[index];
                final isSelected = subCat == selectedSubCat;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(subCat),
                    selected: isSelected,
                    selectedColor: Colors.blueAccent,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedSubCat = subCat;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // SECTION 2: Products (Grid View)
          Expanded(
            child: displayedProducts.isEmpty 
            ? Center(child: Text("No products found"))
            : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(displayedProducts[index]['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(displayedProducts[index]['price'], style: TextStyle(color: Colors.green)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}