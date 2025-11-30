import 'package:fluffy/modules/auth/register_business_screens/add_location.dart';
import 'package:fluffy/modules/auth/register_business_screens/provider/business_hours_provider.dart';
import 'package:fluffy/modules/auth/register_business_screens/model/business_hours_model.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/constant.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessHoursScreen extends StatefulWidget {
  const BusinessHoursScreen({super.key});

  @override
  State<BusinessHoursScreen> createState() => _BusinessHoursScreenState();
}

class _BusinessHoursScreenState extends State<BusinessHoursScreen> {
  TimeOfDay commonStartTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay commonEndTime = const TimeOfDay(hour: 20, minute: 0);

  String? userId;
  late List<DayHour> hours;

  @override
  void initState() {
    super.initState();
    loadUserData();
    initHours();
  }

  void initHours() {
    hours = Provider.of<BusinessHoursProvider>(context, listen: false).hours;
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });
    print("User ID: $userId");
  }

  // ✅ TIME FORMATTER
  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  // ✅ APPLY TO ALL START TIME
  Future<void> selectAllStartTime(BuildContext context) async {
    final picked =
        await showTimePicker(context: context, initialTime: commonStartTime);
    if (picked != null) {
      setState(() {
        commonStartTime = picked;
        final formatted = formatTimeOfDay(picked);
        for (var d in hours) {
          if (d.isOpen) d.openTime = formatted;
        }
      });
    }
  }

  // ✅ APPLY TO ALL END TIME
  Future<void> selectAllEndTime(BuildContext context) async {
    final picked =
        await showTimePicker(context: context, initialTime: commonEndTime);
    if (picked != null) {
      setState(() {
        commonEndTime = picked;
        final formatted = formatTimeOfDay(picked);
        for (var d in hours) {
          if (d.isOpen) d.closeTime = formatted;
        }
      });
    }
  }

  // ✅ INDIVIDUAL TIME PICKER
  Future<void> pickTime(BuildContext context, int index, bool isStart) async {
    if (!hours[index].isOpen) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) {
      setState(() {
        final formatted = formatTimeOfDay(picked);
        if (isStart) {
          hours[index].openTime = formatted;
        } else {
          hours[index].closeTime = formatted;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final businessHoursProvider = Provider.of<BusinessHoursProvider>(context);

    return Scaffold(
      appBar: appBarWithBackButton(context, "Business Hours"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Labels
            Row(
              children: const [
                Expanded(child: TextWidget(text: "Select Start Time")),
                SizedBox(width: 10),
                Expanded(child: TextWidget(text: "Select End Time")),
              ],
            ),

            const SizedBox(height: 10),

            // ✅ GLOBAL TIME PICKERS
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => selectAllStartTime(context),
                    child: timeBox(formatTimeOfDay(commonStartTime)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => selectAllEndTime(context),
                    child: timeBox(formatTimeOfDay(commonEndTime)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ LIST DAYS
            Expanded(
              child: ListView.builder(
                itemCount: hours.length,
                itemBuilder: (_, index) {
                  final item = hours[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Switch(
                          value: item.isOpen,
                          onChanged: (v) {
                            setState(() {
                              item.isOpen = v;
                              if (!v) {
                                item.openTime = null;
                                item.closeTime = null;
                              } else {
                                item.openTime =
                                    formatTimeOfDay(commonStartTime);
                                item.closeTime = formatTimeOfDay(commonEndTime);
                              }
                            });
                          },
                        ),

                        Text(item.day.toUpperCase()),

                        const Spacer(),

                        // ✅ START
                        GestureDetector(
                          onTap: () => pickTime(context, index, true),
                          child: smallBox(
                            item.isOpen
                                ? (item.openTime ?? "Closed")
                                : "Closed",
                          ),
                        ),

                        const SizedBox(width: 8),

                        // ✅ END
                        GestureDetector(
                          onTap: () => pickTime(context, index, false),
                          child: smallBox(
                            item.isOpen
                                ? (item.closeTime ?? "Closed")
                                : "Closed",
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ✅ SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result =
                      await businessHoursProvider.submitHours(userId!, hours);

                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Business Hours Added Successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddLocation()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ UI Helper Widgets
  Widget timeBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(text),
        const Icon(Icons.access_time, size: 18),
      ]),
    );
  }

  Widget smallBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Text(text),
    );
  }
}
