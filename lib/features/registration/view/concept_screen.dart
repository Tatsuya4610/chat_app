import 'package:chat_app/features/registration/view/login_screen.dart';
import 'package:chat_app/features/registration/view/signup_screen.dart';
import 'package:chat_app/widgets/button/app_button.dart';
import 'package:flutter/material.dart';

class ConceptScreen extends StatelessWidget {
  const ConceptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 背景色
      body: SafeArea(
        // SafeAreaは端末の上下(時間や充電残量)などより内側からUIを構築する
        child: Column(
          // Columnは縦に並べる時に使用。Columnのchildrenの中に実装するWidgetたちは縦に並ぶ。
          children: [
            const DescriptionSection(), // これは55行目にあるWidgetを配置。コードが長い場合や使い回したい時に使う。
            Padding(
              // Paddingは外側に余白を付けることができる。
              padding: const EdgeInsets.symmetric(
                // symmetricは上下左右対称的に設定できる。
                horizontal: 40, // 左右に40pxの余白
                vertical: 30, // 上下に30pxの余白
              ),
              child: Column(
                // Columnの中にColumnを設定できる。このColumnはpaddingの中の階層なため、このColumn内にある
                // Widgetたち全てにpaddingが適応される。
                children: [
                  AppButton(
                    // このAppButtonはlib/widgets/button/app_button.dartから取得し表示させている。
                    label: '会員登録', // 実装した引数に文字列を渡している。文字だけ異なるため共通利用する例。
                    onTap: () {
                      // ボタンが押された際のアクションはここに書く。
                      // SignupScreenを開く。
                      Navigator.of(context).push(
                        MaterialPageRoute<SignupScreen>(
                          builder: (_) {
                            return const SignupScreen();
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    // SizedBoxは空間をあけたい時に使う。
                    height: 20, // 縦に20pxの余白
                  ),
                  AppButton(
                    label: 'ログイン',
                    reverse: true,
                    onTap: () {
                      // LoginScreenを開く。
                      Navigator.of(context).push(
                        MaterialPageRoute<LoginScreen>(
                          builder: (_) {
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 60,
      ),
      child: Container(
        width: 300,
        height: 300,
        color: Colors.blueGrey,
        child: Center(
          child: Text(
            'ここには説明が入ります。\nこんにちは', // \nは改行
            style: TextStyle(
              fontSize: 16, // 文字のサイズ
              fontWeight: FontWeight.w700, // 文字の太さ
              color: Colors.white, // 文字の色
              letterSpacing: 5, // 文字と文字の間隔
            ),
            textAlign: TextAlign.center, // 折り返しの際、中央寄せにする。
          ),
        ),
      ),
    );
  }
}
