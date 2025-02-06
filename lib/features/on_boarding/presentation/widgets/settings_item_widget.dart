import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class SettingsItemWidget extends StatelessWidget {
  final String title;
  
  final Widget action;
  const SettingsItemWidget({
    Key? key,
    required this.title,
   
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    
    Padding(
      padding: EdgeInsets.all(5.0.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.h)),
          color: Color.fromARGB(255, 232, 234, 238),
        ),
        child: ListTile(
          // leading: Icon(icon),
          title: Text(title),
          trailing: action
        ),
      ),
    );
  }
}
