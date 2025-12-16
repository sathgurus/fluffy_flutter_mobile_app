import 'package:fluffy/modules/settings/provider/profileProvider.dart';
import 'package:fluffy/modules/settings/widget/aadhaar_bs.dart';
import 'package:fluffy/modules/settings/widget/gst_bs.dart';
import 'package:fluffy/modules/settings/widget/pan_no_bs.dart';
import 'package:fluffy/modules/settings/widget/tin_no_bs.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/constant.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessSettings extends StatefulWidget {
  const BusinessSettings({super.key});

  @override
  State<BusinessSettings> createState() => _BusinessSettingsState();
}

class _BusinessSettingsState extends State<BusinessSettings> {
  @override
  void initState() {
    super.initState();
    loadUserAndFetch();
  }

  Future<void> loadUserAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("userId");

    if (id != null) {
      // userId = id;

      context.read<Profileprovider>().fetchBusinessDetails(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Profileprovider>();
    final data = provider.shopVerification;
    print("sho details $data");
    return Scaffold(
      appBar: appBarWithBackButton(context, "Business Settings"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  child: Container(
                    //padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      //color: AppColors.whiteColor,
                    ),
                    child: Column(
                      children: [
                        listItem(
                          "Aadhaar Number",
                          data['aadharNumber'] ?? "",
                          aadhaarBottomSheet,
                        ),
                        const SizedBox(height: 1),
                        listItem(
                          "PAN Number",
                          data['panNumber'] ?? "",
                          panBottomSheet,
                        ),
                        const SizedBox(height: 1),
                        listItem(
                          "GSTIN",
                          data['gstNumber'] ?? "",
                          gstBottomSheet,
                        ),
                        const SizedBox(height: 1),
                        listItem(
                          "TIN Number",
                          data['tinNumber'] ?? "",
                          tinBottomSheet,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem(String title, String value, Function bottomSheet) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return InkWell(
      onTap: () {
        bottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextWidget(
                text: title,
                fontWeight: FontWeight.w400,
                fontSize: listTitleTextSize,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,

                child: TextWidget(
                  text: value,
                  fontWeight: FontWeight.w400,
                  fontSize: listTitleTextSize,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: (width - 50) * 0.10,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: appPrimaryColor,
              ),
            ),
          ],
        ),
        //   ],
        // ),
      ),
    );
  }
}
