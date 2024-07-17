import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/register.dart';
import 'package:app_api/app/page/auth/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _gender = 0;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _imageURL = TextEditingController();
  String gendername = 'None';
  String temp = '';

  Future<String> register() async {
    return await APIRepository().register(Signup(
        accountID: _accountController.text,
        birthDay: _birthDayController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        fullName: _fullNameController.text,
        phoneNumber: _phoneNumberController.text,
        schoolKey: _schoolKeyController.text,
        schoolYear: _schoolYearController.text,
        gender: getGender(),
        imageUrl: _imageURL.text,
        numberID: _numberIDController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.green[700], // Màu xanh chủ đạo
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/signup.png', // Đường dẫn tới hình ảnh
                  height: 400,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Register Info',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
                signUpWidget(),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          String response = await register();
                          if (response == "ok") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          } else {
                            print(response);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green[700], side: BorderSide(color: Colors.green[700]!),
                        ),
                        child: const Text('Register'),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getGender() {
    if (_gender == 1) {
      return "Male";
    } else if (_gender == 2) {
      return "Female";
    }
    return "Other";
  }

  // Tạo widget cho các trường nhập liệu
  Widget textField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: label.contains('word'),
        onChanged: (value) {
          setState(() {
            temp = value;
          });
        },
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.green), // Màu xanh cho chữ
            icon: Icon(icon, color: Colors.green), // Màu xanh cho icon
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorText: controller.text.trim().isEmpty ? 'Please enter' : null,
            focusedErrorBorder: controller.text.isEmpty
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(8.0),
                  )
                : null,
            errorBorder: controller.text.isEmpty
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(8.0),
                  )
                : null),
        style: const TextStyle(color: Colors.green), // Màu xanh cho text
      ),
    );
  }

  Widget signUpWidget() {
    return Column(
      children: [
        textField(_accountController, "Account", Icons.person),
        textField(_passwordController, "Password", Icons.password),
        textField(
          _confirmPasswordController,
          "Confirm password",
          Icons.password,
        ),
        textField(_fullNameController, "Full Name", Icons.text_fields_outlined),
        textField(_numberIDController, "NumberID", Icons.key),
        textField(_phoneNumberController, "PhoneNumber", Icons.phone),
        textField(_birthDayController, "BirthDay", Icons.date_range),
        textField(_schoolYearController, "SchoolYear", Icons.school),
        textField(_schoolKeyController, "SchoolKey", Icons.school),
        const Text(
          "What is your Gender?",
          style: TextStyle(color: Colors.green), // Màu xanh cho text
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Male", style: TextStyle(color: Colors.green)), // Màu xanh cho text
                leading: Transform.translate(
                    offset: const Offset(16, 0),
                    child: Radio(
                      value: 1,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                      activeColor: Colors.green, // Màu xanh cho radio
                    )),
              ),
            ),
            Expanded(
              child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Female", style: TextStyle(color: Colors.green)), // Màu xanh cho text
                  leading: Transform.translate(
                    offset: const Offset(16, 0),
                    child: Radio(
                      value: 2,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                      activeColor: Colors.green, // Màu xanh cho radio
                    ),
                  )),
            ),
            Expanded(
                child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Other", style: TextStyle(color: Colors.green)), // Màu xanh cho text
              leading: Transform.translate(
                  offset: const Offset(16, 0),
                  child: Radio(
                    value: 3,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    activeColor: Colors.green, // Màu xanh cho radio
                  )),
            )),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _imageURL,
          decoration: InputDecoration(
            labelText: "Image URL",
            labelStyle: const TextStyle(color: Colors.green), // Màu xanh cho chữ
            icon: const Icon(Icons.image, color: Colors.green), // Màu xanh cho icon
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          style: const TextStyle(color: Colors.green), // Màu xanh cho text
        ),
      ],
    );
  }
}
