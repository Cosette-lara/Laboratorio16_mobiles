import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para acceder al portapapeles
import '../models/product_model.dart';
import '../services/api_service.dart';

class FormScreen extends StatefulWidget {
  final Product? product;
  const FormScreen({Key? key, this.product}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  late TextEditingController _imageController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _descController = TextEditingController(
      text: widget.product?.description ?? '',
    );

    _imageController = TextEditingController(text: widget.product?.image ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final newProduct = Product(
        id: widget.product?.id,
        title: _titleController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        description: _descController.text,
        image: _imageController.text.isEmpty
            ? "https://ui-avatars.com/api/?name=No+Image" // Fallback seguro para el backend
            : _imageController.text,
        category: widget.product?.category ?? 'general',
      );

      try {
        if (widget.product == null) {
          await _apiService.createProduct(newProduct);
        } else {
          await _apiService.updateProduct(widget.product!.id!, newProduct);
        }
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: $e")));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _pasteFromClipboard() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      setState(() {
        _imageController.text = data.text!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.product == null ? "Nuevo Producto" : "Editar Producto",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- VISTA PREVIA INTELIGENTE ---
              Center(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _imageController.text.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Pega una URL abajo",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            _imageController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image_outlined,
                                    size: 40,
                                    color: Colors.red[300],
                                  ),
                                  Text(
                                    "URL no válida",
                                    style: TextStyle(color: Colors.red[300]),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ),
              SizedBox(height: 30),

              TextFormField(
                controller: _imageController,
                onChanged: (_) =>
                    setState(() {}), // Actualiza la vista previa al escribir
                decoration: InputDecoration(
                  labelText: "URL de la Imagen",
                  prefixIcon: Icon(Icons.link),
                  // Botón "Pegar" dentro del input para facilitar la vida al usuario
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.paste,
                      color: Theme.of(context).primaryColor,
                    ),
                    tooltip: "Pegar portapapeles",
                    onPressed: _pasteFromClipboard,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una URL de imagen';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // OTROS CAMPOS
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Nombre del Producto",
                  prefixIcon: Icon(Icons.tag),
                ),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: "Precio",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: "Descripción",
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),

              SizedBox(height: 40),

              // BOTÓN GUARDAR
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF97316), // Naranja
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "GUARDAR PRODUCTO",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
