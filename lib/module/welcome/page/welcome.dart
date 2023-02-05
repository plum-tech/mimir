import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../using.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Widget buildEntryButton(BuildContext context, String title, String routeName) {
    return OutlinedButton(
      autofocus: true,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
        ),
        side: BorderSide(width: 1.spMin, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
      ),
      onPressed: () => Navigator.of(context).pushNamed(routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image.
          SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: const Image(
              image: AssetImage('assets/welcome/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          // Transparent layer.
          Container(color: Colors.black.withOpacity(0.35)),
          // Front weights. Texts and buttons are on the left bottom of the screen.
          Container(
            width: 1.sw,
            height: 1.sh,
            alignment: Alignment.bottomLeft,
            // 150 px from the bottom edge and 20 px from the left edge.
            padding: EdgeInsets.fromLTRB(40.w, 20.h, 0, 150.h),
            child: Column(
              // If MainAxisSize.min is ignored, the height of the Container will be full.
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  R.appName,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                // Subtitle
                Text(
                  i18n.welcomeSlogan,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                // Space
                SizedBox(height: 40.h),
                // Login button
                buildEntryButton(context, i18n.welcomeLogin, RouteTable.login),
              ],
            ),
          )
        ],
      ),
    );
  }
}
