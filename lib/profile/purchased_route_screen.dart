import 'package:flutter/material.dart';
import '../../disign/colors.dart';

class RouteStep {
  final String type; // guide / exhibit
  final String title;
  final String description;
  final String imageUrl;

  RouteStep({
    required this.type,
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class PurchasedRouteScreen extends StatefulWidget {
  final String routeTitle;
  final List<RouteStep> steps;

  const PurchasedRouteScreen({
    super.key,
    required this.routeTitle,
    required this.steps,
  });

  @override
  State<PurchasedRouteScreen> createState() => _PurchasedRouteScreenState();
}

class _PurchasedRouteScreenState extends State<PurchasedRouteScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _goToPage(int index) {
    if (index < 0 || index >= widget.steps.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    setState(() => _currentIndex = index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.whiteGrey,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 280,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) =>
                            setState(() => _currentIndex = index),
                        itemCount: widget.steps.length,
                        itemBuilder: (_, index) {
                          final item = widget.steps[index];
                          return Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CircleAvatar(
                        radius: 23,
                        backgroundColor: AppColors.whiteGrey,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.dark,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _NavArrowButton(
                            icon: Icons.arrow_back_ios_new,
                            onTap: _currentIndex == 0
                                ? null
                                : () => _goToPage(_currentIndex - 1),
                          ),
                          _NavArrowButton(
                            icon: Icons.arrow_forward_ios,
                            onTap: _currentIndex == widget.steps.length - 1
                                ? null
                                : () => _goToPage(_currentIndex + 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                    decoration: const BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          step.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              step.description,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.45,
                                color: AppColors.dark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _StepDotsBar(
                          steps: widget.steps,
                          currentIndex: _currentIndex,
                          onTapDot: _goToPage,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 92,
              left: 0,
              right: 0,
              child: Center(
                child: _FloatingStepCard(
                  type: step.type,
                  text: step.type == 'guide' ? 'Указатель' : 'Экспонат',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _NavArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: enabled ? AppColors.orange : AppColors.navy.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.whiteGrey, size: 18),
      ),
    );
  }
}

class _StepDotsBar extends StatelessWidget {
  final List<RouteStep> steps;
  final int currentIndex;
  final ValueChanged<int> onTapDot;

  const _StepDotsBar({
    required this.steps,
    required this.currentIndex,
    required this.onTapDot,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final active = index == currentIndex;
          return GestureDetector(
            onTap: () => onTapDot(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: active ? AppColors.orange : AppColors.whiteGrey,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active ? AppColors.orange : AppColors.lightGrey,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: active ? 16 : 10,
                    height: active ? 16 : 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? AppColors.whiteGrey : AppColors.navy,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: active ? AppColors.whiteGrey : AppColors.dark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FloatingStepCard extends StatelessWidget {
  final String type;
  final String text;

  const _FloatingStepCard({required this.type, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = type == 'guide' ? AppColors.blue : AppColors.orange;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
