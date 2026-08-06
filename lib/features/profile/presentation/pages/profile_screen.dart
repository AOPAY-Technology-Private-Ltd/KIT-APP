import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes/route_names.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/kit_balance_card.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_menu_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOutState) {
            context.go(RouteNames.login);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            );
          }
          if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }
          if (state is ProfileLoaded) {
            final profile = state.profile;

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeader(
                      title: 'Profile',
                      showBackButton: false,
                      showSearch: true,
                    ),
                    const SizedBox(height: 20),

                    ProfileInfoCard(
                      profile: profile,
                      onEditPressed: () {},
                    ),

                    const SizedBox(height: 16),
                    KitBalanceCard(profile: profile),
                    const SizedBox(height: 20),
                    ProfileMenuGroup(
                      title: 'Business',
                      items: [
                        MenuConfig(
                          title: 'Shop Details',
                          iconCode: '#08',
                          onTap: () {},
                        ),
                        MenuConfig(title: 'GST', iconCode: '#08', onTap: () {}),
                        MenuConfig(title: 'KYC', iconCode: '#08', onTap: () {}),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ProfileMenuGroup(
                      title: 'Preferences',
                      items: [
                        MenuConfig(
                          title: 'Notifications',
                          iconCode: '#08',
                          onTap: () {
                            context.push(RouteNames.notification);
                          },
                        ),
                        MenuConfig(
                          title: 'Settings',
                          iconCode: '#08',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ProfileMenuGroup(
                      title: 'Support',
                      items: [
                        MenuConfig(
                          title: 'Help & FAQ',
                          iconCode: '#08',
                          onTap: () {},
                        ),
                        MenuConfig(
                          title: 'Contact Support',
                          iconCode: '#08',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          context.read<ProfileBloc>().add(LogoutEvent());
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}