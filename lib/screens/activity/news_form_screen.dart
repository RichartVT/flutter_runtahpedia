import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../providers/news_provider.dart';
import '../../models/news.dart';
import 'package:image_picker/image_picker.dart';

class NewsFormScreen extends StatefulWidget {
  const NewsFormScreen({super.key});

  @override
  State<NewsFormScreen> createState() => _NewsFormScreenState();
}

class _NewsFormScreenState extends State<NewsFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Campos del formulario
  String title = '';
  String category = '';
  String author = '';
  String content = '';
  File? _selectedImage;

  // 📸 Método para seleccionar imagen desde la galería
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Noticia'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🖼️ Imagen de portada
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
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
                                'Seleccionar portada',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // 📝 Campos del formulario
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => title = v ?? '',
                validator: (v) => v!.isEmpty ? 'Ingresa el título' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => category = v ?? '',
                validator: (v) => v!.isEmpty ? 'Ingresa la categoría' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Autor',
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => author = v ?? '',
                validator: (v) => v!.isEmpty ? 'Ingresa el autor' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                onSaved: (v) => content = v ?? '',
                validator: (v) => v!.isEmpty ? 'Ingresa el contenido' : null,
              ),
              const SizedBox(height: 30),

              // 🔘 Botón para guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    'Publicar Noticia',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();

                    final news = News(
                      id: 'N-${Random().nextInt(999999)}',
                      title: title,
                      category: category,
                      author: author,
                      imageUrl: _selectedImage?.path ?? '',
                      content: content,
                      date: DateTime.now(),
                    );

                    await context.read<NewsProvider>().addNews(news);

                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
