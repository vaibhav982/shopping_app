import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/bloc/cart/cart_cubit.dart';
import 'package:shopping_app/bloc/checkout/checkout_cubit.dart';
import 'package:shopping_app/bloc/product/product_cubit.dart';

import 'data/repositories/product_repository.dart';
import 'pages/product_list_page.dart';

const String baseUrl = 'http://192.168.1.36:8080';

void main() {
  final productRepository = ProductRepository();
  runApp(MyApp(productRepository: productRepository));
}

// Unit test cases:
// 1. Verify that adding a product to the cart results in the correct cart state update.
// 2. Ensure that removing a product from the cart decreases the total count accurately.
// 3. Test that the discount calculation correctly applies to eligible items.
// 4. Check that the cart is empty when the clear function is called.
// 5. Verify that the subtotal, discount, and total amounts are calculated correctly in the cart summary.
// 6. Test the success scenario of checking out items from the cart.
// 7. Ensure that checkout fails when there are no items in the cart.
// 8. Validate that increasing product quantity updates the cart item count correctly.
// 9. Verify that decreasing product quantity removes the product if the quantity reaches zero.
// 10. Confirm that a successful checkout clears the cart and triggers the appropriate success state.

class MyApp extends StatelessWidget {
  final ProductRepository productRepository;

  MyApp({required this.productRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(productRepository)..fetchProducts(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
        BlocProvider<CheckoutCubit>(
          create: (context) => CheckoutCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Shopping App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: ProductListPage(),
      ),
    );
  }
}
