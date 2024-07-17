import 'dart:io';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'product_add.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductBuilder extends StatefulWidget {
  const ProductBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductBuilder> createState() => _ProductBuilderState();
}

class _ProductBuilderState extends State<ProductBuilder> {
  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProduct(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No products available"));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final itemProduct = snapshot.data![index];
              return _buildProduct(itemProduct, context);
            },
          ),
        );
      },
    );
  }
Widget _buildProduct(ProductModel pro, BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 8,
    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      image: pro.imageUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(pro.imageUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: pro.imageUrl.isEmpty
                        ? const Center(
                            child: Icon(Icons.local_florist, size: 50, color: Colors.green),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pro.name,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.green.shade700),
                          Text(
                            NumberFormat('#,##0').format(pro.price),
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        pro.description,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: () async {
    // Hiển thị hộp thoại xác nhận
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa sản phẩm "${pro.name}"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    // Nếu người dùng xác nhận xóa
    if (confirmDelete == true) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      bool success = await APIRepository().removeProduct(
        pro.id,
        pref.getString('accountID').toString(),
        pref.getString('token').toString()
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xóa sản phẩm "${pro.name}" thành công'))
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể xóa sản phẩm. Vui lòng thử lại.'))
        );
      }
    }
  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text('Xóa',style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => ProductAdd(
                              isUpdate: true,
                              productModel: pro,
                            ),
                            fullscreenDialog: true,
                          ),
                        )
                        .then((_) => setState(() {}));
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('Sửa',style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

}
