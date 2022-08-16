import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderWidget extends StatelessWidget {
  final double height;
  final String image;
  final String title;
  final String assetKey;
  const HeaderWidget({
    Key? key,
    required this.height,
    required this.image,
    required this.title,
    required this.assetKey,
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
            key: Key(assetKey),
            image,
            height: height * 0.35,
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
