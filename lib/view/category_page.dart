import 'package:flutter/material.dart';
import 'package:pobre_simulator/controller/category_controller.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/utils/style_presets.dart';
import 'package:pobre_simulator/widgets/buttons.dart';
import 'package:pobre_simulator/widgets/color_picker.dart';
import 'package:pobre_simulator/widgets/custom_text_field.dart';
import 'package:pobre_simulator/widgets/icon_picker.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  final CategoryType type;
  final Category? category;
  const CategoryPage({
    super.key,
    this.category,
    required this.type,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    context.read<CategoryController>().init(category: widget.category, type: widget.type);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(builder: (context, controller, child) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Nova ${controller.type == CategoryType.expense ? 'Despesa' : 'Receita'}',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: CustomTextField(
                  label: 'Nome',
                  controller: controller.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8),
              _ListDecoration(
                widget: ColorPicker(
                  initialColor: controller.color,
                  onChanged: (value) => controller.changeColor(value),
                ),
              ),
              SizedBox(height: 8),
              _ListDecoration(
                widget: IconPicker(
                  rows: 1,
                  selectedColor: controller.color,
                  initialIcon: controller.icon,
                  onChanged: (value) => controller.changeIcon(value.codePoint),
                ),
              ),
              const SizedBox(height: 8),
              BottomButton(
                label: 'Salvar',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await controller.save().then(
                      (value) {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      );
    });
  }
}

class _ListDecoration extends StatelessWidget {
  final Widget widget;
  const _ListDecoration({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          color: StylePresets.cWhite,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: StylePresets.cWhiteAccent,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            widget,
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
