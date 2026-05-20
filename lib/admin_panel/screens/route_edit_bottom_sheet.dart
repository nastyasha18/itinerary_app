import 'package:flutter/material.dart';
import '../../disign/colors.dart';

class RouteEditBottomSheet extends StatefulWidget {
  final int initialId;              // добавлено
  final String initialTitle;
  final String initialPrice;
  final String initialDescription;
  final String? initialImagePath;
  final List<String> initialSteps;

  const RouteEditBottomSheet({
    super.key,
    required this.initialId,       // добавлено
    required this.initialTitle,
    required this.initialPrice,
    required this.initialDescription,
    required this.initialImagePath,
    required this.initialSteps,
  });

  @override
  State<RouteEditBottomSheet> createState() => _RouteEditBottomSheetState();
}

class _RouteEditBottomSheetState extends State<RouteEditBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;
  late final TextEditingController _audienceController;

  final List<TextEditingController> _routeStepControllers = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
    _priceController = TextEditingController(text: widget.initialPrice);
    _durationController = TextEditingController(text: '1.5 часа');
    _audienceController = TextEditingController(text: 'Семьи, взрослые');

    if (widget.initialSteps.isEmpty) {
      _routeStepControllers.add(TextEditingController());
    } else {
      for (final step in widget.initialSteps) {
        _routeStepControllers.add(TextEditingController(text: step));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _audienceController.dispose();
    for (final controller in _routeStepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addStep() {
    setState(() {
      _routeStepControllers.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    if (_routeStepControllers.length == 1) return;
    setState(() {
      _routeStepControllers[index].dispose();
      _routeStepControllers.removeAt(index);
    });
  }

  void _saveRoute() {
    final steps = _routeStepControllers
        .map((e) => e.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final result = {
      'title': _titleController.text.trim().isEmpty
          ? widget.initialTitle
          : _titleController.text.trim(),
      'description': _descriptionController.text.trim().isEmpty
          ? widget.initialDescription
          : _descriptionController.text.trim(),
      'price': _priceController.text.trim().isEmpty
          ? widget.initialPrice
          : _priceController.text.trim(),
      'duration': _durationController.text.trim(),
      'audience': _audienceController.text.trim(),
      'imagePath': widget.initialImagePath,
      'steps': steps,
    };

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.70,
      maxChildSize: 0.98,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: bottomInset + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Редактирование маршрута',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Как будет выглядеть маршрут при прохождении'),
                  const SizedBox(height: 12),
                  _placeholderImageBlock(),
                  const SizedBox(height: 12),
                  _input(
                    controller: _titleController,
                    label: 'Название маршрута',
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 12),
                  _input(
                    controller: _descriptionController,
                    label: 'Описание маршрута',
                    icon: Icons.description_outlined,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _input(
                          controller: _durationController,
                          label: 'Длительность',
                          icon: Icons.access_time,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _input(
                          controller: _audienceController,
                          label: 'Аудитория',
                          icon: Icons.groups,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _input(
                    controller: _priceController,
                    label: 'Цена',
                    icon: Icons.payments_outlined,
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Точки маршрута'),
                  const SizedBox(height: 10),
                  ...List.generate(_routeStepControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: _input(
                              controller: _routeStepControllers[index],
                              label: 'Точка ${index + 1}',
                              icon: Icons.location_on_outlined,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _removeStep(index),
                            child: Container(
                              width: 48,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _addStep,
                      icon: const Icon(Icons.add, color: AppColors.orange),
                      label: const Text(
                        'Добавить точку',
                        style: TextStyle(color: AppColors.orange),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.orange),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _saveRoute,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Сохранить изменения'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.dark,
      ),
    );
  }

  Widget _placeholderImageBlock() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.orange.withOpacity(0.25)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, color: AppColors.orange, size: 42),
          SizedBox(height: 10),
          Text('Заглушка фото', style: TextStyle(color: AppColors.navy)),
          SizedBox(height: 4),
          Text(
            'Фото будут подгружаться позже',
            style: TextStyle(color: AppColors.dark, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.navy),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
