import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/constant.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:flutter/material.dart';

class BusinessHoursScreen extends StatefulWidget {
  const BusinessHoursScreen({super.key});
  @override
  State<BusinessHoursScreen> createState() => _BusinessHoursScreenState();
}

class _BusinessHoursScreenState extends State<BusinessHoursScreen> {
  TimeOfDay commonStartTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay commonEndTime = const TimeOfDay(hour: 20, minute: 0);

  // Local list (instead of Provider)
  final List<Map<String, dynamic>> hours = [
    {"day": "monday", "isOpen": true, "openTime": "09:00 AM", "closeTime": "08:00 PM"},
    {"day": "tuesday", "isOpen": true, "openTime": "09:00 AM", "closeTime": "08:00 PM"},
    {"day": "wednesday", "isOpen": true, "openTime": "09:00 AM", "closeTime": "08:00 PM"},
    {"day": "thursday", "isOpen": true, "openTime": "09:00 AM", "closeTime": "08:00 PM"},
    {"day": "friday", "isOpen": true, "openTime": "09:00 AM", "closeTime": "08:00 PM"},
    {"day": "saturday", "isOpen": true, "openTime": "09:00 AM", "closeTime": "08:00 PM"},
    {"day": "sunday", "isOpen": false, "openTime": null, "closeTime": null},
  ];

  // FORMAT TIME
  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  // APPLY START TIME TO ALL
  Future<void> selectAllStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: commonStartTime,
    );

    if (picked != null) {
      setState(() {
        commonStartTime = picked;
        String formatted = formatTimeOfDay(picked);

        for (var day in hours) {
          if (day["isOpen"]) day["openTime"] = formatted;
        }
      });
    }
  }

  // APPLY END TIME TO ALL
  Future<void> selectAllEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: commonEndTime,
    );

    if (picked != null) {
      setState(() {
        commonEndTime = picked;
        String formatted = formatTimeOfDay(picked);

        for (var day in hours) {
          if (day["isOpen"]) day["closeTime"] = formatted;
        }
      });
    }
  }

  // INDIVIDUAL TIME PICKER
  Future<void> pickTime(BuildContext context, int index, bool isStart) async {
    if (!hours[index]["isOpen"]) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) {
      setState(() {
        String formatted = formatTimeOfDay(picked);
        if (isStart) {
          hours[index]["openTime"] = formatted;
        } else {
          hours[index]["closeTime"] = formatted;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBackButton(context, "Business Hours"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextWidget(
                    text: "Select Start Time",
                    fontSize: textSizeSmall,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextWidget(
                    text: "Select End Time",
                    fontSize: textSizeSmall,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// GLOBAL SELECTOR
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => selectAllStartTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatTimeOfDay(commonStartTime),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Icon(Icons.access_time, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: GestureDetector(
                    onTap: () => selectAllEndTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatTimeOfDay(commonEndTime),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Icon(Icons.access_time, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// LIST OF DAYS
            Expanded(
              child: ListView.builder(
                itemCount: hours.length,
                itemBuilder: (_, index) {
                  final item = hours[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: item["isOpen"],
                            onChanged: (v) {
                              setState(() {
                                item["isOpen"] = v;
                                if (!v) {
                                  item["openTime"] = null;
                                  item["closeTime"] = null;
                                } else {
                                  item["openTime"] = formatTimeOfDay(commonStartTime);
                                  item["closeTime"] = formatTimeOfDay(commonEndTime);
                                }
                              });
                            },
                          ),
                        ),

                        Text(
                          item["day"].toString().toUpperCase(),
                          style: const TextStyle(
                            fontSize: textSizeSMedium,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const Spacer(),

                        // START TIME
                        GestureDetector(
                          onTap: () => pickTime(context, index, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Text(
                              item["isOpen"] ? item["openTime"] ?? "Closed" : "Closed",
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // END TIME
                        GestureDetector(
                          onTap: () => pickTime(context, index, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Text(
                              item["isOpen"] ? item["closeTime"] ?? "Closed" : "Closed",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {
                print(hours); // Debug
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
