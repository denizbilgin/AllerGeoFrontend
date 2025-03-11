import 'package:allergeo/config/constants.dart';
import 'package:allergeo/utils/strings.dart';
import 'package:allergeo/widgets/home_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> howToUseAppStrings = [
      "Alerjilerinizi ekleyin",
      "Seyahatler oluşturun",
      "AllerGeo AI seyahat edeceğiniz tarihte alerjeninizin oradaki yoğunluğunu tahmin etsin",
      "Geçirdiğiniz alerji ataklarını not edin, kendinizi tanıyın!",
      "Rahatça gezin!"
    ];

    return Scaffold(
      backgroundColor: AppColors.ALLERGEO_GREEN,
      appBar: AppBar(
        title: const Text(Strings.APP_NAME),
        backgroundColor: AppColors.ALLERGEO_GREEN,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    "assets/images/forest-background.png",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Image.asset(
                      "assets/images/people-travelling.png",
                      height: 200,
                    ),
                  )
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: Strings.APP_NAME.substring(0, 5),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ALLERGEO_GREEN,
                            ),
                          ),
                          TextSpan(
                            text: Strings.APP_NAME.substring(5),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(Strings.APP_SHORT_DESCRIPTION),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Nasıl",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: " Kullanılır?",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ALLERGEO_GREEN,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: howToUseAppStrings.map((text) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Expanded(
                                      child: Text(text, style: TextStyle(fontSize: 14)),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        ),
                        SizedBox(width: 10),
                        Image.asset(
                          "assets/images/traveller.png",
                          height: 150,
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: HomeCard(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
