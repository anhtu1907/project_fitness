import 'package:flutter/material.dart';

class AppNavigator {
  static void push(BuildContext context, Widget widget) {
    Navigator.push(context, _slideRoute(widget));
  }

  static Future<dynamic> pushFuture(BuildContext context, Widget widget) {
    return Navigator.push(context, _slideRoute(widget));
  }

  static void pushReplacement(BuildContext context, Widget widget) {
    Navigator.pushReplacement(context, _slideRoute(widget));
  }

  static void pushAndRemoveUntil(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
        context, _slideRoute(widget), (Route<dynamic> route) => false);
  }

  static PageRouteBuilder _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);

        //Offset.zero là vị trí trung tâm màn hình.
        const end = Offset.zero;

        //Curves.ease giúp chuyển động mượt mà (tăng tốc chậm, rồi nhanh dần).
        const curve = Curves.ease;
        //Tween tạo ra giá trị di chuyển từ phải vào giữa.
        //.chain(CurveTween(...)) áp dụng hiệu ứng cong (ease).
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        //.drive(animation) dùng giá trị animation để chạy tween đó.
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
