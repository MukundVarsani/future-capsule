import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CapsuleShimmer extends StatelessWidget {
  const CapsuleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,  // Show 4 loading placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[500]!,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Capsule Title
                  Container(
                    height: 20,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Image Placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description Placeholder
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 14,
                    width: 250,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 14),

                  // Date Placeholder
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 12,
                      width: 80,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
