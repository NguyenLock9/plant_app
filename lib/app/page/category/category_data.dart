import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category_add.dart';

class CategoryBuilder extends StatefulWidget {
  const CategoryBuilder({Key? key}) : super(key: key);

  @override
  State<CategoryBuilder> createState() => _CategoryBuilderState();
}

class _CategoryBuilderState extends State<CategoryBuilder> {
  late List<CategoryModel> _categories;
  late List<CategoryModel> _filteredCategories;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final categories = await APIRepository().getCategory(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
    setState(() {
      _categories = categories;
      _filteredCategories = categories;
      _isLoading = false;
    });
  }

  void _filterCategories(String query) {
    setState(() {
      _filteredCategories = _categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm danh mục',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: _filterCategories,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCategories.isEmpty
                    ? const Center(child: Text('Không tìm thấy danh mục nào'))
                    : ListView.builder(
                        itemCount: _filteredCategories.length,
                        itemBuilder: (context, index) {
                          return _buildCategory(_filteredCategories[index], context);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(CategoryModel category, BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green.shade300, width: 2),
            ),
            child: Icon(
              _getCategoryIcon(category.name),
              color: Colors.green,
              size: 30,
            ),
          ),
          title: Text(
            category.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          subtitle: Text(
            category.desc,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => CategoryAdd(
                            isUpdate: true,
                            categoryModel: category,
                          ),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => _loadCategories());
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(context, category),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'cây ăn quả':
        return Icons.local_florist;
      case 'cây cảnh':
        return Icons.park;
      case 'cây thuốc':
        return Icons.medical_services;
      case 'cây công nghiệp':
        return Icons.factory;
      default:
        return Icons.category;
    }
  }

  void _showDeleteConfirmation(BuildContext context, CategoryModel category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa danh mục "${category.name}"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteCategory(category);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory(CategoryModel category) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool success = await APIRepository().removeCategory(
      category.id,
      pref.getString('accountID').toString(),
      pref.getString('token').toString()
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa danh mục "${category.name}" thành công'))
      );
      _loadCategories();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xóa danh mục. Vui lòng thử lại.'))
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}