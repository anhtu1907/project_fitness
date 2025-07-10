import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? subTitle;
  final Widget? action;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final bool hideBack;
  const BasicAppBar(
      {super.key,
      this.title,
      this.subTitle,
      this.action,
      this.onPressed,
      this.backgroundColor,
      this.hideBack = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          if (title != null) title!,
          if (subTitle != null) subTitle!,
        ],
      ),
      actions: [action ?? Container()],
      leading: hideBack
          ? null
          : IconButton(
              onPressed: onPressed,
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    shape: BoxShape.circle),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 15,
                  color: Colors.white,
                ),
              )),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
