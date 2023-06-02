import 'package:flutter/material.dart';
import 'package:fireblog/views/registration_screen.dart';

class OnboardingBody extends StatefulWidget {
  @override
  _OnboardingBodyState createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  int currentPage = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, String>> onboardData = [
    {
      "text":
          "Welcome to FireBlog, the talented development and community wing dedicated to the growth of the digital world. Join us on this exciting journey!",
      "image": "assets/images/onboard1.png",
      "heading": "Welcome to FireBlog"
    },
    {
      "text":
          "With FireBlog, you can unleash your creativity and express yourself through blogs. Create captivating content and share it with a vibrant community of passionate individuals. ",
      "image": "assets/images/onboard2.png",
      "heading": "Create and Share"
    },
    {
      "text":
          "Dive into a world of inspiration and knowledge. Explore blogs crafted by talented writers, connect with like-minded individuals, and foster meaningful conversations within the FireBlog community.",
      "image": "assets/images/onboard3.png",
      "heading": "Explore and Connect"
    },
  ];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.02,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: height * 0.02),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Registration()));
                              },
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24),
                              )),
                        ),
                      ),
                    ]),
              ),
              Expanded(
                flex: 5,
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: onboardData.length,
                  itemBuilder: (context, index) => OnboardContent(
                    image: onboardData[index]["image"],
                    text: onboardData[index]['text'],
                    heading: onboardData[index]['heading'],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.03),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardData.length,
                          (index) => buildDot(index: index),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: height * 0.03),
                              child: GestureDetector(
                                onTap: () {
                                  if (currentPage == onboardData.length - 1) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Registration()));
                                  }
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.bounceIn,
                                  );
                                },
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.brown,
                                  size: 40,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 50 : 15,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.brown : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    Key? key,
    this.text,
    this.image,
    this.heading,
  }) : super(key: key);
  final String? text, image, heading;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Text(heading!,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 18,
                )),
        Container(
          width: width * 0.3,
          height: 4,
          margin: const EdgeInsets.only(top: 5, bottom: 25),
          decoration: const BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
        ),
        Image.asset(
          image!,
          height: height * 0.35,
          width: width * 0.8,
        ),
        SizedBox(
          height: height * 0.05,
        ),
        Text(text!,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
            textAlign: TextAlign.center),
      ],
    );
  }
}
