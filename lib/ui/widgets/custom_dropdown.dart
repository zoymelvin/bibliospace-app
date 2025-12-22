import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blue[900]),
          ),
          iconSize: 20,
          isDense: true,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: Colors.white,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    _getIconForValue(value),
                    size: 16,
                    color: Colors.blue[900],
                  ),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getIconForValue(String value) {
    switch (value) {
      case 'Terbaru':
        return Icons.access_time_rounded;
      case 'Terendah':
        return Icons.arrow_downward_rounded;
      case 'Tertinggi':
        return Icons.arrow_upward_rounded;
      default:
        return Icons.filter_list;
    }
  }
}