import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mns_final/constants/constants.dart';
import 'package:mns_final/features/explore/view/explore_view.dart';
import 'package:mns_final/features/tweet/widgets/tweet_list.dart';
import 'package:mns_final/theme/theme.dart';

import '../features/notifications/views/notification_view.dart';


class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    ExploreView(),
    NotificationView(),
  ];
}
