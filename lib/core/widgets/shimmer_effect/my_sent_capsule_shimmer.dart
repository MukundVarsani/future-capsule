import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MySentCapsuleShimmer extends StatelessWidget {
  const MySentCapsuleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[500]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 0,
            ),
            capsuleCard(),
            capsuleCard(),
          ],
        ),
      ),
    );
  }

  Widget capsuleCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 255, 255, 0.5),
              blurRadius: 8,
              spreadRadius: 0.1)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18).copyWith(
                      bottomLeft: const Radius.circular(0),
                      bottomRight: const Radius.circular(0)),
                  color: const Color.fromRGBO(32, 32, 32, 0.6),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  height: 18,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(32, 32, 32, 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 31, 29, 29),
                ),
              ),
              Container(
                height: 18,
                width: 90,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(32, 32, 32, 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              Container(
                height: 18,
                width: 90,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(32, 32, 32, 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(
                width: 12,
              )
            ],
          ),
        ],
      ),
    );
  }
}
