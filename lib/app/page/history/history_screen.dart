import 'package:flutter/material.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/bill.dart';
import 'package:app_api/app/page/history/history_detail.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<BillModel>> _getBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getHistory(prefs.getString('token').toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FutureBuilder<List<BillModel>>(
        future: _getBills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching purchase history', style: TextStyle(color: Colors.red)),
            );
          }

          final bills = snapshot.data ?? [];
          return bills.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    final itemBill = bills[index];
                    return _billWidget(itemBill, context);
                  },
                );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No purchase history yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Your green journey starts here!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _billWidget(BillModel bill, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var temp = await APIRepository().getHistoryDetail(
            bill.id,
            prefs.getString('token').toString(),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryDetail(bill: temp),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.local_florist, color: Colors.green[700]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${bill.fullName}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          bill.id,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${NumberFormat('#,##0').format(bill.total)} VND',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date:',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                  Text(
                    bill.dateCreated,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    var temp = await APIRepository().getHistoryDetail(
                      bill.id,
                      prefs.getString('token').toString(),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryDetail(bill: temp),
                      ),
                    );
                  },
                  child: Text('View Details', style: TextStyle(color: Colors.green[700])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}