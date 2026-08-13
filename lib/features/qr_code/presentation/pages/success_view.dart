import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InstallSuccessView extends StatelessWidget {
  const InstallSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ..._buildDecorativeDots(),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              const Text(
                'Lockit Install\nSuccessfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 28,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: Container(
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(1.00, 0.50),
                      end: Alignment(0.00, 0.50),
                      colors: [Color(0xFF022062), Color(0xFF008EFD)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {

                      context.pop();
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDecorativeDots() {
    final List<Map<String, double>> dotPositions = [
      {'top': 20, 'left': 90, 'size': 8},
      {'top': 40, 'left': 140, 'size': 6},
      {'top': 90, 'left': 160, 'size': 10},
      {'top': 130, 'left': 140, 'size': 8},
      {'top': 150, 'left': 90, 'size': 6},
      {'top': 140, 'left': 40, 'size': 8},
      {'top': 90, 'left': 20, 'size': 6},
      {'top': 40, 'left': 40, 'size': 8},
    ];

    return dotPositions.map((pos) {
      return Positioned(
        top: pos['top']!,
        left: pos['left']!,
        child: Container(
          width: pos['size']!,
          height: pos['size']!,
          decoration: const BoxDecoration(
            color: Color(0xFF34D399),
            shape: BoxShape.circle,
          ),
        ),
      );
    }).toList();
  }
}