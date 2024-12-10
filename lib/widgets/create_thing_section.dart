import 'package:flutter/material.dart';

class CreateThingSection extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(String, int?) onCreate;

  const CreateThingSection({
    super.key,
    required this.onCancel,
    required this.onCreate,
  });

  @override
  State<CreateThingSection> createState() => _CreateThingSectionState();
}

class _CreateThingSectionState extends State<CreateThingSection> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  bool hasGoal = false;

  void resetInputs() {
    titleController.clear();
    goalController.clear();
    setState(() {
      hasGoal = false;
    });
    widget.onCancel();
  }

  void handleCreate() {
    final title = titleController.text.trim();
    final goal = hasGoal ? int.tryParse(goalController.text) : null;

    if (title.isNotEmpty) {
      widget.onCreate(title, goal);
      resetInputs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Title Input Field
              Expanded(
                flex: 2,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Goal Input Field (Visible only if `hasGoal` is true)
              if (hasGoal)
                Expanded(
                  child: TextField(
                    controller: goalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Goal',
                    ),
                  ),
                ),
              if (hasGoal) const SizedBox(width: 16),
              // Checkbox for Has Goal
              Row(
                children: [
                  Checkbox(
                    value: hasGoal,
                    onChanged: (value) {
                      setState(() {
                        hasGoal = value!;
                      });
                    },
                  ),
                  const Text('Has Goal'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Save and Cancel Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: resetInputs,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: handleCreate,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
