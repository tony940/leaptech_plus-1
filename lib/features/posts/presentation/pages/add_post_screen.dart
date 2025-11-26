import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaptech_plus/core/functions/get_current_user.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/my_toast.dart';
import 'package:leaptech_plus/core/widgets/app_button.dart';
import 'package:leaptech_plus/core/widgets/app_text_field.dart';
import 'package:leaptech_plus/features/posts/presentation/cubits/posts_cubit.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _postController = TextEditingController();
  final List<File> attachedImages = [];
  final ImagePicker picker = ImagePicker();
  bool isLoading = false;
  bool _isCancelled = false; // flag to cancel upload if page disposed

  @override
  void dispose() {
    _isCancelled = true;
    _postController.dispose();
    super.dispose();
  }

  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        attachedImages.addAll(images.map((e) => File(e.path)));
      });
    }
  }

  Future<void> submitPost() async {
    final user = getCurrentUser();
    if (user == null) return;

    final content = _postController.text.trim();
    if (content.isEmpty && attachedImages.isEmpty) {
      MyToast.error(context, 'Post cannot be empty');
      return;
    }

    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      List<String> imageUrls = [];

      // Upload all images safely
      for (var file in attachedImages) {
        if (_isCancelled) return; // stop if page disposed
        final url = await SupabaseService().uploadImage(file: file);
        imageUrls.add(url);
      }

      if (_isCancelled) return;

      // Add post via cubit
      await context.read<PostsCubit>().addPost(
            userId: user.id,
            content: content.isEmpty ? null : content,
            imageUrls: imageUrls.isNotEmpty ? imageUrls : null,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post created successfully")),
      );

      _postController.clear();
      setState(() => attachedImages.clear());
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      MyToast.error(context, 'Failed to create post');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Post",
          style: AppTextStyles.font16WhiteBold,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Text
            Text(
              "What's on your mind?",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: AppTextField(
                hintText: 'Write something....',
                controller: _postController,
                maxLines: 5,
              ),
            ),

            SizedBox(height: 16.h),

            // Attach Images
            Text(
              "Attach Images",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: pickImages,
              child: Container(
                height: 180.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: attachedImages.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: attachedImages.length,
                        itemBuilder: (context, index) {
                          final file = attachedImages[index];
                          return Padding(
                            padding: EdgeInsets.all(4.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.file(file,
                                  width: 150.w, fit: BoxFit.cover),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "Tap to attach images",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ),
            ),

            SizedBox(height: 24.h),

            // Post Button
            AppButton(
              height: 50.h,
              buttonText: isLoading ? "Posting..." : "Post",
              onPressed: isLoading ? () {} : submitPost,
            ),
          ],
        ),
      ),
    );
  }
}
