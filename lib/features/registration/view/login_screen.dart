import 'package:chat_app/widgets/button/app_button.dart';
import 'package:flutter/material.dart';

// StatefulWidgetを使った場合のログイン画面
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // メールアドレスとパスワードを入力するためのTextEditingControllerを定義
  // lateは変数の遅延初期化を定義。TextControllerを実際に使用する前に変数を定義
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print('画面が表示されたタイミング');
    // initStateは画面が表示される一番最初に1度だけ呼び出される。

    super.initState();
    // lateで定義していたTextEditingControllerを画面を開く際に代入し初期化。
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();

    // 初期値を設定（必要に応じて）
    emailTextController.text = "初期値";
  }

  @override
  void dispose() {
    print('画面が破棄されたタイミング');
    // disposeはStatefulWidgetが破棄されるときに呼び出される
    // emailTextController.dispose()でTextEditingControllerをリソース破棄し解放する。
    // disposeしないとTextControllerが内部で持っている情報が残り続ける。
    // また再度開き直した場合、前回のTextControllerの情報は残り続け、２つ状態を持ち続けること
    // になり、メモリを消費してしまう。
    emailTextController.dispose();
    passwordTextController.dispose();

    super.dispose();
  }

  // 入力中のメールアドレス表示するために保持する変数
  String emailText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // 画面が小さく溢れた場合はスクロールする。
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Text(
                  'メールアドレス・パスワード\nを入力してください。',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(emailText),
                const SizedBox(height: 150),
                Form(
                  // Formウィジェットは、child内にある複数のフォームフィールド（TextFormFieldなど）をまとめて管理。
                  // keyセットしたformKeyがこのFormに紐付いている。
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailTextController,
                        // TextInputType.emailAddressはキーボードがemail入力に適した種類になる。
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'メールアドレス',
                        ),
                        validator: (value) {
                          // バリデーションの定義を記載。valueは入力されている文字列。
                          if (value == null || value.isEmpty) {
                            return 'メールアドレスを入力してください';
                          }
                          // 入力された文字に@が含まれているかどうか。
                          // 問題がない場合はnullを返す
                          if (!value.contains('@')) {
                            return '有効なメールアドレスを入力してください';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // onChangedがリアルタイムで入力中の文字列を返すメソッド。
                          setState(() {
                            // setStateを呼び出すと画面が再描画され画面が更新される。
                            emailText = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordTextController,
                        obscureText: true, // パスワードを非表示にする
                        // TextInputType.visiblePasswordはキーボードがパスワード入力に適した種類になる。
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: 'パスワード',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'パスワードを入力してください。';
                          }
                          if (value.length < 5) {
                            return 'パスワードは5文字以上入力してください。';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 60),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: AppButton(
                          label: '登録',
                          onTap: () {
                            // formKeyを使ってTextFormFieldのvalidatorを実行
                            // 問題ない場合はtrueを問題ある場合はfalseを返す。
                            final validate = formKey.currentState!.validate();
                            if (validate) {
                              // 入力されたメールアドレスを取得
                              final inputEmail = emailTextController.text;
                              // 入力されたパスワードを取得
                              final inputPassword = emailTextController.text;
                              print('入力されたメールアドレス$inputEmail');
                              print('入力されたパスワード$inputPassword');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
