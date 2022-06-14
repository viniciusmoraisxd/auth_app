import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/themes/themes.dart';

class HeaderWidget extends StatelessWidget {
  final double height;
  const HeaderWidget({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppImages.login,
            height: height * 0.35,
          ),
        
        ],
      ),
    );
  }
}
