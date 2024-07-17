import 'package:flutter/material.dart';

class AgreementDetailPage extends StatelessWidget {
  final String title;

  const AgreementDetailPage({required this.title});

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
            _buildSectionHeader("1. Purpose and scope of collection"),
            _buildPurposeAndScope(),
            _buildSectionHeader("2. Scope of information use"),
            _buildInformationUse(),
            _buildSectionHeader("3. Information storage time"),
            _buildStorageTime(),
            _buildSectionHeader("4. Committed to protecting customer personal information"),
            _buildProtectionCommitment(),
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

  Widget _buildPurposeAndScope() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "The main data collection on cayxinh.vn includes: email, phone, customer address. This is the information that cayxinh.vn needs members to provide when registering to use the service and for cayxinh.vn to contact for confirmation when customers register to use the service on the website to ensure the rights of users. consumption."
        ),
        _buildPolicyItem(
          "Members will be responsible for the security and storage of all service usage activities under their registered name, password and email. In addition, members are responsible for promptly notifying cayxinh.vn of unauthorized use, abuse, security violations, and retention of registration names and passwords by third parties to take measures. appropriate decision."
        ),
      ],
    );
  }

  Widget _buildInformationUse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "Cayxinh.vn uses the information provided by members to:"
        ),
        _buildPolicyItem(
          "- Providing services to members;"
        ),
        _buildPolicyItem(
          "- Send notifications about information exchange activities between members and cayxinh.vn;"
        ),
        _buildPolicyItem(
          "- Prevent activities that destroy members' user accounts or activities that impersonate members;"
        ),
        _buildPolicyItem(
          "- Contact and resolve with members in special cases."
        ),
        _buildPolicyItem(
          "Do not use members' personal information other than for confirmation and contact related to transactions at cayxinh.vn."
        ),
        _buildPolicyItem(
          "In case of legal requirements: cayxinh.vn is responsible for cooperating in providing members' personal information upon request from judicial agencies including: Procuracy, courts, police agencies. Investigation related to certain legal violations by customers. In addition, no one has the right to violate members' personal information."
        ),
      ],
    );
  }

  Widget _buildStorageTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "The Member's personal data will be stored until cancellation is requested. In all cases, member personal information will be kept confidential on cayxinh.vn's server."
        ),
        _buildPolicyItem(
          "Address of the unit that collects and manages personal information:"
        ),
        _buildPolicyItem(
          "Vu Anh Investment Joint Stock Company"
        ),
        _buildPolicyItem(
          "Address: 310/10 Duong Quang Ham, Ward 5, Go Vap District, Ho Chi Minh City, Vietnam"
        ),
        _buildPolicyItem(
          "Email: cayxinh.vn@gmail.com"
        ),
        _buildPolicyItem(
          "Means and tools for users to access and edit their personal data."
        ),
        _buildPolicyItem(
          "Members have the right to check, update, adjust or cancel their personal information by asking cayxinh.vn to do this."
        ),
        _buildPolicyItem(
          "Members have the right to submit complaints about the disclosure of personal information to third parties to the Management Board of cayxinh.vn. When receiving these feedback, cayxinh.vn will confirm the information, be responsible for answering the reason and instruct members to restore and re-secure the information."
        ),
        _buildPolicyItem(
          "Email: cayxinh.vn@gmail.com"
        ),
      ],
    );
  }

  Widget _buildProtectionCommitment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "Personal information of members on cayxinh.vn is committed to absolute confidentiality by cayxinh.vn according to our personal information protection policy. The collection and use of each member's information is only carried out with that customer's consent, unless otherwise prescribed by law."
        ),
        _buildPolicyItem(
          "Do not use, transfer, provide or disclose to any third party the member's personal information without the member's consent."
        ),
        _buildPolicyItem(
          "In the event that the information server is attacked by hackers leading to loss of member personal data, cayxinh.vn will be responsible for reporting the incident to the investigating authorities for timely handling and notification to the authorities. known members."
        ),
      ],
    );
  }

  Widget _buildPolicyItem(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        content,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
