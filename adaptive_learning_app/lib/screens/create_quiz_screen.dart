import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';

class CreateQuestionScreen extends StatefulWidget {
  const CreateQuestionScreen({super.key});

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _optionControllers = List.generate(4, (index) => TextEditingController());
  
  String _selectedDifficulty = 'easy';
  String _selectedType = 'MCQ';
  int _correctIndex = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Question'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Question Type', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'MCQ', child: Text('Multiple Choice')),
                  DropdownMenuItem(value: 'TF', child: Text('True / False')),
                  DropdownMenuItem(value: 'DRAG_DROP', child: Text('Drag & Drop (Ordering)')),
                ],
                onChanged: (val) => setState(() {
                  _selectedType = val!;
                  if (_selectedType == 'TF') {
                    _optionControllers[0].text = 'True';
                    _optionControllers[1].text = 'False';
                  }
                }),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: const InputDecoration(labelText: 'Difficulty', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'easy', child: Text('Easy')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'hard', child: Text('Hard')),
                ],
                onChanged: (val) => setState(() => _selectedDifficulty = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Question Title / Prompt', border: OutlineInputBorder()),
                maxLines: 2,
                validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 24),
              if (_selectedType == 'MCQ' || _selectedType == 'DRAG_DROP') ...[
                const Text('Options (For Drag & Drop, enter in correct order)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...List.generate(4, (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Option ${String.fromCharCode(65 + index)}',
                      border: const OutlineInputBorder(),
                      suffixIcon: _selectedType == 'MCQ' ? Radio<int>(
                        value: index,
                        groupValue: _correctIndex,
                        onChanged: (val) => setState(() => _correctIndex = val!),
                      ) : null,
                    ),
                    validator: (val) => (_selectedType == 'MCQ' || index < 4) && val!.isEmpty ? 'Required' : null,
                  ),
                )),
              ] else if (_selectedType == 'TF') ...[
                const Text('Select Correct Answer', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<int>(
                        title: const Text('True'),
                        value: 0,
                        groupValue: _correctIndex,
                        onChanged: (val) => setState(() => _correctIndex = val!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<int>(
                        title: const Text('False'),
                        value: 1,
                        groupValue: _correctIndex,
                        onChanged: (val) => setState(() => _correctIndex = val!),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Question', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final question = Question(
        title: _titleController.text,
        difficulty: _selectedDifficulty,
        type: _selectedType,
        options: _optionControllers.map((c) => c.text).toList(),
        correctIndex: _correctIndex,
      );
      await ApiService.createQuestion(question);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Question created successfully!')));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
