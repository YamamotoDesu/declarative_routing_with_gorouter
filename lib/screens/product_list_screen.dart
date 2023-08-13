// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product_model.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({
    Key? key,
    required this.category,
    required this.asc,
    required this.quantity,
  }) : super(key: key);

  final String category;
  final bool asc;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    List<Product> products = Product.products
        .where((product) => product.category == category)
        .where((product) => product.quantity >= quantity)
        .toList();

    products.sort((a, b) => asc
        ? a.quantity.compareTo(b.quantity)
        : b.quantity.compareTo(a.quantity));
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          category,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF000A1F),
        actions: [
          IconButton(
            onPressed: () {
              String sort = asc ? 'desc' : 'asc';
              return context.goNamed(
                'product_list',
                pathParameters: <String, String>{
                  'category': category,
                },
                queryParameters: <String, String>{
                  'sort': sort,
                },
              );
            },
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () {
              String sort = asc ? 'desc' : 'asc';
              return context.goNamed(
                'product_list',
                pathParameters: <String, String>{
                  'category': category,
                },
                queryParameters: <String, String>{
                  'sort': sort,
                  'filter': '10',
                },
              );
            },
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          for (final Product product in products)
            ListTile(
              title: Text(product.name),
              subtitle: Text(product.category),
              trailing: Text(product.quantity.toString()),
            ),
        ],
      ),
    );
  }
}
