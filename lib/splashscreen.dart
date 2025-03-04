import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gobank/home/CustomCardView.dart';
import 'package:gobank/home/demosplash.dart';
import 'package:gobank/home/home.dart';
import 'package:gobank/home/loan/personalloan_form.dart';
import 'package:gobank/login/verifyOTP.dart';
import 'package:gobank/pages/orderplaced.dart';
import '../utils/media.dart';
import 'package:gobank/home/topup/topupcard/topup.dart';
import 'package:gobank/login/minkycpage.dart';
import 'package:gobank/login/minnativekyclogin.dart';
import 'package:gobank/login/phone.dart';
import 'package:gobank/login/verify.dart';

import 'package:gobank/onbonding.dart';
import 'package:gobank/pages/CardDetails.dart';
import 'package:gobank/pages/digitalcard_detail.dart';
import 'package:gobank/pages/history.dart';
import 'package:gobank/profile/myprofile.dart';

import 'package:gobank/utils/colornotifire.dart';
import 'package:gobank/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'card/createxcard.dart';
import 'home/NotificationServices.dart';
import 'login/loginCheck.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  late ColorNotifire notifire;
  //final authCtrl = Get.put<AuthCtrl>(AuthCtrl());

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
    getdarkmodepreviousstate();
    Timer(Duration(seconds: 2), () { 
        checkUserStatus();
    });
      
        // Navigator.push(context, MaterialPageRoute(builder: (context) => // Home()
        // onboard!.get("onboard")==true?MyPhone():Onbonding()
        // ,));

      
  }


  void checkUserStatus() async {
    Future.delayed(Duration(seconds: 1), () async {
  bool isFirstTimevalue = await isFirstTime();
  if (isFirstTimevalue) {
    navigateToScreen(Onbonding());
  } else {
    bool isLoggedInValue = await isLoggedIn();
    if (isLoggedInValue) {
      bool isVerifiedValue = await isVerified();
      if (isVerifiedValue) {
        bool isMINKYCCompleteValue = await isMINKYCComplete();
        if (isMINKYCCompleteValue) {
          navigateToScreen(Home());
        } else {
          navigateToScreen(minkycpage());
        }
     } else {
       navigateToScreen(MyPhone());
      }
    } else {
      navigateToScreen(MyPhone());
    }
  }
  });
}

  void navigateToScreen(Widget screen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      body:Column(
      mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       
        Center(
          child: Image.asset(
            "asset/images/logo_splash_big.png",
            
          ),
        ),
        Center(child: CircularProgressIndicator(color: Color(0xffFD6E01))),
      ],
      ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child:
           Container( alignment: Alignment.center,
           height:100,
           child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('made in 🇮🇳 with love',
              style: TextStyle(
                                      fontFamily: 'Gilroy Bold',
                                      color: notifire.getdarkscolor,
                                      fontSize: height / 40),
              ),
              SizedBox(width: 5,),
              SizedBox(
                height: 70,
                child: Image.asset("asset/images/secure.png"))
            ],
           )
           )
           ),
    );
  }
}
