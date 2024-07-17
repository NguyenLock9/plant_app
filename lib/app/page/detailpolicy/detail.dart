import 'dart:convert';
import 'package:app_api/app/page/detailpolicy/agreement.dart';
import 'package:app_api/app/page/detailpolicy/delivery.dart';
import 'package:app_api/app/page/detailpolicy/privacy.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user.dart';
import 'package:app_api/app/page/widgets/profile_widget.dart';


class Detail extends StatefulWidget {
  const Detail({Key? key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  User user = User.userEmpty();

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: ExactAssetImage('assets/images/profile.jpg'),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width * .6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        '${user.fullName}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      height: 24,
                      child: Image.asset("assets/images/verified.png"),
                    )
                  ],
                ),
              ),
              Text(
                ' nguyenloc@gmail.com ',
                style: TextStyle(
                  color: Colors.black.withOpacity(.3),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: size.height * .5,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfileItem(Icons.policy, 'Delivery and return policy', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryDetailPage(title: 'Delivery and Return Policy')));
                    }),
                    _buildProfileItem(Icons.settings, 'User Agreement', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AgreementDetailPage(title: 'User Agreement')));
                    }),
                    _buildProfileItem(Icons.notifications, 'Privacy Policy', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyDetailPage(title: 'Privacy Policy')));
                    }),
                    _buildProfileItem(Icons.logout, 'Log Out', () {
                      // Add logout logic here
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ProfileWidget(
        icon: icon,
        title: title,
      ),
    );
  }
}
