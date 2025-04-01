import 'package:flutter/material.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/utils/style_presets.dart';
import 'package:pobre_simulator/widgets/widget_utils.dart';

class SelectField extends StatefulWidget {
  final TextEditingController controller;
  final List<Category> list;
  const SelectField({
    super.key,
    required this.controller,
    required this.list,
  });

  @override
  State<SelectField> createState() => _SelectFieldState();
}

class _SelectFieldState extends State<SelectField> {
  int _selectedCategory = -1;

  @override
  void initState() {
    super.initState();

    widget.controller.text = widget.list[_selectedCategory].name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                canRequestFocus: false,
                controller: widget.controller,
                style: const TextStyle(color: StylePresets.cBlack),
                showCursor: false,
                onTap: () async {
                  _selectedCategory = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _SelectPage(items: widget.list),
                    ),
                  ) as int;
                },
                decoration: getInputDecoration(
                  label: 'Categoria',
                  fieldStyle: FieldStyle.normal,
                  pIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.list[_selectedCategory].color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(IconData(widget.list[_selectedCategory].icon, fontFamily: 'MaterialIcons')),
                    ),
                  ),
                  sIcon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectPage extends StatefulWidget {
  final List<Category> items;
  const _SelectPage({required this.items});

  @override
  State<_SelectPage> createState() => __SelectPageState();
}

class __SelectPageState extends State<_SelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione a categoria'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(widget.items[index].name),
                leading: Container(
                  decoration: BoxDecoration(color: widget.items[index].color, borderRadius: BorderRadius.circular(8)),
                  width: 45,
                  height: 45,
                  child: Icon(IconData(widget.items[index].icon, fontFamily: 'MaterialIcons')),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () => Navigator.pop(context, widget.items[index].id),
              ),
            ),
          )
        ],
      ),
    );
  }
}
