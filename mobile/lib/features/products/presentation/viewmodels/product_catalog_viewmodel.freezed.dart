// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_catalog_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductCatalogState {

 List<CatalogProduct> get products; List<String> get categories; String get query; String get category; int get page; int get totalPages; int get total; bool get isSearching; bool get isLoadingMore;
/// Create a copy of ProductCatalogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCatalogStateCopyWith<ProductCatalogState> get copyWith => _$ProductCatalogStateCopyWithImpl<ProductCatalogState>(this as ProductCatalogState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductCatalogState&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.query, query) || other.query == query)&&(identical(other.category, category) || other.category == category)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.total, total) || other.total == total)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(categories),query,category,page,totalPages,total,isSearching,isLoadingMore);

@override
String toString() {
  return 'ProductCatalogState(products: $products, categories: $categories, query: $query, category: $category, page: $page, totalPages: $totalPages, total: $total, isSearching: $isSearching, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $ProductCatalogStateCopyWith<$Res>  {
  factory $ProductCatalogStateCopyWith(ProductCatalogState value, $Res Function(ProductCatalogState) _then) = _$ProductCatalogStateCopyWithImpl;
@useResult
$Res call({
 List<CatalogProduct> products, List<String> categories, String query, String category, int page, int totalPages, int total, bool isSearching, bool isLoadingMore
});




}
/// @nodoc
class _$ProductCatalogStateCopyWithImpl<$Res>
    implements $ProductCatalogStateCopyWith<$Res> {
  _$ProductCatalogStateCopyWithImpl(this._self, this._then);

  final ProductCatalogState _self;
  final $Res Function(ProductCatalogState) _then;

/// Create a copy of ProductCatalogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? products = null,Object? categories = null,Object? query = null,Object? category = null,Object? page = null,Object? totalPages = null,Object? total = null,Object? isSearching = null,Object? isLoadingMore = null,}) {
  return _then(_self.copyWith(
products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<CatalogProduct>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductCatalogState].
extension ProductCatalogStatePatterns on ProductCatalogState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductCatalogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductCatalogState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductCatalogState value)  $default,){
final _that = this;
switch (_that) {
case _ProductCatalogState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductCatalogState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductCatalogState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CatalogProduct> products,  List<String> categories,  String query,  String category,  int page,  int totalPages,  int total,  bool isSearching,  bool isLoadingMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductCatalogState() when $default != null:
return $default(_that.products,_that.categories,_that.query,_that.category,_that.page,_that.totalPages,_that.total,_that.isSearching,_that.isLoadingMore);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CatalogProduct> products,  List<String> categories,  String query,  String category,  int page,  int totalPages,  int total,  bool isSearching,  bool isLoadingMore)  $default,) {final _that = this;
switch (_that) {
case _ProductCatalogState():
return $default(_that.products,_that.categories,_that.query,_that.category,_that.page,_that.totalPages,_that.total,_that.isSearching,_that.isLoadingMore);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CatalogProduct> products,  List<String> categories,  String query,  String category,  int page,  int totalPages,  int total,  bool isSearching,  bool isLoadingMore)?  $default,) {final _that = this;
switch (_that) {
case _ProductCatalogState() when $default != null:
return $default(_that.products,_that.categories,_that.query,_that.category,_that.page,_that.totalPages,_that.total,_that.isSearching,_that.isLoadingMore);case _:
  return null;

}
}

}

/// @nodoc


class _ProductCatalogState extends ProductCatalogState {
  const _ProductCatalogState({final  List<CatalogProduct> products = const <CatalogProduct>[], final  List<String> categories = const <String>[], this.query = '', this.category = '', this.page = 1, this.totalPages = 1, this.total = 0, this.isSearching = false, this.isLoadingMore = false}): _products = products,_categories = categories,super._();
  

 final  List<CatalogProduct> _products;
@override@JsonKey() List<CatalogProduct> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  String category;
@override@JsonKey() final  int page;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  int total;
@override@JsonKey() final  bool isSearching;
@override@JsonKey() final  bool isLoadingMore;

/// Create a copy of ProductCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCatalogStateCopyWith<_ProductCatalogState> get copyWith => __$ProductCatalogStateCopyWithImpl<_ProductCatalogState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductCatalogState&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.query, query) || other.query == query)&&(identical(other.category, category) || other.category == category)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.total, total) || other.total == total)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_categories),query,category,page,totalPages,total,isSearching,isLoadingMore);

@override
String toString() {
  return 'ProductCatalogState(products: $products, categories: $categories, query: $query, category: $category, page: $page, totalPages: $totalPages, total: $total, isSearching: $isSearching, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class _$ProductCatalogStateCopyWith<$Res> implements $ProductCatalogStateCopyWith<$Res> {
  factory _$ProductCatalogStateCopyWith(_ProductCatalogState value, $Res Function(_ProductCatalogState) _then) = __$ProductCatalogStateCopyWithImpl;
@override @useResult
$Res call({
 List<CatalogProduct> products, List<String> categories, String query, String category, int page, int totalPages, int total, bool isSearching, bool isLoadingMore
});




}
/// @nodoc
class __$ProductCatalogStateCopyWithImpl<$Res>
    implements _$ProductCatalogStateCopyWith<$Res> {
  __$ProductCatalogStateCopyWithImpl(this._self, this._then);

  final _ProductCatalogState _self;
  final $Res Function(_ProductCatalogState) _then;

/// Create a copy of ProductCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? products = null,Object? categories = null,Object? query = null,Object? category = null,Object? page = null,Object? totalPages = null,Object? total = null,Object? isSearching = null,Object? isLoadingMore = null,}) {
  return _then(_ProductCatalogState(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<CatalogProduct>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
