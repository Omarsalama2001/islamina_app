import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/widgets/snack_bar.dart';
import 'package:islamina_app/generated/l10n.dart';

import '../../data/models/e_tasbih.dart';

class AddEditTasbihDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final isAddButtonEnabled = RxBool(false);

  final bool isEditing;
  final ElectronicTasbihModel? editItem;

  AddEditTasbihDialog({required this.isEditing, this.editItem, super.key}) {
    if (isEditing) {
      nameController.text = editItem?.name ?? '';
      countController.text = editItem?.count.toString() ?? '';
      updateAddButtonStatus('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditing ? context.translate('editTasbih'): context.translate('addNewTasbih'),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            onChanged: updateAddButtonStatus,
            decoration: InputDecoration(
              labelText: context.translate('tasbih'),
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(10),
              labelStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: countController,
            onChanged: updateAddButtonStatus,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: context.translate('noOfBeads'),
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(10),
              labelStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: null),
          child:  Text(context.translate('cancel')),
        ),
        Obx(() {
          return TextButton(
            onPressed: isAddButtonEnabled.value ? saveItem : null,
            child: Text(isEditing ? context.translate('saveEditing') : context.translate('add')),
          );
        }),
      ],
    );
  }

  void updateAddButtonStatus(String _) {
    isAddButtonEnabled.value = nameController.text.isNotEmpty && countController.text.isNotEmpty;
  }

  void saveItem() {
    final name = nameController.text;
    final count = int.tryParse(countController.text) ?? 0;
    if (isEditing) {
      if (count < 1) {
        Fluttertoast.showToast(msg: 'عدد الحبات يجب ان يكون اكبر من 0');
        return;
      }
      Get.back(result: ElectronicTasbihModel(advantage: editItem!.advantage, id: editItem!.id, name: name, count: count, isSystem: 0));
    } else {
      if (count < 1) {
         Fluttertoast.showToast(msg: 'عدد الحبات يجب ان يكون اكبر من 0' ,backgroundColor: Colors.white, textColor: Colors.black);
        return;
      }
      Get.back(result: ElectronicTasbihModel(name: name, count: count, advantage: 'أضيف بواسطة المستخدم', isSystem: 0));
    }
  }
}
