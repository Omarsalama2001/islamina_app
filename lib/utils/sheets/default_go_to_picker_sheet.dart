import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';

class DefaultGoToSheet extends StatelessWidget {
  const DefaultGoToSheet(
      {super.key,
      required this.initValue,
      required this.title,
      required this.childCount,
      required this.itemBuilder,
      this.onPressed});
  final int initValue;
  final String title;
  final int childCount;
  final Widget? Function(BuildContext, int) itemBuilder;
  final void Function(int selectedValue)? onPressed;
  @override
  Widget build(BuildContext context) {
    int? selectedValue;

    return Material(
      child: SizedBox(
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  top: 20, start: 25, bottom: 5),
              child: Text(
                context.translate(title),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: CupertinoPicker.builder(
                  itemExtent: 50,
                  scrollController:
                      FixedExtentScrollController(initialItem: initValue - 1),
                  childCount: childCount,
                  onSelectedItemChanged: (value) {
                    selectedValue = value + 1;
                  },
                  itemBuilder: itemBuilder),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FilledButton(
                onPressed: () {
                  onPressed!(selectedValue ?? initValue);
                },
                child:  Text(context.translate("heMoved")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
