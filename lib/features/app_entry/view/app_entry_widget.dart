import 'package:chat_app/features/app_entry/controller/app_entry_controller.dart';
import 'package:chat_app/features/app_entry/model/user_status.dart';
import 'package:chat_app/features/registration/view/concept_screen.dart';
import 'package:chat_app/widgets/screen/error_screen.dart';
import 'package:chat_app/widgets/screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Riverpod の `HookConsumerWidget` を使用し、状態を監視する
class AppEntryWidget extends HookConsumerWidget {
  const AppEntryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // `appEntryControllerProvider` の状態を監視
    final asyncState = ref.watch(appEntryControllerProvider);

    // 状態に応じて適切な画面を表示する
    return asyncState.when(
      error: (_, __) => ErrorScreen(
        onRefresh: () {
          // 再読み込みボタンでリフレッシュさせる。
          ref.read(appEntryControllerProvider.notifier).refresh();
        },
      ),
      // ローディング中の画面
      loading: () => const LoadingScreen(),
      // 正常にデータを取得した場合
      data: (state) {
        switch (state) {
          case UserStatus.notSignedIn:
            return const ConceptScreen();
          case UserStatus.notFinishedWalkThrough:
            return const Scaffold(body: Center(child: Text('ウォークスルー')));
          case UserStatus.signedIn:
            return const Scaffold(body: Center(child: Text('ログイン完了')));
        }
      },
    );
  }
}
