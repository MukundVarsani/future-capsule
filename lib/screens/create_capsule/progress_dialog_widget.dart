import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:video_compress/video_compress.dart';

class ProgressDialogWidget extends StatefulWidget {
  const ProgressDialogWidget({super.key});

  @override
  State<ProgressDialogWidget> createState() => _ProgressDialogWidgetState();
}

class _ProgressDialogWidgetState extends State<ProgressDialogWidget> {
  late Subscription subscription;
  double? progress;

  @override
  void initState() {
    subscription = VideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        this.progress = progress;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    subscription.unsubscribe();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = progress == null ? progress : progress! / 100;
    return Container(
      constraints: const BoxConstraints( maxHeight: 200),
      
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        
        children: [
          const Text("Compressing Image..."),
          const SizedBox(
            height: 20,
          ),
          LinearProgressIndicator(
            value: value,
            minHeight: 15,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: AppColors.kLightGreyColor,
            color: AppColors.kWarmCoralColor,
          )
        ],
      ),
    );
  }
}
