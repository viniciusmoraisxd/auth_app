import 'package:auth_app/presentation/helpers/helpers.dart';
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
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: height * 0.06, bottom: height * 0.024),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            key: const Key("signInAsset"),
            AppImages.login,
            height: height * 0.35,
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                R.strings.login,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
