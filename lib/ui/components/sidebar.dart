import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow()],
        shape: BoxShape.rectangle,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListView(
        children: [
          DrawerHeader(child: Center(child: Text(
            "Sldebar Header",
            style: GoogleFonts.montserrat(
              fontSize: 28, fontWeight: FontWeight.w700,
            ),
          ),)),
          SidebarItem(
            title: "Dashboard",
            iconData: Icons.dashboard,
            press: () => {_showToast(context, "Dashboard Tab Selected")},
          ),
          SidebarItem(
            title: "Settings",
            iconData: Icons.settings,
            press: () => {_showToast(context, "Settings Tab Selected")},
          ),
          SidebarItem(
            title: "Profile",
            iconData: Icons.person,
            press: () => {_showToast(context, "Profile Tab Selected")},
          ),
          SidebarItem(
            title: "Add Person",
            iconData: Icons.add,
            press: () => {_showToast(context, "Add Person Selected")},
          )
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    Key? key,
    required this.title,
    required this.iconData,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        iconData,
        size: 16,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.button,
      ),
    );
  }
}
