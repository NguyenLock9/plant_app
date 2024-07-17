import 'package:flutter/material.dart';

class DeliveryDetailPage extends StatelessWidget {
  final String title;

  const DeliveryDetailPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("I. DELIVERY"),
            _buildDeliveryPolicy(),
            _buildSuburbPolicy(),
            _buildSectionHeader("II. REGULATIONS ON RETURN"),
            _buildReturnPolicy(),
            _buildConditions(),
            const SizedBox(height: 20),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue, // Example color
        ),
      ),
    );
  }

  Widget _buildDeliveryPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "1. Delivery policy:",
          "- Goods are carefully packaged in paper boxes or soft foam.",
        ),
        _buildPolicyItem(
          "2. For customers in the suburbs of Hanoi:",
          "- Please help us pay 100% of the order value and shipping fee via bank account.",
          "- Please notify us after successful payment.",
          "- We will proceed with delivery as soon as we receive your notice.",
          "- Delivery time will depend on the distance from us to the delivery location (No later than 48 hours from delivery. In case you have not received the goods after 48 hours, please notify the shop). via phone number 096 596 2586 or 094 822 5678)",
        ),
      ],
    );
  }

  Widget _buildSuburbPolicy() {
    return Container(
      margin: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPolicyItem(
            "- Please help us pay 100% of the order value and shipping fee via bank account.",
          ),
          _buildPolicyItem(
            "- Please notify us after successful payment.",
          ),
          _buildPolicyItem(
            "- We will proceed with delivery as soon as we receive your notice.",
          ),
          _buildPolicyItem(
            "- Delivery time will depend on the distance from us to the delivery location (No later than 48 hours from delivery. In case you have not received the goods after 48 hours, please notify the shop). via phone number 096 596 2586 or 094 822 5678)",
          ),
        ],
      ),
    );
  }

  Widget _buildReturnPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "Return and exchange policy:",
          "Except for errors caused by the manufacturer or a different sample request, in the remaining cases you cannot exchange or return the goods.",
        ),
      ],
    );
  }

  Widget _buildConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "Conditions for return and exchange:",
          "- Returns only apply to products: bonsai pots, soil, sand, Terrarium decoration accessories.",
          "- No returns or exchanges on ornamental plants that you have ordered.",
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact us:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue, // Example color
          ),
        ),
        _buildPolicyItem(
          "- Phone number: 096 596 2586 or 094 822 5678",
        ),
      ],
    );
  }

  Widget _buildPolicyItem(String title, [String? item1, String? item2, String? item3, String? item4]) {
    List<Widget> items = [];
    items.add(Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ));
    if (item1 != null) items.add(Text(item1));
    if (item2 != null) items.add(Text(item2));
    if (item3 != null) items.add(Text(item3));
    if (item4 != null) items.add(Text(item4));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }
}
