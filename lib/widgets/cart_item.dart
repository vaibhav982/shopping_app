import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/bloc/cart/cart_cubit.dart';

import '../models/product.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(product.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<CartCubit>().removeAllFromCart(product);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.shopping_bag, color: Colors.grey[600]),
        ),
        title:
            Text(product.name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              TextSpan(
                text: ' / unit',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        trailing: Container(
          width: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                iconSize: 32,
                icon: Icon(Icons.remove_circle, color: Colors.deepPurple),
                onPressed: () =>
                    context.read<CartCubit>().removeFromCart(product),
              ),
              Text(
                '$quantity',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                iconSize: 32,
                icon: Icon(Icons.add_circle, color: Colors.deepPurple),
                onPressed: () => context.read<CartCubit>().addToCart(product),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
