import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../auth/presentation/common/widgets/auth_button.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../bloc/device_bloc.dart';
import '../bloc/device_event.dart';
import '../bloc/device_state.dart';
import '../widgets/device_card_item.dart';
import '../widgets/device_search_bar.dart';

class SelectDeviceView extends StatelessWidget {
  const SelectDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceBloc(
        getDevicesUseCase: sl(),
      )..add(FetchDevicesEvent()),
      child: const _SelectDeviceViewContent(),
    );
  }
}

class _SelectDeviceViewContent extends StatelessWidget {
  const _SelectDeviceViewContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const CustomHeader(title: 'Select Device'),
              const SizedBox(height: 12),
              DeviceSearchBar(
                onChanged: (query) {
                  context.read<DeviceBloc>().add(SearchDevicesEvent(query));
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<DeviceBloc, DeviceState>(
                  builder: (context, state) {
                    if (state is DeviceLoading) {
                      return const Center(child: CircularIndicator());
                    } else if (state is DeviceLoaded) {
                      if (state.filteredDevices.isEmpty) {
                        return const Center(child: Text('No devices found'));
                      }
                      return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: state.filteredDevices.length,
                        itemBuilder: (context, index) {
                          final device = state.filteredDevices[index];
                          return DeviceCardItem(
                            device: device,
                            onTap: () {
                            },
                          );
                        },
                      );
                    } else if (state is DeviceError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 50),
        child: AuthButton(
          title: 'Next',
          onTap: () {
          },
        ),
      ),
    );
  }
}

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(color: Color(0xFF2563EB));
  }
}