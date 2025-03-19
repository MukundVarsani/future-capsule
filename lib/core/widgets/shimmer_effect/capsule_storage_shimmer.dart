import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CapsuleStorageShimmer extends StatelessWidget {
  const CapsuleStorageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: 4,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[500]!,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
            ).copyWith(top: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(32, 32, 32, 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 150,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: [
                    Container(
                      height: 18,
                      width: 120,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(32, 32, 32, 0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const Spacer(),
                   Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(32, 32, 32, 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                   Container(
                  height: 18,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(32, 32, 32, 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                    const Spacer(),
                  Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(32, 32, 32, 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
        
              ],
            ),
          ),
        );
      }
    );
  }
}
