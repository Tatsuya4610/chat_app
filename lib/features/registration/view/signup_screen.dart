import 'package:chat_app/widgets/button/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// HookWidgetを使った場合の会員登録画面
// HookWidgetを使うとStatefulWidgetで実装するinitStateやdisposeを
// 書く必要はありません。
class SignupScreen extends HookWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // useTextEditingControllerはStatefulWidgetで行っていたinitState(初期化)やdispose(破棄)
    // を自動で行ってくれるので1行で済みます。
    final emailTextController = useTextEditingController(text: '初期値');
    final passwordTextController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);

    // もしStatefulWidgetと同じように画面の表示と破棄されたタイミングを取りたい場合は
    // useEffectを記載する。
    useEffect(() {
      print('画面が表示されたタイミング');
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('未ログイン');
      } else {
        print('${user.email}のユーザーでログイン');
      }
      return () {
        print('画面が破棄されたタイミング');
      };
    }, const []);

    // 入力中のメールアドレス表示するために保持する変数
    final emailText = useState<String>('');

    Future<void> registerWithEmailAndPassword({
      required String email,
      required String password,
    }) async {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print('登録成功: ${credential.user?.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登録に成功しました: ${credential.user?.email}')),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = '登録に失敗しました';
        if (e.code == 'weak-password') {
          errorMessage = 'パスワードが短すぎます。';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'このメールアドレスは既に登録されています。';
        } else if (e.code == 'invalid-email') {
          errorMessage = '無効なメールアドレスです。';
        }
        print('エラー: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        print('予期しないエラー: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('予期しないエラーが発生しました')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('会員登録'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Text(
                  'ログイン時に必要なメールアドレス・パスワード\nを入力してユーザー登録してください。',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(emailText.value),
                const SizedBox(height: 150),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailTextController,
                        decoration: InputDecoration(
                          labelText: 'メールアドレス',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'メールアドレスを入力してください';
                          }
                          if (!value.contains('@')) {
                            return '有効なメールアドレスを入力してください';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // emailTextに代入。
                          emailText.value = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordTextController,
                        obscureText: true, // パスワードを非表示にする
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
                          onTap: () async {
                            final validate = formKey.currentState!.validate();
                            if (validate) {
                              final inputEmail = emailTextController.text;
                              final inputPassword = emailTextController.text;
                              print('入力されたメールアドレス$inputEmail');
                              print('入力されたパスワード$inputPassword');
                              await registerWithEmailAndPassword(
                                email: inputEmail,
                                password: inputPassword,
                              );
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
