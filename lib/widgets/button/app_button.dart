import 'package:chat_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label, // requiredは必須設定。AppButtonの呼び出し先でlabelを設定しないとエラーが出る。
    this.reverse = false, // 初期値はfalse。reverseを設定しない場合。
    required this.onTap,
    super.key,
  });

  final String label;
  final bool reverse;
  final VoidCallback onTap;

  static const _borderRadius = 23.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // GestureDetectorで囲み、onTapを設定するとGestureDetectorのchildを押されたら
      // onTapが反応する
      onTap: () {
        onTap();
      },
      child: Container(
        height: 46,
        width: double.infinity,
        decoration: BoxDecoration(
          color: reverse ? Colors.white : AppColors.mainBlue,
          borderRadius:
              BorderRadius.circular(_borderRadius), // borderRadiusは角の丸み。
          border:
              // borderは周りの線の設定。reverse(bool) ?  true : false
              // reverseがtrueの場合はBorder.all(width: 2, color: AppColors.mainBeige)
              // reverseがfalseの場合はnullで設定しない。
              reverse ? Border.all(width: 2, color: AppColors.mainBlue) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: reverse ? AppColors.mainBlue : Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
