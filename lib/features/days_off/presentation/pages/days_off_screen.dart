import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leaptech_plus/core/functions/get_current_user.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/core/widgets/app_button.dart';
import 'package:leaptech_plus/features/days_off/domain/entities/days_off_entity.dart';
import 'package:leaptech_plus/features/days_off/presentation/cubits/days_off_cubit.dart';
import 'package:leaptech_plus/features/days_off/presentation/widgets/day_off_list_item.dart';
import 'package:leaptech_plus/features/days_off/presentation/widgets/days_off_main_card.dart';
import 'package:leaptech_plus/features/days_off/presentation/widgets/days_off_skeltonizer.dart';

class DaysOffScreen extends StatefulWidget {
  const DaysOffScreen({super.key});

  @override
  State<DaysOffScreen> createState() => _DaysOffScreenState();
}

class _DaysOffScreenState extends State<DaysOffScreen> {
  int selectedFilterIndex = 0;
  final List<String> filters = ["All", "Pending", "Approved", "Rejected"];
  List<DaysOffEntity> filteredDaysOff = [];
  List<DaysOffEntity> allDaysOff = []; // Store all days off for filtering

  @override
  void initState() {
    super.initState();
    final cubit = context.read<DaysOffCubit>();
    final currentUser = getCurrentUser();
    if (currentUser != null) {
      cubit.setCurrentEmployeeId(currentUser.id);
      cubit.getEmployeeDaysOff(currentUser.id);
      cubit.getEmployeeLeaveBalance(currentUser.id);
    }
  }

  void _filterDaysOff(List<DaysOffEntity> daysOff) {
    // Store the original list for future filtering
    allDaysOff = List.from(daysOff);

    setState(() {
      switch (selectedFilterIndex) {
        case 0: // All
          filteredDaysOff = List.from(daysOff);
          break;
        case 1: // Pending
          filteredDaysOff =
              daysOff.where((dayOff) => dayOff.status == 'Pending').toList();
          break;
        case 2: // Approved
          filteredDaysOff =
              daysOff.where((dayOff) => dayOff.status == 'Approved').toList();
          break;
        case 3: // Rejected
          filteredDaysOff =
              daysOff.where((dayOff) => dayOff.status == 'Rejected').toList();
          break;
        default:
          filteredDaysOff = List.from(daysOff);
      }
    });
  }

  // Method to reapply filter using the original list
  void _reapplyFilter() {
    setState(() {
      switch (selectedFilterIndex) {
        case 0: // All
          filteredDaysOff = List.from(allDaysOff);
          break;
        case 1: // Pending
          filteredDaysOff =
              allDaysOff.where((dayOff) => dayOff.status == 'Pending').toList();
          break;
        case 2: // Approved
          filteredDaysOff = allDaysOff
              .where((dayOff) => dayOff.status == 'Approved')
              .toList();
          break;
        case 3: // Rejected
          filteredDaysOff = allDaysOff
              .where((dayOff) => dayOff.status == 'Rejected')
              .toList();
          break;
        default:
          filteredDaysOff = List.from(allDaysOff);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DaysOffCubit, DaysOffState>(
        listener: (context, state) {
          if (state is DaysOffLoaded) {
            _filterDaysOff(state.daysOff);
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.primaryColor,
            backgroundColor: AppColors.white,
            onRefresh: () async {
              final cubit = context.read<DaysOffCubit>();
              final currentUser = getCurrentUser();
              if (currentUser != null) {
                await cubit.getEmployeeDaysOff(currentUser.id);
                await cubit.getEmployeeLeaveBalance(currentUser.id);
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      'Remaining Days Off',
                      style: AppTextStyles.font20BlackSemiBold.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    verticalSpace(12),

                    // MAIN CARD
                    BlocBuilder<DaysOffCubit, DaysOffState>(
                      builder: (context, state) {
                        if (state is LeaveBalanceLoaded) {
                          return DaysOffMainCard(balance: state.balance);
                        }
                        return DaysOffMainCard();
                      },
                    ),
                    verticalSpace(16),

                    // REQUEST NEW DAY OFF BUTTON
                    AppButton(
                      height: 48.h,
                      buttonText: "Request New Day Off",
                      onPressed: () {
                        context.push('/requestDayOffScren');
                      },
                    ),
                    verticalSpace(20),

                    // FILTER BUTTONS
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: List.generate(filters.length, (index) {
                          bool isSelected = index == selectedFilterIndex;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: index != filters.length - 1 ? 6.w : 0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedFilterIndex = index;
                                    // Reapply filter using the original list
                                    _reapplyFilter();
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.5)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      filters[index],
                                      style: AppTextStyles.font14BlackMedium
                                          .copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    verticalSpace(20),

                    // LISTVIEW BUILDER
                    if (state is DaysOffLoading)
                      DaysOffSkeleton()
                    else if (state is DaysOffError)
                      Center(
                        child: Column(
                          children: [
                            Text('Error: ${state.message}'),
                            verticalSpace(10),
                            ElevatedButton(
                              onPressed: () {
                                final currentUser = getCurrentUser();
                                if (currentUser != null) {
                                  context
                                      .read<DaysOffCubit>()
                                      .getEmployeeDaysOff(currentUser.id);
                                }
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredDaysOff.length,
                        itemBuilder: (context, index) {
                          final item = filteredDaysOff[index];
                          Color statusColor = item.status == "Approved"
                              ? Colors.green
                              : item.status == "Rejected"
                                  ? Colors.red
                                  : Colors.orange;

                          // Convert to the format expected by DayOffLIstItem
                          final Map<String, String> itemMap = {
                            "name": item.leaveType,
                            "duration":
                                "${item.endDate.difference(item.startDate).inDays + 1} days",
                            "start":
                                "${item.startDate.day} ${_getMonthName(item.startDate.month)} ${item.startDate.year}",
                            "end":
                                "${item.endDate.day} ${_getMonthName(item.endDate.month)} ${item.endDate.year}",
                            "status": item.status,
                          };

                          return DayOffLIstItem(
                              item: itemMap, statusColor: statusColor);
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
