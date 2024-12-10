class Thing {
  final String title;
  final int? goal;
  int count;
  Duration? reminderInterval;

  Thing(
      {required this.title, this.goal, this.count = 0, this.reminderInterval});
}
