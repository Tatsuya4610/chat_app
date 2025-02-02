import 'package:chat_app/features/app_entry/model/user_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// `AppEntryController` を管理するプロバイダー
// `StateNotifierProvider` を使用して、状態管理を行う
final appEntryControllerProvider =
    StateNotifierProvider<AppEntryController, AsyncValue<UserStatus>>(
  (ref) => AppEntryController(),
);

// アプリのエントリー状態を管理する `StateNotifier` クラス
// `AsyncValue<UserStatus>` を状態として扱い、非同期処理を管理する
class AppEntryController extends StateNotifier<AsyncValue<UserStatus>> {
  // 初期状態はローディング (`AsyncLoading()`) にし、初期化処理 `_initState()` を呼び出す
  // AsyncValueにはloading・error・dataの3つの状態を持っている。
  AppEntryController() : super(const AsyncLoading()) {
    _initState();
  }

  Future<void> _initState() async {
    // ローディング画面がわかりやすいように2秒遅延させる。
    await Future.delayed(Duration(seconds: 2));

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // FirebaseAuthからuserが取得できない場合は未ログインなため、notSignedIn状態。
      state = const AsyncData(UserStatus.notSignedIn);
      return;
    }
    // ログイン済みのため、`UserStatus.signedIn` を設定
    state = const AsyncData(UserStatus.signedIn);
  }

  // エラー時など再読み込みさせるメソッド
  void refresh() {
    state = const AsyncLoading();
    _initState();
  }
}
