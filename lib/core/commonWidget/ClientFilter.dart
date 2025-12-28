import 'package:flutter/material.dart';

class CommonFilterWidget<T> extends StatefulWidget {
  final List<T> statusOptions;
  final String Function(T) statusLabel;
  final Function(String, DateTimeRange?, T?) onFilterChanged;

  const CommonFilterWidget({
    super.key,
    required this.statusOptions,
    required this.statusLabel,
    required this.onFilterChanged,
  });

  @override
  State<CommonFilterWidget<T>> createState() => _CommonFilterWidgetState<T>();
}

class _CommonFilterWidgetState<T> extends State<CommonFilterWidget<T>> {
  String selectedDateFilter = "All";
  DateTimeRange? selectedDateRange;
  T? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _dateChip("All"),
              _dateChip("Today"),
              _dateChip("This Week"),
              ActionChip(
                label: const Text("Custom"),
                onPressed: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2100),
                  );
                  if (range != null) {
                    setState(() {
                      selectedDateFilter = "Custom";
                      selectedDateRange = range;
                    });
                    _notify();
                  }
                },
              ),
            ],
          ),

          const SizedBox(width: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                widget.statusOptions.map((status) {
                  return FilterChip(
                    label: Text(widget.statusLabel(status)),
                    selected: selectedStatus == status,
                    onSelected: (selected) {
                      setState(() {
                        selectedStatus = selected ? status : null;
                      });
                      _notify();
                    },
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _dateChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedDateFilter == label,
      onSelected: (_) {
        setState(() {
          selectedDateFilter = label;
          if (label != "Custom") selectedDateRange = null;
        });
        _notify();
      },
    );
  }

  void _notify() {
    widget.onFilterChanged(
      selectedDateFilter,
      selectedDateRange,
      selectedStatus,
    );
  }
}
