import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Cart>> _getProducts() async {
    return await _databaseHelper.products();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                     Icon(Icons.local_florist, size: 48, color: Colors.green[700]),
                  ElevatedButton.icon(
                    icon: Icon(Icons.delete_sweep, color: Colors.white),
                    label: Text('Clear All', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      await _databaseHelper.clearAll();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            ),
         
            Expanded(
              child: FutureBuilder<List<Cart>>(
                future: _getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error fetching plants', style: TextStyle(color: Colors.red[700])));
                  }

                  final cartItems = snapshot.data ?? [];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final itemProduct = cartItems[index];
                        return _buildProduct(itemProduct, context);
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.shopping_cart_checkout, color: Colors.white),
                label: Text("Checkout", style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  List<Cart> temp = await _databaseHelper.products();
                  await APIRepository().addBill(temp, pref.getString('token').toString());
                  await _databaseHelper.clear();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProduct(Cart pro, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: NetworkImage(pro.img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name,
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.green[800]),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${NumberFormat('#,##0').format(pro.price)} VND',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.brown[700]),
                  ),
                  const SizedBox(height: 4.0),
                  Text('Quantity: ${pro.count}', style: TextStyle(fontSize: 16.0, color: Colors.grey[600])),
                  const SizedBox(height: 4.0),
                  Text(
                    pro.des,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _databaseHelper.add(pro);
                    });
                  },
                  icon: Icon(Icons.add_circle, color: Colors.green[700]),
                ),
                Text('${pro.count}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _databaseHelper.minus(pro);
                    });
                  },
                  icon: Icon(Icons.remove_circle, color: Colors.red[700]),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _databaseHelper.deleteProduct(pro.productID);
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}