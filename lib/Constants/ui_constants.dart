import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../features/tweet/widget/tweet_list.dart';
import '../theme/theme.dart';
import 'constants.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        // ignore: deprecated_member_use
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    Text("searchscreen"),
    Text("notificationscreen"),
    
   
    // ExploreView(),
    // NotificationView(),
  ];
}