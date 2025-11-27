import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:leaptech_plus/core/functions/get_current_user.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/my_toast.dart';
import 'package:leaptech_plus/core/widgets/app_button.dart';
import 'package:leaptech_plus/features/days_off/domain/entities/days_off_entity.dart';
import 'package:leaptech_plus/features/days_off/presentation/cubits/days_off_cubit.dart';
import 'package:uuid/uuid.dart';

class RequestDayOffScreen extends StatefulWidget {
  const RequestDayOffScreen({super.key});

  @override
  State<RequestDayOffScreen> createState() => _RequestDayOffScreenState();
}

class _RequestDayOffScreenState extends State<RequestDayOffScreen> {
  final List<String> leaveTypes = ["Sick", "Personal", "Annual"];
  int selectedLeaveIndex = 0;

  final TextEditingController descriptionController = TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;

  File? attachedImage;
  final ImagePicker picker = ImagePicker();

  bool _isSubmitting = false;

  Future<void> pickDate({required bool isFrom}) async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors
                  .primaryColor, // Header background & selected date color
              onPrimary: Colors.white, // Header text color
              onSurface: AppColors.secondaryColor, // Body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
          // If toDate is earlier than fromDate, reset it
          if (toDate != null && toDate!.isBefore(fromDate!)) {
            toDate = null;
          }
        } else {
          toDate = picked;
        }
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        attachedImage = File(image.path);
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String calculateDuration() {
    if (fromDate != null && toDate != null) {
      int days = toDate!.difference(fromDate!).inDays + 1; // include both dates
      return "$days day${days > 1 ? 's' : ''}";
    }
    return "-";
  }

  Future<void> _submitRequest() async {
    if (_isSubmitting) return;

    if (fromDate == null || toDate == null) {
      MyToast.error(context, "Please select both start and end dates");
      return;
    }

    if (fromDate!.isAfter(toDate!)) {
      MyToast.error(context, "Start date cannot be after end date");
      return;
    }

    final currentUser = getCurrentUser();
    if (currentUser == null) {
      MyToast.error(context, "User not found. Please login again.");
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    String? attachmentUrl;
    if (attachedImage != null) {
      try {
        final supabaseService = SupabaseService();
        attachmentUrl = await supabaseService.uploadImage(
          file: attachedImage!,
          folder: 'day_off_attachments',
          bucket: 'images',
        );
      } catch (e) {
        if (mounted) {
          MyToast.error(
              context, "Failed to upload attachment: ${e.toString()}");
        }
        setState(() {
          _isSubmitting = false;
        });
        return;
      }
    }

    // Generate a unique ID for the new day off request
    final uuid = Uuid().v4();

    final dayOff = DaysOffEntity(
      id: uuid,
      employeeId: currentUser.id,
      leaveType: leaveTypes[selectedLeaveIndex],
      startDate: fromDate!,
      endDate: toDate!,
      description: descriptionController.text,
      status: 'Pending',
      attachmentUrl: attachmentUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (mounted) {
      context.read<DaysOffCubit>().requestDayOff(dayOff);
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Request Day Off",
          style: AppTextStyles.font16WhiteBold,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocConsumer<DaysOffCubit, DaysOffState>(
        listener: (context, state) {
          if (state is DaysOffRequestSuccess) {
            setState(() {
              _isSubmitting = false;
            });
            if (mounted) {
              MyToast.success(
                  context, "Day off request submitted successfully");
              Navigator.of(context).pop();
            }
          } else if (state is DaysOffRequestError) {
            setState(() {
              _isSubmitting = false;
            });
            if (mounted) {
              MyToast.error(
                  context, "Failed to submit request: ${state.message}");
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leave Type
                Text(
                  "Leave Type",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(leaveTypes.length, (index) {
                    bool isSelected = index == selectedLeaveIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedLeaveIndex = index;
                          });
                        },
                        child: Container(
                          height: 40.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              leaveTypes[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16.h),
                // Description
                Text(
                  "Description",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                TextField(
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                          color: AppColors.secondaryColor, width: 2.0),
                    ),
                    hintText: "Enter the reason for your day off",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // From & To Date
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => pickDate(isFrom: true),
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              fromDate != null
                                  ? "From: ${formatDate(fromDate)}"
                                  : "Select From Date",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => pickDate(isFrom: false),
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              toDate != null
                                  ? "To: ${formatDate(toDate)}"
                                  : "Select To Date",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Duration
                Text(
                  "Duration: ${calculateDuration()}",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),

                SizedBox(height: 16.h),

                // Attach Image
                Text(
                  "Attach Image",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _isSubmitting ? () {} : pickImage,
                  child: Container(
                    height: 120.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.grey[100],
                    ),
                    child: attachedImage != null
                        ? Image.file(attachedImage!, fit: BoxFit.cover)
                        : Center(
                            child: Text(
                              "Tap to attach an image",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Submit Button
                AppButton(
                  buttonText:
                      _isSubmitting ? "Submitting..." : "Submit Request",
                  height: 50.h,
                  onPressed: _isSubmitting
                      ? () {} // Empty callback when submitting
                      : _submitRequest,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
