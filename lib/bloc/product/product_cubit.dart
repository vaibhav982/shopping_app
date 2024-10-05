import 'package:bloc/bloc.dart';

import '../../data/repositories/product_repository.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit(this.repository) : super(ProductInitial());

  void fetchProducts({bool loadMore = false}) async {
    if (state is ProductLoaded && (state as ProductLoaded).isLoading) return;

    try {
      if (state is ProductInitial || !loadMore) {
        emit(ProductLoaded(
            products: [],
            recommendedProducts: [],
            isLoading: true,
            hasReachedMax: false));
        final recommendedProducts = await repository.fetchRecommendedProducts();
        final productsData = await repository.fetchProducts();
        emit(ProductLoaded(
          products: productsData.products,
          recommendedProducts: recommendedProducts,
          isLoading: false,
          nextCursor: productsData.nextCursor,
          hasReachedMax: false,
        ));
      } else if (state is ProductLoaded) {
        final currentState = state as ProductLoaded;
        emit(currentState.copyWith(isLoading: true));
        final productsData =
            await repository.fetchProducts(cursor: currentState.nextCursor);
        emit(ProductLoaded(
          products: currentState.products + productsData.products,
          recommendedProducts: currentState.recommendedProducts,
          isLoading: false,
          nextCursor: productsData.nextCursor,
          hasReachedMax: productsData.products.isEmpty,
        ));
      }
    } catch (e) {
      emit(ProductError('Failed to load products'));
    }
  }
}
