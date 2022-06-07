import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Caro extends StatefulWidget {
  const Caro({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CaroState createState() => _CaroState();
}

class _CaroState extends State<Caro> {
  CarouselController controller = CarouselController();
  PageController pager = PageController();
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CarouselSlider.builder(
            carouselController: controller,
            options: CarouselOptions(
              onPageChanged: ((index, reason) => setState(() {
                    activeIndex = index;
                  })),
              aspectRatio: 16 / 9,
              reverse: true,
              pageSnapping: false,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              enlargeCenterPage: true,
              viewportFraction: 0.7,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
            ),
            itemCount: 15,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Container(
              color: Colors.blue,
              // margin: EdgeInsets.symmetric(horizontal: 10),
              height: 200,
              width: double.infinity,
              child: const Center(child: Placeholder()),
            ),
          ),
          SizedBox(
            child: AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: 15,
              effect: const JumpingDotEffect(
                  activeDotColor: Colors.red, dotColor: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}
