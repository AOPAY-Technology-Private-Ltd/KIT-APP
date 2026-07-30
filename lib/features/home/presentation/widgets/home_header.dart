import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String code;

  const HomeHeader({
    super.key,
    required this.name,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth > 600;

        final double horizontalPadding = isTablet ? constraints.maxWidth * 0.06 : constraints.maxWidth * 0.04;
        final double avatarRadius = isTablet ? 30 : 25;

        final double nameFontSize = isTablet ? 22 : 18;
        final double nameWidth = isTablet ? 180 : 132;

        final double codeFontSize = isTablet ? 14 : 11;
        final double codeWidth = isTablet ? 180 : 132;

        final double iconSize = isTablet ? 20 : 16;
        final double iconContainerSize = isTablet ? 38 : 32;

        return Container(
          height: 145,
          width: double.infinity,
          padding: EdgeInsets.only(
            top: topPadding + 12,
            left: horizontalPadding,
            right: horizontalPadding,
            bottom: 12,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF2563EB),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Colors.white,
                          backgroundImage: const NetworkImage(
                            "https://placehold.co/50x50",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: nameWidth,
                                child: Text(
                                  name.isEmpty ? "Retailer Name" : name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: nameFontSize,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: codeWidth,
                                child: Text(
                                  code.isEmpty ? "Retailer Code" : code,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: codeFontSize,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _iconButton(Icons.notifications_none, iconSize, iconContainerSize),
                      const SizedBox(width: 8),
                      _iconButton(Icons.search, iconSize, iconContainerSize),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }

  Widget _iconButton(IconData icon, double iconSize, double containerSize) {
    return Container(
      height: containerSize,
      width: containerSize,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: const Color(0xFF2563EB),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(145);
}