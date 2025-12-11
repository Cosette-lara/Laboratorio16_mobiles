import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:3000/products";

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Fallo al cargar datos");
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Fallo al crear");
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Fallo al actualizar");
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Fallo al eliminar");
    }
  }
}
