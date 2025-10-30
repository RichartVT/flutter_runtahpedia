import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../database/product_database.dart';
import '../../providers/shop_provider.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String category = '';
  double price = 0;
  String unit = '1kg';
  String description = '';
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = picked.name;
    final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');

    setState(() {
      _selectedImage = savedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Add New Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 📷 Image Picker Preview
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 36,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Select Image',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (v) => name = v ?? '',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                onSaved: (v) => category = v ?? '',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (v) => price = double.tryParse(v ?? '0') ?? 0,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (v) => description = v ?? '',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Add'),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState!.save();

            final product = Product(
              id: 'P-${Random().nextInt(999999)}',
              name: name,
              category: category,
              price: price,
              unit: unit,
              description: description,
              imageUrl: _selectedImage?.path ?? '',
            );

            await ProductDatabase.instance.insertProduct(product);
            context.read<ShopProvider>().add(product);

            if (!mounted) return;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
