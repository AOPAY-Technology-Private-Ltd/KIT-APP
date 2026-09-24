import 'package:flutter/material.dart';

class StepProgressHeader extends StatelessWidget {
  final int currentStep;

  const StepProgressHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final List<String> steps = [
      'Documents',
      'Basic Detail',
      'Loan Detail',
      'Bank Detail',
      'E-NACH',
      'Reference',
      'Terms & Condition',
      'Loan Disbursed'
    ];

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isEven) {
              int stepIndex = index ~/ 2;
              bool isActive = (stepIndex + 1) == currentStep;
              bool isCompleted = (stepIndex + 1) < currentStep;
              return _buildStepItem(steps[stepIndex], isActive, isCompleted);
            } else {
              return _buildStepLine(isCompleted: (index ~/ 2 + 1) < currentStep);
            }
          }),
        ),
      ),
    );
  }

  Widget _buildStepItem(String title, bool isActive, bool isCompleted) {
    final bool isHighlighted = isActive || isCompleted;

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isHighlighted ? const Color(0xFF10B981) : Colors.white,
            border: Border.all(
              color: isHighlighted
                  ? Colors.transparent
                  : Colors.black.withValues(alpha: 0.50),
              width: 1,
            ),
          ),
          child: isActive
              ? Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          )
              : isCompleted
              ? const Center(
            child: Icon(Icons.check, size: 14, color: Colors.white),
          )
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF022062) : Colors.grey.shade600,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool isCompleted}) {
    return Container(
      width: 20,
      height: 2,
      color: isCompleted ? const Color(0xFF10B981) : Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
    );
  }
}