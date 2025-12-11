import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    try {
      final products = await _apiService.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToForm({Product? product}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormScreen(product: product)),
    );
    if (result == true) {
      setState(() => _isLoading = true);
      _loadProducts();
    }
  }

  void _deleteItem(int id) async {
    final index = _products.indexWhere((element) => element.id == id);
    final removedProduct = _products[index];

    // Borrado visual inmediato
    setState(() => _products.removeAt(index));

    try {
      await _apiService.deleteProduct(id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Producto eliminado")));
    } catch (e) {
      setState(() => _products.insert(index, removedProduct));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al eliminar")));
    }
  }

  // En tu método build de HomeScreen:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El color de fondo ya viene del main.dart
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("Shop Pro"),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: IconButton(
              icon: Icon(Icons.search, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),

      // Botón flotante con gradiente o color sólido fuerte
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFFF97316), // Naranja Quemado
        elevation: 4,
        icon: Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          "NUEVO",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        onPressed: () => _navigateToForm(),
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFF97316)))
          : _products.isEmpty
          ? Center(
              child: Text(
                "Sin inventario",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.fromLTRB(
                20,
                10,
                20,
                80,
              ), // Más margen a los lados
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65, // Tarjetas más altas y elegantes
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ProductCard(
                  product: product,
                  onEdit: () => _navigateToForm(product: product),
                  onDelete: () => _deleteItem(product.id!),
                );
              },
            ),
    );
  }
}
