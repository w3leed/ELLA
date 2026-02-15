
abstract class AppState   {}
class AppInitial extends AppState {}


class GetOfferLoading extends AppState{}
class GetOfferSuccess extends AppState{}
class GetOfferError extends AppState{
  final String error ;

  GetOfferError ({required this.error});
}


class GetCategoryLoading extends AppState{}
class GetCategorySuccess extends AppState{}
class GetCategoryError extends AppState{
  final String error;

  GetCategoryError({required this.error});

}

class GetSubCategoryLoading extends AppState{}
class GetSubCategorySuccess extends AppState{}
class GetSubCategoryError extends AppState{
  final String error;

  GetSubCategoryError({required this.error});

}

class GetProductLoading extends AppState{}
class GetProductSuccess extends AppState{}
class GetProductError extends AppState{
  final String error;

  GetProductError({required this.error});

}
class AddToCartLoadingState extends AppState {}
class AddToCartSuccessState extends AppState {}
class AddToCartErrorState extends AppState {
  final String error;
  AddToCartErrorState(this.error);
}
class GetCartLoadingState extends AppState {}
class GetCartSuccessState extends AppState {}
class CartEmptyState extends AppState {} // حالة السلة فارغة
class LoginLoadingState extends AppState {}
class LoginSuccessState extends AppState {}
class LoginpasswoedErrorState extends AppState {}
class LoginphoneErrorState extends AppState {}
class LoginErrorState extends AppState {
  final String error;
  LoginErrorState(this.error);
}
class RegisterLoadingState extends AppState {}
class RegisterSuccessState extends AppState {}
class RegisterErrorState extends AppState {
  final String error;
  RegisterErrorState(this.error);
}
class UpdateStatusSuccessState extends AppState {}
class GetOrdersErrorState extends AppState {
  final String error;
  GetOrdersErrorState(this.error);
}
class GetOrdersLoadingState extends AppState {}
class GetOrdersSuccessState extends AppState {} 
class UpdateStatusLoadingState extends AppState {} 

class UnauthenticatedState extends AppState {}
class ProfileLoadingState extends AppState {}
class ProfileSuccessState extends AppState {}
class ProfileErrorState extends AppState {
  final String error;
  ProfileErrorState(this.error);
}
class ProfileUpdateLoadingState extends AppState {}
class ProfileUpdateSuccessState extends AppState {}
 
 class GetProductsErrorStateo extends AppState {
  final String error;
  GetProductsErrorStateo(this.error);
}
class GetProductsLoadingStateo extends AppState {}
class GetProductsSuccessStateo extends AppState {}
class CartEmpty extends AppState {}
class PlaceOrderLoadingState extends AppState {}
class PlaceOrderSuccessState extends AppState {}
class PlaceOrderErrorState extends AppState {}
class Logout extends AppState {}