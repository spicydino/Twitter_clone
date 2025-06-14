import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mns_final/Constants/assets_constants.dart';

class ReusableAppBar extends StatelessWidget {
  const ReusableAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(
      AssetsConstants.twitterLogo,
    ));
    
  }
}