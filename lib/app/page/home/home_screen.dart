import 'dart:async';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/category.dart';
import 'package:app_api/app/model/product.dart';
import 'package:flutter/material.dart';
import '../../data/sqlite.dart';
import '../product/product_detail.dart';
import 'package:app_api/app/data/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeBuilder(),
    );
  }
}

class HomeBuilder extends StatefulWidget {
  const HomeBuilder({Key? key}) : super(key: key);
  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  late Future<List<ProductModel>> _productsFuture;
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  List<ProductModel> _filteredProducts = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _productsFuture = _getProducts();
    _fetchCategories();
    _fetchProducts();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

   void _startAutoScroll() {
  _timer = Timer.periodic(Duration(seconds: 3), (timer) {
    if (_pageController.hasClients) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    }
  });
}
  Future<void> _fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _categories = await APIRepository().getCategory(prefs.getString('accountID').toString(), prefs.getString('token').toString());
    setState(() {});
  }

  Future<void> _fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _products = await APIRepository().getProduct(prefs.getString('accountID').toString(), prefs.getString('token').toString());
    _filteredProducts = _products;
    setState(() {});
  }

  void _filterProducts() {
    if (_selectedCategory != null) {
      _filteredProducts = _products.where((product) => product.categoryId == _selectedCategory!.id).toList();
    } else {
      _filteredProducts = _products;
    }
    setState(() {});
  }

  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ProductModel> products = await APIRepository().getProduct(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      products = products.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    setState(() {
      _products = products;
    });

    return products;
  }

  Future<void> _addToCart(ProductModel product) async {
    _databaseService.insertProduct(Cart(
      productID: product.id,
      name: product.name,
      des: product.description,
      price: product.price,
      img: product.imageUrl,
      count: 1,
    ));
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error fetching products', style: TextStyle(color: Colors.red[700])));
        }

        return CustomScrollView(
          slivers: [
          
            SliverToBoxAdapter(
              child: _buildSearchAndFilter(),
            ),
            SliverToBoxAdapter(
              child: _buildFeaturedProducts(_products.take(5).toList()),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'All Plants',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800]),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: _buildProductGrid(_filteredProducts),
            ),
          ],
        );
      },
    );
  }



  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search plants...',
                prefixIcon: Icon(Icons.search, color: Colors.green[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.green[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.green[700]!, width: 2.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _getProducts();
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.green[700]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CategoryModel>(
                  hint: Text('Category'),
                  value: _selectedCategory,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.green[700]),
                  onChanged: (CategoryModel? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                      _filterProducts();
                    });
                  },
                  items: _categories.map((CategoryModel category) {
                    return DropdownMenuItem<CategoryModel>(
                      value: category,
                      child: Text(category.name, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProducts(List<ProductModel> featuredProducts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Featured Plants',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800]),
          ),
        ),
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetail(product: product)),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                            ),
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${NumberFormat('#,###').format(product.price)} VND',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[300]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetail(product: product)),
                      );
                    },
                    child: Hero(
                      tag: 'product_image_${product.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${NumberFormat('#,###').format(product.price)} VND',
                        style: TextStyle(fontSize: 14, color: Colors.green[600], fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite_border, color: Colors.red),
                            onPressed: () {
                              // Implement favorite functionality
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add_shopping_cart, color: Colors.green[700]),
                            onPressed: () {
                              _addToCart(product);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: products.length,
      ),
    );
  }
}