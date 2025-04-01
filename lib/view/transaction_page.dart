import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pobre_simulator/controller/transaction_controller.dart';
import 'package:pobre_simulator/utils/style_presets.dart';
import 'package:pobre_simulator/widgets/buttons.dart';
import 'package:pobre_simulator/widgets/custom_text_field.dart';
import 'package:pobre_simulator/widgets/feedback_widgets.dart';
import 'package:pobre_simulator/widgets/operation_select.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    TransactionController control = context.read<TransactionController>();

    control.reset();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await control.init();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(builder: (context, controller, child) {
      return Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        StylePresets.cPrimaryColor,
                        StylePresets.cSecondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Expanded(
                            child: Text(
                              'New Transaction',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      TransactionTypeSelector(
                        initialType: controller.operation,
                        onChanged: (newType) {
                          setState(() => controller.setOperation(newType));
                        },
                      ),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Amount field
                        const Text(
                          'Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: controller.amountController,
                          label: 'Valor',
                          readOnly: true,
                          enabled: false,
                          inputType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // Categories
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: controller.categories.map((cat) {
                            final bool isSelected = cat.id == controller.categoryId;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  controller.setCategory(cat.id);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? cat.color.withAlpha(51) : StylePresets.cGreyAccent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isSelected ? Border.all(color: cat.color) : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      IconData(cat.icon, fontFamily: 'MaterialIcons'),
                                      color: isSelected ? cat.color : Colors.grey[800],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      cat.name,
                                      style: TextStyle(
                                        color: isSelected ? cat.color : Colors.grey[800],
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: controller.descController,
                          label: 'Descrição',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Date
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomDateField(
                          initialDate: controller.selectedDate,
                          onDateChanged: (value) {
                            setState(() {
                              controller.setDate(value);
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        ActionButton(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          label: 'Salvar',
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              await FeedbackWidgets.showProgressSnackBar(
                                context: context,
                                action: SnackbarAction.error,
                                message: 'Por favor, preencha todos os campos.',
                              );
                            } else if (controller.categoryId == 0) {
                              await FeedbackWidgets.showProgressSnackBar(
                                context: context,
                                action: SnackbarAction.error,
                                message: 'Por favor, selecione uma categoria.',
                              );
                            } else {
                              await controller.save().then((value) {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
