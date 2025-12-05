import 'package:flutter/material.dart';
import '../models/script_project.dart';

class ScriptViewScreen extends StatelessWidget {
  final ScriptProject project;

  const ScriptViewScreen({super.key, required this.project});

  String _generateMockScript() {
    // This is a mock generator that creates a template based on inputs.
    // In a real app, this would call an LLM API.
    
    final sb = StringBuffer();
    
    sb.writeln("TITLE: ${project.topic.toUpperCase()} - ${project.segmentType.toUpperCase()}");
    sb.writeln("DURATION: ~${project.targetDuration} minutes");
    sb.writeln("TONE: ${project.style}");
    sb.writeln("\n---\n");

    // Hook
    sb.writeln("[0:00-0:30] THE HOOK");
    sb.writeln("VISUAL: Fast-paced montage of images related to ${project.topic}. Sudden cut to black.");
    sb.writeln("AUDIO (${project.style}): \"Have you ever wondered why ${project.topic} is suddenly all over the news? I certainly did. And what I found changed everything I thought I knew.\"");
    sb.writeln("\n");

    // Introduction / Context
    sb.writeln("[0:30-1:00] THE CONTEXT");
    sb.writeln("VISUAL: You talking to camera, walking down a busy street or sitting in a cluttered study.");
    sb.writeln("AUDIO: \"I'm a university student, just like many of you. But when I started digging into ${project.topic}, I realized this isn't just a textbook problem.\"");
    sb.writeln("\n");

    // Points
    for (int i = 0; i < project.researchPoints.length; i++) {
      final point = project.researchPoints[i];
      sb.writeln("[1:00-${1.0 + (i * 0.5)}] POINT ${i + 1}");
      sb.writeln("VISUAL: Infographic showing statistics about '$point'. Overlay text pops up.");
      sb.writeln("AUDIO: \"Let's look at the facts. Specifically, $point. It's startling when you see the numbers laid out like this.\"");
      sb.writeln("\n");
    }

    // Conclusion
    sb.writeln("[END] WRAP UP");
    sb.writeln("VISUAL: Slow zoom out or drone shot.");
    sb.writeln("AUDIO: \"This is just the beginning. In the next segment, we'll dive even deeper. Stay tuned.\"");

    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    final scriptContent = _generateMockScript();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Script'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Script copied to clipboard (Mock)')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Project Details",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    Text("Topic: ${project.topic}"),
                    Text("Segment: ${project.segmentType}"),
                    Text("Style: ${project.style}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Script Draft",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                scriptContent,
                style: const TextStyle(
                  fontFamily: 'Courier', // Monospace for script feel
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
