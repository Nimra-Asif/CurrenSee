import 'package:carousel_slider/carousel_slider.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int currentIndex = 0;

  final List<Map<String, String>> slides = [
    {
      "image": "images/sliderTwo.jpg",
      "text": "Currency Exchange Made Easy"
    },
    {
      "image": "images/formBackground.jpg",
      "text": "Global Money Transfers Simplified"
    },
    // {
    //   "image": "images/SliderTwo.png",
    //   "text": "Save More with better Rates"
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CarouselSlider(
            items: slides
                .map(
                  (slide) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        slide["image"]!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                       const SizedBox(height: 5),
                      Text(
                        slide["text"]!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ],
                  ),
                )
                .toList(),
            carouselController: _carouselController,
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 5,
                width: currentIndex == index ? 25 : 10,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: currentIndex == index ? AppConstant().themeColor : AppConstant().secondaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          // const SizedBox(height: 2),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     IconButton(
          //       icon: const Icon(Icons.arrow_back),
          //       onPressed: () {
          //         _carouselController.previousPage(
          //           duration: const Duration(milliseconds: 300),
          //           curve: Curves.easeInOut,
          //         );
          //       },
          //     ),
          //     IconButton(
          //       icon: const Icon(Icons.arrow_forward),
          //       onPressed: () {
          //         _carouselController.nextPage(
          //           duration: const Duration(milliseconds: 300),
          //           curve: Curves.easeInOut,
          //         );
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}