import 'package:flutter/material.dart';
import 'package:pobre_simulator/config/appdata.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

class IconPicker extends StatefulWidget {
  final Color selectedColor;
  final IconData initialIcon;
  final int rows;
  final ValueChanged<IconData> onChanged;

  const IconPicker({
    super.key,
    required this.selectedColor,
    required this.initialIcon,
    this.rows = 2,
    required this.onChanged,
  });

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  late IconData _selectedIcon;
  final ScrollController _scrollController = ScrollController();

  final List<IconData> _icons = [
    AppData.iconPickerInitialIcon,
    Icons.home_rounded,
    Icons.settings_rounded,
    Icons.favorite_rounded,
    Icons.storefront_rounded,
    Icons.local_shipping_rounded,
    Icons.pets_rounded,
    Icons.cake_rounded,
    Icons.ac_unit_rounded,
    Icons.account_balance_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.ads_click_rounded,
    Icons.airplane_ticket_rounded,
    Icons.yard_rounded,
    Icons.workspace_premium_rounded,
    Icons.work_outline_rounded,
    Icons.wifi_rounded,
    Icons.payment_rounded,
    Icons.payments_rounded,
    Icons.local_play_rounded,
    Icons.shopping_bag_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.initialIcon;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToSelectedColor(),
    );
  }

  void _changeIcon(IconData icon) {
    setState(() {
      _selectedIcon = icon;
    });
    widget.onChanged(icon);
  }

  void _scrollToSelectedColor() {
    final index = _icons.indexWhere((icon) => icon == _selectedIcon);
    if (index != -1) {
      double itemSize = 50;
      double offset = index * itemSize;

      _scrollController.animateTo(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        offset.clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        ),
      );
    }
  }

  Color _getIconColor(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.dark ? StylePresets.cWhite : StylePresets.cBlack;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (50 * widget.rows).toDouble(),
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _icons.length,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.rows,
          mainAxisSpacing: widget.rows * 2,
          crossAxisSpacing: widget.rows * 2,
        ),
        itemBuilder: (context, index) {
          final icon = _icons[index];
          final isSelected = _selectedIcon == icon;
          final backgroundColor = isSelected ? widget.selectedColor : Colors.grey.shade300;
          final iconColor = _getIconColor(backgroundColor);

          return InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () => _changeIcon(icon),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
