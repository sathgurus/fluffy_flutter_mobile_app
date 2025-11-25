import 'package:fluffy/modules/auth/register_business_screens/provider/business_hours_provider.dart';
import 'package:fluffy/modules/shared/appbar_widget.dart';
import 'package:fluffy/modules/shared/constant.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessHoursScreen extends StatefulWidget {
  const BusinessHoursScreen({super.key});
  @override
  State<BusinessHoursScreen> createState() => _BusinessHoursScreenState();
}

class _BusinessHoursScreenState extends State<BusinessHoursScreen> {
  TimeOfDay commonStartTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay commonEndTime = const TimeOfDay(hour: 20, minute: 0);

  // FORMAT TIME
  String formatTime(String? time) => time ?? "Closed";

  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  // Select ALL start time
  Future<void> selectAllStartTime(BuildContext context) async {
    final provider = Provider.of<BusinessHoursProvider>(context, listen: false);

    final picked = await showTimePicker(
      context: context,
      initialTime: commonStartTime,
    );

    if (picked != null) {
      setState(() => commonStartTime = picked);

      provider.applyStartTimeToAll(formatTimeOfDay(picked));
    }
  }

  // Select ALL end time
  Future<void> selectAllEndTime(BuildContext context) async {
    final provider = Provider.of<BusinessHoursProvider>(context, listen: false);

    final picked = await showTimePicker(
      context: context,
      initialTime: commonEndTime,
    );

    if (picked != null) {
      setState(() => commonEndTime = picked);

      provider.applyEndTimeToAll(formatTimeOfDay(picked));
    }
  }

  // Select individual start/end time
  Future<void> pickTime(BuildContext context, int index, bool isStart) async {
    final provider = Provider.of<BusinessHoursProvider>(context, listen: false);

    if (!provider.hours[index].isOpen) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) {
      final formatted = formatTimeOfDay(picked);

      if (isStart) {
        provider.updateOpenTime(index, formatted);
      } else {
        provider.updateCloseTime(index, formatted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BusinessHoursProvider>(context);
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

            Expanded(
              child: ListView.builder(
                itemCount: provider.hours.length,
                itemBuilder: (_, index) {
                  final item = provider.hours[index];
                  print("item $item");
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    //padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: item.isOpen,
                            onChanged: (v) => provider.toggleOpen(index, v),
                          ),
                        ),

                        Text(
                          item.day.toUpperCase(),
                          style: const TextStyle(
                            fontSize: textSizeSMedium,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        Spacer(),

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
                              item.isOpen ? item.openTime ?? "" : "Closed",
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
                              item.isOpen ? item.closeTime ?? "" : "Closed",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(onPressed: () {}, child: Text("Continue")),
          ],
        ),
      ),
    );
  }
}
