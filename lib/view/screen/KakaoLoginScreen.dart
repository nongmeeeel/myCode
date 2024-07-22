import 'package:flutter/material.dart';
import 'package:mycode/common/login/KakaoLogin.dart';
import 'package:mycode/service/KakaoLoginController.dart';

class KakaoLoginScreen extends StatefulWidget {
  @override
  State<KakaoLoginScreen> createState() => _KakaoLoginScreenState();
}

class _KakaoLoginScreenState extends State<KakaoLoginScreen> {
  final KakaoLoginController kakaoLoginController = KakaoLoginController(KakaoLogin());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.network(kakaoLoginController.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
            Text(
              '${kakaoLoginController.isLogined}',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () async {
                await kakaoLoginController.login();
                setState(() {

                });
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                await kakaoLoginController.logout();
                setState(() {

                });
              },
              child: Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
