import '../../models/product.dart';

abstract class ProductState {
  final List<Product> recommendedProducts;
  final List<Product> products;
  final bool isLoading;
  final String? nextCursor;
  final bool hasReachedMax;
  final String? recommendedProductsError;
  final String? mainProductsError;

  ProductState({
    this.recommendedProducts = const [],
    this.products = const [],
    this.isLoading = false,
    this.nextCursor,
    this.hasReachedMax = false,
    this.recommendedProductsError,
    this.mainProductsError,
  });
}

class ProductInitial extends ProductState {}

class ProductLoaded extends ProductState {
  ProductLoaded({
    required List<Product> products,
    required List<Product> recommendedProducts,
    required bool isLoading,
    String? nextCursor,
    required bool hasReachedMax,
    String? recommendedProductsError,
    String? mainProductsError,
  }) : super(
          products: products,
          recommendedProducts: recommendedProducts,
          isLoading: isLoading,
          nextCursor: nextCursor,
          hasReachedMax: hasReachedMax,
          recommendedProductsError: recommendedProductsError,
          mainProductsError: mainProductsError,
        );

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? recommendedProducts,
    bool? isLoading,
    String? nextCursor,
    bool? hasReachedMax,
    String? recommendedProductsError,
    String? mainProductsError,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      isLoading: isLoading ?? this.isLoading,
      nextCursor: nextCursor ?? this.nextCursor,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      recommendedProductsError:
          recommendedProductsError ?? this.recommendedProductsError,
      mainProductsError: mainProductsError ?? this.mainProductsError,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message) : super();
}
