import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart/cart_cubit.dart';
import '../bloc/cart/cart_state.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        int itemCount =
            state.cartItems.where((item) => item.id == product.id).length;

        return Container(
          //margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.shopping_bag, color: Colors.grey[600]),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: Theme.of(context).textTheme.bodyMedium),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          TextSpan(
                            text: ' / unit',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (itemCount == 0)
                FilledButton(
                  onPressed: () => context.read<CartCubit>().addToCart(product),
                  child: Text('Add to cart'),
                )
              else
                Row(
                  children: [
                    IconButton(
                      iconSize: 32,
                      icon: Icon(Icons.remove_circle, color: Colors.deepPurple),
                      onPressed: () =>
                          context.read<CartCubit>().removeFromCart(product),
                    ),
                    Text('$itemCount',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    IconButton(
                      iconSize: 32,
                      icon: Icon(Icons.add_circle, color: Colors.deepPurple),
                      onPressed: () =>
                          context.read<CartCubit>().addToCart(product),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
