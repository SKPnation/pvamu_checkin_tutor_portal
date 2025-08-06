// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/local_navigator.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/widgets/side_menu.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/widgets/top_nav.dart';


class LargeScreen extends StatefulWidget {
  const LargeScreen({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;


  @override
  State<LargeScreen> createState() => _LargeScreenState();
}

class _LargeScreenState extends State<LargeScreen> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SideMenu(scaffoldKey: widget.scaffoldKey),
        ),
        SizedBox(width: 24),
        Expanded(
          flex: 7,
          child: Column(
            children: [
              topNavigationBar(context, widget.scaffoldKey, "Admin"),
              localNavigator()
            ],
          )

        ),
        SizedBox(width: 24),


      ],
    );
  }
}
