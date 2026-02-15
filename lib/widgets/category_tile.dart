import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;
  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: category.image.isNotEmpty
              ? Image.network(category.image, width: 72, height: 72, fit: BoxFit.cover)
              : Container(width: 72, height: 72, color: Colors.grey[200]),
        ),
        const SizedBox(height: 6),
        SizedBox(width: 72, child: Text(category.name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
