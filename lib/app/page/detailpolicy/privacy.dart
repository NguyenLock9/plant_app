import 'package:flutter/material.dart';

class PolicyDetailPage extends StatelessWidget {
  final String title;

  const PolicyDetailPage({required this.title});

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
            _buildSectionHeader("1. Collection of personal information"),
            _buildCollectionInfo(),
            _buildSectionHeader("2. Use of personal information"),
            _buildUseInfo(),
            _buildSectionHeader("3. Sharing personal information"),
            _buildSharingInfo(),
            _buildSectionHeader("4. Confidentiality of personal information"),
            _buildConfidentialityInfo(),
            _buildSectionHeader("5. Use of “Cookies”"),
            _buildCookiesInfo(),
            _buildSectionHeader("6. Regulations on “Spam”"),
            _buildSpamInfo(),
            _buildSectionHeader("7. Policy changes"),
            _buildPolicyChanges(),
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

  Widget _buildCollectionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "To access and use some services at cayxinh.vn, you may be asked to register with us personal information (Email, Full name, Contact phone number.)."
        ),
        _buildPolicyItem(
          "All declared information must ensure accuracy and legality. We may also collect information about the number of visits, including the number of pages you view, the number of links you click and other information related to the connection to the site cayxinh.vn."
        ),
        _buildPolicyItem(
          "We also collect information that the Web browser (Browser) you use every time you access cayxinh.vn, including: IP address, Browser type, language used, time and addresses used by the Browser. does not bear any responsibility related to the law of declared information."
        ),
      ],
    );
  }

  Widget _buildUseInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "Cayxinh.vn collects and uses your personal information for appropriate purposes and fully complies with the content of this 'Privacy Policy'. When necessary, we can use this information to contact you directly in the following forms: sending open letters, orders, thank you letters, technical and security information."
        ),
      ],
    );
  }

  Widget _buildSharingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "Except for the cases of Personal Information Use as stated in this policy, we commit not to disclose your personal information to the public."
        ),
        _buildPolicyItem(
          "In some cases, we may hire an independent unit to conduct market research projects and your information will then be provided to this unit to conduct the project. This third party will be bound by a confidentiality agreement under which they are only allowed to use the information provided for the purpose of completing the project."
        ),
        _buildPolicyItem(
          "We may disclose or provide your personal information in the following truly necessary cases: (a) when requested by law enforcement agencies; (b) in cases where we believe it will help us protect our legitimate rights before the law; (c) emergency and necessary situations to protect the personal safety of other cayxinh.vn members."
        ),
      ],
    );
  }

  Widget _buildConfidentialityInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "Cayxinh.vn is committed to protecting your personal information in every possible way. We will use a variety of information security technologies to protect this information from unwanted retrieval, use or disclosure."
        ),
        _buildPolicyItem(
          "Cayxinh.vn recommends that you keep information related to your access password confidential and should not share it with anyone else. If you use a computer with many people, you should log out, or exit all open Website windows."
        ),
      ],
    );
  }

  Widget _buildCookiesInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "Cayxinh.vn uses 'Cookies' to help personalize and maximize the efficiency of your online time."
        ),
        _buildPolicyItem(
          "A cookie is a text file placed on your hard disk by a website server. Cookies are not used to run programs or deliver viruses to your computer. Cookies are assigned to your computer and can only be read by a web server in the domain that issued the cookie to you."
        ),
        _buildPolicyItem(
          "One of the purposes of Cookies is to provide utilities to save you time when accessing the website or visiting the website again without having to re-register existing information."
        ),
        _buildPolicyItem(
          "You can accept or decline cookies. Most browsers automatically accept cookies, but you can change the settings to decline all cookies if you prefer. However, if you choose to decline cookies, it may hinder and negatively affect some services and features that depend on cookies on the website."
        ),
      ],
    );
  }

  Widget _buildSpamInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "Cayxinh.vn is really concerned about the problem of Spam and fake emails we send. Therefore, cayxinh.vn confirms to only send Emails to you if and only if you register or use services from our system. cayxinh.vn commits not to sell, rent or lease your email from third parties."
        ),
        _buildPolicyItem(
          "If you accidentally receive an unsolicited email from our system due to an unintended cause, please click on the link to refuse to receive this email attached, or notify directly to the website administrator of cayxinh.vn."
        ),
      ],
    );
  }

  Widget _buildPolicyChanges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicyItem(
          "The content of this 'Privacy Policy' may change to suit the needs of cayxinh.vn as well as the needs and feedback from customers, if any. When we update the content of this policy, we will revise the 'Last updated' time above."
        ),
        _buildPolicyItem(
          "The content of this 'Privacy Policy' only applies to cayxinh.vn, does not include or relate to third parties placing ads or having links at cayxinh.vn. Therefore, we recommend that you read and carefully review the 'Privacy Policy' content of each website you are visiting."
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
