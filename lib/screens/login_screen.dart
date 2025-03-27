import 'package:allergeo/config/constants.dart';
import 'package:allergeo/main.dart';
import 'package:allergeo/screens/home_screen.dart';
import 'package:allergeo/utils/strings.dart';
import 'package:allergeo/widgets/bazier_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:allergeo/config/colors.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Aller',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: 'Geo',
            style: TextStyle(
              color: AppColors.ALLERGEO_GREEN,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String url = '${AppConstants.usersUrl}login';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final String accessToken = data['access'];
      final String refreshToken = data['refresh'];

      await _storage.write(key: 'accessToken', value: accessToken);
      await _storage.write(key: 'refreshToken', value: refreshToken);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Giriş başarısız')));
    }
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.shade200,
            offset: Offset(2, 4),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.ALLERGEO_GREEN.shade300,
            AppColors.ALLERGEO_GREEN.shade800,
          ],
        ),
      ),
      child: Text(
        'Giriş Yap',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Henüz hesabınız yok mu?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 10),
            Text(
              'Üye olun',
              style: TextStyle(
                color: AppColors.ALLERGEO_GREEN,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 10),
          TextField(
            controller: isPassword ? _passwordController : _usernameController,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _usernamePasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Kullanıcı Adı"),
        _entryField("Şifre", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.only(left: 80, right: 80),
                      child: Text(
                        Strings.APP_SLOGAN,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _usernamePasswordWidget(),
                    SizedBox(height: 20),
                    GestureDetector(onTap: login, child: _submitButton()),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Şifremi Unuttum',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: height * .015),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
