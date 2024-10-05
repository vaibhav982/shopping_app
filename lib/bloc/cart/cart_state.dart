import '../../models/product.dart';

class CartState {
  final List<Product> cartItems;

  CartState({this.cartItems = const []});

  double get subtotal {
    return cartItems.fold(0, (total, product) => total + product.price);
  }

  double get promotionDiscount {
    double discount = 0.0;
    Map<int, List<Product>> productGroups = {};

    // Group products by ID
    for (var product in cartItems) {
      if (!productGroups.containsKey(product.id)) {
        productGroups[product.id!] = [];
      }
      productGroups[product.id!]!.add(product);
    }

    // Calculate discount for pairs
    for (var products in productGroups.values) {
      int pairs = products.length ~/ 2;
      for (int i = 0; i < pairs; i++) {
        int price1 = products[i * 2].price;
        int price2 = products[i * 2 + 1].price;
        int pairTotal = price1 + price2;
        discount += pairTotal * 0.05; // 5% discount for each pair
      }
    }

    return discount;
  }

  double get total {
    return subtotal - promotionDiscount;
  }
}
