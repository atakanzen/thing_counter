import 'package:flutter/material.dart';
import 'package:thing_counter/services/notification_service.dart';

import '../models/thing.dart';
import '../widgets/create_thing_section.dart';
import '../widgets/dark_mode_switch.dart';
import '../widgets/thing_list_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool showCreateSection = false;
  final List<Thing> things = [];
  final NotificationService _notificationService = NotificationService();

  void openCreateSection() {
    setState(() {
      showCreateSection = true;
    });
  }

  void closeCreateSection() {
    setState(() {
      showCreateSection = false;
    });
  }

  void addThing(String title, int? goal) {
    setState(() {
      things.add(Thing(title: title, goal: goal));
    });
    closeCreateSection();
  }

  void incrementCount(int index) {
    setState(() {
      final thing = things[index];
      if (thing.goal == null || thing.count < thing.goal!) {
        thing.count++;
      } else {
        // Optionally, show a message if the count cannot be incremented
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${thing.title} has reached its goal of ${thing.goal}.'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void decrementCount(int index) {
    setState(() {
      if (things[index].count > 0) {
        things[index].count--;
      }
    });
  }

  void showReminderModal(BuildContext context, int index) {
    final TextEditingController intervalController = TextEditingController();
    String selectedUnit = 'minutes';

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Set Reminder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: intervalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Remind every'),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedUnit,
                onChanged: (value) {
                  setState(() {
                    selectedUnit = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: 'minutes', child: Text('Minutes')),
                  DropdownMenuItem(value: 'hours', child: Text('Hours')),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final interval =
                          int.tryParse(intervalController.text) ?? 0;
                      if (interval > 0) {
                        final scheduledTime = DateTime.now().add(
                          selectedUnit == 'minutes'
                              ? Duration(minutes: interval)
                              : Duration(hours: interval),
                        );

                        _notificationService.scheduleNotification(
                          id: index,
                          title: 'Reminder for ${things[index].title}',
                          body: 'It’s time to update the count!',
                          scheduledTime: scheduledTime,
                        );

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Set'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void deleteThing(int index) {
    setState(() {
      things.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thing Counter'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (showCreateSection)
            CreateThingSection(
              onCancel: closeCreateSection,
              onCreate: addThing,
            ),
          Expanded(
            child: ThingListView(
              things: things,
              onIncrement: incrementCount,
              onDecrement: decrementCount,
              onSetReminder: showReminderModal,
              onDelete: deleteThing,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: openCreateSection,
              child: const Icon(Icons.add),
            ),
            const DarkModeSwitch(),
          ],
        ),
      ),
    );
  }
}
