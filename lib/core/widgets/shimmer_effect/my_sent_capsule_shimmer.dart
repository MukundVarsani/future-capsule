import 'package:carousel_slider/carousel_slider.dart';
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
            CarouselSlider(
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    height: 300,
                    autoPlay: true,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration: const Duration(milliseconds: 500)),
                items: [
                  carasolItem(),
                  carasolItem(),
                  carasolItem(),
                ]),
            const SizedBox(
              height: 24,
            ),
            capsuleCard(),
            capsuleCard(),
   
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.083,
            )
          ],
        ),
      ),
    );
  }

  Widget carasolItem() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(32, 32, 32, 0.6),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 12,
          child: Container(
            height: 15,
            width: 50,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(32, 32, 32, 0.6),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        Positioned(
          left: 12,
          bottom: 12,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(32, 32, 32, 0.6),
              borderRadius: BorderRadius.circular(180),
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          left: 12,
          child: Container(
            height: 18,
            width: 150,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(32, 32, 32, 0.6),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 100,
          child: Container(
            height: 18,
            width: 90,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(32, 32, 32, 0.6),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
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
