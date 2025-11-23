import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leaptech_plus/core/functions/get_current_date.dart';
import 'package:leaptech_plus/core/functions/get_current_user.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/core/widgets/app_card.dart';
import 'package:leaptech_plus/features/home/presentation/cubits/cubit/home_cubit.dart';
import 'package:leaptech_plus/features/home/presentation/widgets/home_date_card.dart';
import 'package:leaptech_plus/features/home/presentation/widgets/home_good_morning_card.dart';
import 'package:leaptech_plus/features/home/presentation/widgets/home_qoute_card.dart';
import 'package:leaptech_plus/features/home/presentation/widgets/upcoming_event_card.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeCubit>();
    // Use addPostFrameCallback to avoid context issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.getQuoteOfTheDay();
      cubit.getAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 10.h),
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: () async {
              final cubit = context.read<HomeCubit>();
              cubit.getQuoteOfTheDay();
              cubit.getAllEvents();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeGoodMorningCard(
                    name: getCurrentUser()!.fullName ?? 'No name ',
                    title: getCurrentUser()!.title ?? 'No title',
                    image: getCurrentUser()!.imageUrl ?? '',
                    type: getCurrentUser()!.type ?? 'No type',
                  ),
                  verticalSpace(20),
                  HomeDateCard(
                    chckIn: '9:00 AM',
                    chckOut: '5:00 PM',
                    date: getCurrentDate(),
                  ),
                  verticalSpace(20),

                  // Quote Section with fixed height to prevent events jump
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) {
                      return current is HomeQuoteLoading ||
                          current is HomeQuoteSuccess ||
                          current is HomeQuoteFailure;
                    },
                    builder: (context, state) {
                      if (state is HomeQuoteLoading) {
                        return Skeletonizer(
                          enabled: true,
                          child: AppCard(
                            child: SizedBox(
                              width: double.infinity,
                              height: 100.h,
                            ),
                          ),
                        );
                      } else if (state is HomeQuoteSuccess) {
                        return HomeQuoteCard(quote: state.quote);
                      } else if (state is HomeQuoteFailure) {
                        return AppCard(
                          child: SizedBox(
                            width: double.infinity,
                            height: 100.h,
                            child: Center(
                              child: Text(
                                state.errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),

                  verticalSpace(20),
                  Text(
                    'Upcoming Events',
                    style: AppTextStyles.font18BlackBold
                        .copyWith(color: AppColors.primaryColor),
                  ),
                  verticalSpace(10),

                  // Events Section
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) {
                      // Only rebuild when event state changes
                      return current is HomeEventLoading ||
                          current is HomeEventSuccess ||
                          current is HomeEventFailure;
                    },
                    builder: (context, state) {
                      if (state is HomeEventLoading) {
                        return Skeletonizer(
                          enabled: true,
                          child: AppCard(
                            child: SizedBox(
                              width: double.infinity,
                              height: 80.h,
                            ),
                          ),
                        );
                      } else if (state is HomeEventFailure) {
                        return Center(
                          child: Text(
                            'There is an error: ${state.errorMessage}',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is HomeEventSuccess) {
                        if (state.events.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                Text(
                                  "No upcoming events",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                verticalSpace(200),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.events.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context.push('/eventDetailsScreen',
                                    extra: state.events[index]);
                              },
                              child: UpcomingEventCard(
                                event: state.events[index],
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
