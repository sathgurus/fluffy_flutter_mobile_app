import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/constant.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:flutter/material.dart';

tinBottomSheet(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: "TIN Number",
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: textSizeSMedium,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                const Divider(),
                const SizedBox(height: 10),
                Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: TextFormField(
                    initialValue: "",
                   
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: textSizeSMedium,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(12, 4, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (newValue) {},
                  ),
                ),
                 const SizedBox(height: 20),
                InkWell(
                  onTap: () {},
                  child: Container(
                    //  height: 60,
                    //margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.primary,
                    ),
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: TextWidget(
                      text: "Save",
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
