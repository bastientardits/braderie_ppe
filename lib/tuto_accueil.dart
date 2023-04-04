import 'package:braderie_ppe/bottomNavigationBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

class tuto_accueil extends StatefulWidget {
  const tuto_accueil({Key? key}) : super(key: key);

  @override
  tuto_accueilState createState() => tuto_accueilState();
}

class tuto_accueilState extends State<tuto_accueil> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NavBar()),
    );
  }

  Widget _buildFullscreenImage(String assetName) {
    return Image.asset(
      assetName,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(assetName, width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 30000,
      globalFooter: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          child: const Text(
            'Je connais déjà l\'appli, allons-y!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),

          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF885F06)
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Un outil de recherche communautaire",
          body:
          "Optimisez vos recherches et vos ventes lors de braderies",
          image: _buildFullscreenImage('assets/images/img1.jpg'),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "Une carte mise à jour hebdomadairement",
          body: "Identifiez les stands qui vous intéressent et laissez-nous vous y guider",
          image: _buildFullscreenImage('assets/images/img2.jpg'),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "La perle rare",
          body: "Découvrez des articles rares que vous recherchez depuis des lustres",
          image: _buildFullscreenImage('assets/images/img3.jpg'),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),

      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Suivant', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFF885F06),
        activeColor: Color(0xFFE19F0C),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      baseBtnStyle: TextButton.styleFrom(
        backgroundColor: Colors.amber,
      ),
      skipStyle: TextButton.styleFrom(foregroundColor: Color(0xFF885F06)),
      doneStyle: TextButton.styleFrom(foregroundColor: Color(0xFF885F06)),
      nextStyle: TextButton.styleFrom(foregroundColor: Color(0xFF885F06)),
      backStyle: TextButton.styleFrom(foregroundColor: Color(0xFF885F06)),
    );
  }
}
