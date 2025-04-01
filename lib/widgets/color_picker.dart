import 'package:flutter/material.dart';
import 'package:pobre_simulator/config/appdata.dart';
import 'package:pobre_simulator/utils/color_utils.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

class ColorPicker extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<int> onChanged;

  const ColorPicker({
    super.key,
    required this.initialColor,
    required this.onChanged,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color _selectedColor = AppData.colorPickerInitialColor;
  final ScrollController _scrollController = ScrollController();

  final List<Color> _colors = [
    AppData.colorPickerInitialColor,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.green,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.lime,
    Colors.limeAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.amber,
    Colors.amberAccent,
    Colors.cyan,
    Colors.cyanAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.red,
    Colors.redAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.teal,
    Colors.tealAccent,
    StylePresets.cWhite,
    Colors.brown,
    Colors.black,
    Colors.blueGrey,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToSelectedColor(),
    );
  }

  void _scrollToSelectedColor() {
    final index = _colors.indexWhere((c) => c.toInt() == _selectedColor.toInt());
    if (index != -1) {
      double itemSize = 25;
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

  void _changeColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
    widget.onChanged(color.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _colors.length,
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          final color = _colors[index];
          final isSelected = color.toInt() == _selectedColor.toInt();
          final iconColor = ColorUtils.getIconColor(color);

          return InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () => _changeColor(color),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: color == StylePresets.cWhite ? Colors.grey.shade300 : StylePresets.cWhite,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Visibility(
                visible: isSelected,
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  size: 38,
                  color: iconColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
