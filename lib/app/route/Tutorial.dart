import 'package:flutter/material.dart';
import 'detailtutorial.dart';

class PlantCareGuide extends StatelessWidget {
  const PlantCareGuide({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Indoor Plants', 'imageUrl': 'https://cayxinh.vn/wp-content/uploads/2018/02/cach-cham-soc-sen-da-180221-02.jpg', 'type': 'indoor'},
      {'name': 'Balcony Plants', 'imageUrl': 'https://cayxinh.vn/wp-content/uploads/2017/11/cay-phat-loc-thuy-sinh-1-than.jpg', 'type': 'balcony'},
      {'name': 'Aquatic Bonsai', 'imageUrl': 'https://cayxinh.vn/wp-content/uploads/2018/04/cham-soc-cay-canh-mini.jpg', 'type': 'aquatic'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care Guide'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15.0),
                  leading: Image.network(
                    category['imageUrl']!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    category['name']!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800]),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PlantCareDetail(categoryType: category['type']!),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
