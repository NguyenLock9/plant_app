import 'dart:convert';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/favourite.dart';
import 'package:app_api/app/model/user.dart';
import 'package:app_api/app/page/cart/cart_screen.dart';
import 'package:app_api/app/page/category/category_list.dart';
import 'package:app_api/app/page/detailpolicy/detail.dart';
import 'package:app_api/app/page/history/history_screen.dart';
import 'package:app_api/app/page/home/home_screen.dart';
import 'package:app_api/app/page/product/favourite.dart';
import 'package:app_api/app/page/product/product_list.dart';
import 'package:app_api/app/route/Tutorial.dart';
import 'package:flutter/material.dart';
import 'app/page/defaultwidget.dart';
import 'app/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    getDataUser();
    _updateCartItemCount();
  }

  Future<void> _updateCartItemCount() async {
    final DatabaseHelper _databaseHelper = DatabaseHelper();
    List<Cart> cartItems = await _databaseHelper.products();
    setState(() {
      _cartItemCount = cartItems.length;
    });
  }
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() { });
  }

  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
  if (index == 2) {  // Nếu chọn tab Cart
    _updateCartItemCount();  // Cập nhật số lượng sản phẩm trong giỏ hàng
  }
}

  _loadWidget(int index) {
    var nameWidgets = "Home";
    switch (index) {
      case 0:
       {
        return const HomeBuilder();
       }
      case 1:
        {
          return const HistoryScreen();
        }
      case 2:
        {
          return const CartScreen();
        }
      case 3:
        {
          return const Detail();
        }
        
      default:
        nameWidgets = "None";
        break;
    }
    return DefaultWidget(title: nameWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Shop"),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.imageURL!.length < 5
                      ? const SizedBox()
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: ExactAssetImage('assets/images/profile.jpg')),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    user.fullName!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.green),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.green),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.green),
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.green),
              title: const Text('Category'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CategoryList()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.green),
              title: const Text('Product'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProductList()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.green),
              title: const Text('Favourite'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavouritePage()));
              },
              
            ),
             ListTile(
              leading: const Icon(Icons.book, color: Colors.green),
              title: const Text('care instructions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PlantCareGuide()));
              },
              
            ),
            const Divider(
              color: Colors.black,
            ),
            user.accountId == ''
                ? const SizedBox()
                : ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.green),
                    title: const Text('Logout'),
                    onTap: () {
                      logOut(context);
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
     items: <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'History',
    ),
    BottomNavigationBarItem(
      icon: Stack(
        children: [
          Icon(Icons.shopping_cart),
          if (_cartItemCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: Text(
                  '$_cartItemCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      label: 'Cart',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'User',
    ),
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.green[800],
  unselectedItemColor: Colors.grey,
  onTap: _onItemTapped,
),
      body: _loadWidget(_selectedIndex),
    );
  }
}
