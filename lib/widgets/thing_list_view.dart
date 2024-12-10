import 'package:flutter/material.dart';

import '../models/thing.dart';

class ThingListView extends StatelessWidget {
  final List<Thing> things;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final Function(BuildContext, int) onSetReminder;
  final Function(int) onDelete;

  const ThingListView(
      {super.key,
      required this.things,
      required this.onIncrement,
      required this.onDecrement,
      required this.onSetReminder,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return things.isEmpty
        ? const Center(child: Text('No things to count yet.'))
        : ListView.builder(
            itemCount: things.length,
            itemBuilder: (context, index) {
              final thing = things[index];
              final progress = thing.goal != null && thing.goal! > 0
                  ? thing.count / thing.goal!
                  : null;

              return ListTile(
                title: Text(thing.title),
                subtitle: progress != null
                    ? LinearProgressIndicator(value: progress)
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => onDecrement(index),
                      icon: const Icon(Icons.remove),
                    ),
                    Text('${thing.count}'),
                    IconButton(
                      onPressed: () => onIncrement(index),
                      icon: const Icon(Icons.add),
                    ),
                    IconButton(
                      onPressed: () => onSetReminder(context, index),
                      icon: const Icon(Icons.notifications),
                    ),
                    IconButton(
                        onPressed: () => onDelete(index),
                        icon: const Icon(Icons.delete_forever))
                  ],
                ),
              );
            },
          );
  }
}
