import 'package:flutter/material.dart';
import '../models/script_project.dart';
import 'script_view_screen.dart';

class CreateScriptScreen extends StatefulWidget {
  const CreateScriptScreen({super.key});

  @override
  State<CreateScriptScreen> createState() => _CreateScriptScreenState();
}

class _CreateScriptScreenState extends State<CreateScriptScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  final TextEditingController _topicController = TextEditingController();
  String _selectedSegment = 'Introduction';
  double _targetDuration = 2.5;
  String _selectedStyle = 'Energetic';
  
  // Dynamic research points
  final List<TextEditingController> _pointControllers = [TextEditingController()];

  final List<String> _segmentTypes = [
    'Introduction',
    'Context',
    'Main Point',
    'Solutions',
    'Conclusion',
  ];

  final List<String> _styles = [
    'Energetic',
    'Serious',
    'Skeptical',
    'Passionate',
    'Conversational',
  ];

  @override
  void dispose() {
    _topicController.dispose();
    for (var controller in _pointControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addPoint() {
    setState(() {
      _pointControllers.add(TextEditingController());
    });
  }

  void _removePoint(int index) {
    if (_pointControllers.length > 1) {
      setState(() {
        _pointControllers[index].dispose();
        _pointControllers.removeAt(index);
      });
    }
  }

  void _generateScript() {
    if (_formKey.currentState!.validate()) {
      // Collect data
      List<String> points = _pointControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      if (points.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one research point')),
        );
        return;
      }

      final project = ScriptProject(
        topic: _topicController.text,
        segmentType: _selectedSegment,
        targetDuration: _targetDuration,
        researchPoints: points,
        style: _selectedStyle,
      );

      // Navigate to result
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScriptViewScreen(project: project),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Script Segment'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Section 1: Basics
            Text(
              "Project Basics",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _topicController,
              decoration: const InputDecoration(
                labelText: 'Social Issue / Topic',
                hintText: 'e.g., Climate Change, Digital Privacy',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.topic),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a topic';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedSegment,
              decoration: const InputDecoration(
                labelText: 'Segment Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _segmentTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSegment = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Duration Slider
            Text("Target Duration: ${_targetDuration.toStringAsFixed(1)} minutes"),
            Slider(
              value: _targetDuration,
              min: 1.0,
              max: 10.0,
              divisions: 18,
              label: "${_targetDuration.toStringAsFixed(1)} min",
              onChanged: (double value) {
                setState(() {
                  _targetDuration = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Section 2: Research Points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Research Points",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: Theme.of(context).primaryColor,
                  onPressed: _addPoint,
                  tooltip: 'Add Point',
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._pointControllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Point ${index + 1}',
                          hintText: 'Fact, statistic, or example...',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (index == 0 && (value == null || value.isEmpty)) {
                            return 'Please add at least one point';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (_pointControllers.length > 1)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removePoint(index),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Section 3: Style
            Text(
              "Personality / Style",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _styles.map((style) {
                return ChoiceChip(
                  label: Text(style),
                  selected: _selectedStyle == style,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _selectedStyle = style;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _generateScript,
                icon: const Icon(Icons.auto_awesome),
                label: const Text(
                  'GENERATE SCRIPT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
