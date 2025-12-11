import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3, 
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    child: Hero(
                      tag: 'prod-${product.id}',
                      child: Image.network(product.image, fit: BoxFit.contain),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
                    color: Colors.grey[50], 
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500],
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Color(0xFF1E293B),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "\$${product.price}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 5,
              right: 5,
              child: Material(
                color: Colors.transparent,
                child: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text("Editar"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text("Eliminar"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
