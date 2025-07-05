import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/widgets/bordingWidget.dart';
import 'package:law_counsel_app/core/widgets/public_button.dart';
import 'package:law_counsel_app/features/SelectUser/selectUser.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onbordingscreen1 extends StatefulWidget {
  const Onbordingscreen1({super.key});

  @override
  State<Onbordingscreen1> createState() => _Onbordingscreen1State();
}

class _Onbordingscreen1State extends State<Onbordingscreen1> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 3;
              });
            },
            children: [
              bordingWidget(
                image: AppAssets.onboarding1,
                title: "مرحبًا بك في Lawyers",
                subTitle:
                    "منصة قانونية تتيح لك الوصول لأفضل المحامين بسهولة وفي أي وقت",
              ),
              bordingWidget(
                image: AppAssets.onboarding2,
                title: "محتاج استشارة قانونية؟",
                subTitle:
                    "تواصل مباشرة مع محامين متخصصين في مختلف المجالات القانونية.",
              ),
              bordingWidget(
                image: AppAssets.onboarding3,
                title: "مش عارف تبدا منين؟",
                subTitle:
                    "اسأل الشات بوت وهو هيفهم مشكلتك ويوجهك للمحامي المناسب",
              ),
              bordingWidget(
                image: AppAssets.onboarding4,
                title: "خصوصيتك في أمان",
                subTitle:
                    "كل استشاراتك ومحادثاتك مؤمنة 100%، واحنا بنحافظ على سريتك.",
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                isLastPage
                    ? OnboradingButton(
                        text: "ابدأ الآن",
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SelectUser(),
                            ),
                          );
                        },
                      ).buildButtonBoarding()
                    : OnboradingButton(
                        text: "التالي",
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                      ).buildButtonBoarding(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
