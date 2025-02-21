import 'package:chat_app/features/app_entry/model/user_status.dart';
import 'package:chat_app/features/registration/view/concept_screen.dart';
import 'package:chat_app/widgets/screen/error_screen.dart';
import 'package:chat_app/widgets/screen/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppEntryViewWidget extends HookWidget {
  const AppEntryViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userStatus = useState<AsyncValue<UserStatus>>(const AsyncLoading());

    Future<void> initState() async {
      try {
        // ローディングを見せるために2秒の遅延
        await Future.delayed(const Duration(seconds: 2));

        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          userStatus.value = const AsyncData(UserStatus.notSignedIn);
        } else {
          userStatus.value = const AsyncData(UserStatus.signedIn);
        }
      } catch (e, stackTrace) {
        userStatus.value = AsyncError(e, stackTrace);
      }
    }

    useEffect(() {
      // 画面表示時1度だけ初期化
      initState();
      return null;
    }, []);

    return userStatus.value.when(
      loading: () => const LoadingScreen(),
      error: (_, __) => ErrorScreen(
        onRefresh: () {
          userStatus.value = const AsyncLoading();
          initState();
        },
      ),
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
