import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pobre_simulator/dao/category_dao.dart';
import 'package:pobre_simulator/model/category.dart';
import 'package:pobre_simulator/utils/style_presets.dart';
import 'package:pobre_simulator/view/category_page.dart';
import 'package:pobre_simulator/widgets/operation_select.dart';

class CategoriesListPage extends StatefulWidget {
  const CategoriesListPage({super.key});

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  final List<Category> _categories = [];
  CategoryType _type = CategoryType.expense;

  Future<void> _reload() async {
    final categories = await CategoryDAO().getCategories(_type);
    _categories.clear();
    _categories.addAll(categories);
    setState(() {});
  }

  Future<void> _changeType() async {
    _type = _type == CategoryType.expense ? CategoryType.receipt : CategoryType.expense;
    await _reload();
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await _reload();
      },
    );
  }

  Future<void> _showBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => CategoryPage(type: _type),
    );
  }

  Future<void> _editCategory(Category category) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => CategoryPage(category: category, type: category.type),
    );
    await _reload();
  }

  Future<bool> _deleteConfirmation(BuildContext context, Category category) async {
    return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Deletar categoria'),
              content: Text('Deseja mesmo deletar a categoria ${category.name}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: Column(
          children: [
            OperationSelect(
              operation: _type,
              onChanged: () async => await _changeType(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];

                  return Slidable(
                    key: Key(category.id.toString()),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            if (category.id == 1 || category.id == 2) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Não é possível deletar uma categoria básica.'),
                                ),
                              );
                              return;
                            }
                            final shouldDelete = await _deleteConfirmation(context, category);
                            if (shouldDelete) {
                              await CategoryDAO().deleteCategory(category.id);
                              await _reload();
                            }
                          },
                          backgroundColor: StylePresets.cRed,
                          foregroundColor: StylePresets.cWhite,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(category.name),
                      leading: CircleAvatar(
                        backgroundColor: category.color,
                        child: Icon(
                          IconData(category.icon, fontFamily: 'MaterialIcons'),
                          color: ThemeData.estimateBrightnessForColor(category.color) == Brightness.dark
                              ? StylePresets.cWhite
                              : StylePresets.cBlack,
                        ),
                      ),
                      onTap: () async => await _editCategory(category),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showBottomSheet();
          await _reload();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
