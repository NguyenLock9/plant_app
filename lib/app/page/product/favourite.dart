import 'package:flutter/material.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/favourite.dart';
import 'package:intl/intl.dart';

class FavouritePage extends StatelessWidget {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.eco, color: Colors.white),
            SizedBox(width: 10),
            Text('Favorite Plants', style: TextStyle(fontFamily: 'Naturalist')),
          ],
        ),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Favourite>>(
        future: databaseHelper.favourites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favourite plants yet'));
          } else {
            final favorites = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          favorite.img,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              favorite.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.eco, size: 16, color: Colors.green),
                                SizedBox(width: 5),
                                Text(
                                  '${NumberFormat('#,###').format(favorite.price)} VND',
                                  style: TextStyle(color: Colors.green[700]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            databaseHelper.deleteFavourite(favorite.productID);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Removed from favourites')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}