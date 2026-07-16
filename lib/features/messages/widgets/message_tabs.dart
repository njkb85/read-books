import 'package:flutter/material.dart';

class MessageTabs extends StatefulWidget {
  final Function(int)? onTabChanged;

  const MessageTabs({
    super.key,
    this.onTabChanged,
  });

  @override
  State<MessageTabs> createState() => _MessageTabsState();
}

class _MessageTabsState extends State<MessageTabs> {
  int _selectedIndex = 0;

  static const List<_TabItem> _tabs = [
    _TabItem(icon: Icons.mail_outline, label: 'No leídos'),
    _TabItem(icon: Icons.group_outlined, label: 'Grupos'),
    _TabItem(icon: Icons.person_add_outlined, label: 'Solicitudes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onTabChanged?.call(index);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _tabs[index].icon,
                        color: isSelected ? Colors.white : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _tabs[index].label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2,
                    width: isSelected ? 40 : 0,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFC96A2B) : Colors.transparent,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}
