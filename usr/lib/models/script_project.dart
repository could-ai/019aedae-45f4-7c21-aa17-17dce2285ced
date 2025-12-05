class ScriptProject {
  String topic;
  String segmentType;
  double targetDuration; // in minutes
  List<String> researchPoints;
  String style;

  ScriptProject({
    required this.topic,
    required this.segmentType,
    this.targetDuration = 2.5,
    required this.researchPoints,
    required this.style,
  });
}
