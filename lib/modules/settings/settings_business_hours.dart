import 'package:fluffy/modules/auth/register_business_screens/provider/business_hours_provider.dart';
import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:fluffy/modules/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBusinessHours extends StatefulWidget {
  const SettingsBusinessHours({super.key});

  @override
  State<SettingsBusinessHours> createState() => _SettingsBusinessHoursState();
}

class _SettingsBusinessHoursState extends State<SettingsBusinessHours> {
  TimeOfDay commonStartTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay commonEndTime = const TimeOfDay(hour: 20, minute: 0);

  String? userId;
  bool _apiApplied = false;

  final List<Map<String, dynamic>> hours = [
    {
      "day": "monday",
      "isOpen": true,
      "openTime": "09:00 AM",
      "closeTime": "08:00 PM",
    },
    {
      "day": "tuesday",
      "isOpen": true,
      "openTime": "09:00 AM",
      "closeTime": "08:00 PM",
    },
    {
      "day": "wednesday",
      "isOpen": true,
      "openTime": "09:00 AM",
      "closeTime": "08:00 PM",
    },
    {
      "day": "thursday",
      "isOpen": true,
      "openTime": "09:00 AM",
      "closeTime": "08:00 PM",
    },
    {
      "day": "friday",
      "isOpen": true,
      "openTime": "09:00 AM",
      "closeTime": "08:00 PM",
    },
    {
      "day": "saturday",
      "isOpen": true,
      "openTime": "09:00 AM",
      "closeTime": "08:00 PM",
    },
    {"day": "sunday", "isOpen": false, "openTime": null, "closeTime": null},
  ];

  @override
  void initState() {
    super.initState();
    loadUserAndFetch();
  }

  Future<void> loadUserAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("userId");

    if (id != null) {
      userId = id;
      context.read<BusinessHoursProvider>().fetchBusinessHours(id);
    }
  }

  // ---------------- API DATA APPLY ----------------

  void applyBusinessHours(List apiHours) {
    print("Applying API Business Hours: $apiHours");
    for (int i = 0; i < hours.length; i++) {
      final apiDay = apiHours.firstWhere(
        (e) => e['day'] == hours[i]['day'],
        orElse: () => null,
      );

      if (apiDay != null) {
        hours[i]['isOpen'] = apiDay['isOpen'] ?? false;
        hours[i]['openTime'] = apiDay['openTime'];
        hours[i]['closeTime'] = apiDay['closeTime'];
      }
    }

    syncCommonTime();
    setState(() {});
  }

  void syncCommonTime() {
    final openDay = hours.firstWhere(
      (d) => d['isOpen'] == true && d['openTime'] != null,
      orElse: () => {},
    );

    if (openDay.isNotEmpty) {
      commonStartTime = parseTime(openDay['openTime']);
      commonEndTime = parseTime(openDay['closeTime']);
    }
  }

  // ---------------- TIME UTILS ----------------

  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  TimeOfDay parseTime(String time) {
    final parts = time.split(' ');
    final hm = parts[0].split(':');
    int hour = int.parse(hm[0]);
    final min = int.parse(hm[1]);
    final isPM = parts[1] == 'PM';

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: min);
  }

  // ---------------- COMMON PICKERS ----------------

  Future<void> selectAllStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: commonStartTime,
    );

    if (picked != null) {
      setState(() {
        commonStartTime = picked;
        for (var day in hours) {
          if (day['isOpen']) day['openTime'] = formatTimeOfDay(picked);
        }
      });
    }
  }

  Future<void> selectAllEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: commonEndTime,
    );

    if (picked != null) {
      setState(() {
        commonEndTime = picked;
        for (var day in hours) {
          if (day['isOpen']) day['closeTime'] = formatTimeOfDay(picked);
        }
      });
    }
  }

  // ---------------- SINGLE PICKER ----------------

  Future<void> pickTime(int index, bool isStart) async {
    if (!hours[index]['isOpen']) return;

    final current =
        isStart ? hours[index]['openTime'] : hours[index]['closeTime'];

    final initial =
        current != null
            ? parseTime(current)
            : (isStart ? commonStartTime : commonEndTime);

    final picked = await showTimePicker(context: context, initialTime: initial);

    if (picked != null) {
      setState(() {
        final t = formatTimeOfDay(picked);
        if (isStart) {
          hours[index]['openTime'] = t;
        } else {
          hours[index]['closeTime'] = t;
        }
      });
    }
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BusinessHoursProvider>();

    if (!_apiApplied && provider.businessHours.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        applyBusinessHours(provider.businessHours);
        _apiApplied = true;
      });
    }

    return Scaffold(
      appBar: appBarWithBackButton(context, "Business Hours"),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ----------- COMMON TIME -----------
                    Row(
                      children: const [
                        Expanded(child: TextWidget(text: "Select Start Time")),
                        Expanded(child: TextWidget(text: "Select End Time")),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: selectAllStartTime,
                            child: timeBox(formatTimeOfDay(commonStartTime)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: selectAllEndTime,
                            child: timeBox(formatTimeOfDay(commonEndTime)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ----------- DAYS -----------
                    Expanded(
                      child: ListView.builder(
                        itemCount: hours.length,
                        itemBuilder: (_, index) => dayRow(hours[index], index),
                      ),
                    ),

                    // ----------- SUBMIT -----------
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final ok = await provider.submitHours(userId!, hours);
                          if (ok) {
                            ToastificationShow.showToast(
                              context: context,
                              title: "Business Hours",
                              description: "Business Hours Added Successfully",
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("Continue"),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget dayRow(Map item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Switch(
            value: item['isOpen'],
            onChanged: (v) {
              setState(() {
                item['isOpen'] = v;

                if (!v) {
                  item['openTime'] = null;
                  item['closeTime'] = null;
                } else {
                  item['openTime'] ??= formatTimeOfDay(commonStartTime);
                  item['closeTime'] ??= formatTimeOfDay(commonEndTime);
                }
              });
            },
          ),
          Text(item['day'].toString().toUpperCase()),
          const Spacer(),
          timeChip(item, index, true),
          const SizedBox(width: 8),
          timeChip(item, index, false),
        ],
      ),
    );
  }

  Widget timeChip(Map item, int index, bool isStart) {
    return GestureDetector(
      onTap: () => pickTime(index, isStart),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          item['isOpen']
              ? (isStart ? item['openTime'] : item['closeTime']) ?? "Closed"
              : "Closed",
        ),
      ),
    );
  }

  Widget timeBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(value), const Icon(Icons.access_time, size: 18)],
      ),
    );
  }
}
