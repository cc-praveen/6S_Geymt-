// @dart=2.9
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
/*import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';*/
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geymt/app_color.dart';
import 'package:geymt/cubit/language/language_cubit.dart';

import 'package:geymt/screens/bottomnav/BottomNavScreen.dart';
import 'package:geymt/settings/preferences.dart';
import 'package:geymt/screens/getotp/getotp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'connectivity/internet_cubit.dart';
import 'data/network-service/network_service.dart';
import 'data/repository.dart';

import 'language/app_localizations.dart';
import 'language/languages.dart';



void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.kPrimaryDarkColor,
  ));
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Preferences.init();
  runApp(
     /* DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ),*/

    MyApp(),
      );
}
/*void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.kPrimaryDarkColor,
  ));
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    await Preferences.init();
    runApp(
      *//*DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ),
   *//*
      MaterialApp(home: MyApp()),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Repository repository = Repository(networkService: NetworkService());
    final Connectivity connectivity=Connectivity();

    return MultiBlocProvider(
        providers: [
          BlocProvider(
       create: (BuildContext context) => LanguageCubit(languageentity:Languages.languages[0]),),
          BlocProvider(
          create: (context) => InternetCubit(connectivity: connectivity)),
          /*  BlocProvider<DashCubit>(
              create: (BuildContext context) => DashCubit(repository: repository),
             // child: Dashboard( menuScreenContext: context),
            ),*/  ],
      child: BlocBuilder<LanguageCubit,LanguageState>(
        builder: (context, state) {
        if(state is LanguageLoaded){
          print('LanguageChanges${state.locale.countryCode}');

                return
                  ScreenUtilInit(
                      /*BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                          maxHeight: MediaQuery.of(context).size.height),*/
                      designSize: Size(360, 690),
                      //orientation: Orientation.portrait,

                      builder: () =>  MaterialApp(
                        theme: ThemeData(
                          brightness: Brightness.light,
                          appBarTheme: AppBarTheme(
                            systemOverlayStyle: SystemUiOverlayStyle.light,
                          ),
                          primaryColor: AppColors.kPrimaryColor,
                          accentColor: AppColors.kAccentColor,
                          backgroundColor: AppColors.kPrimaryColor,
                          fontFamily: "Roboto",
                          textTheme: TextTheme(
                            headline1: TextStyle(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kTextPrimary,
                                letterSpacing: 0
                            ),
                            headline2: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kTextPrimary,
                                letterSpacing: 0
                            ),
                            headline3: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kTextPrimary,
                                letterSpacing: 0
                            ),
                            headline4: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.kTextPrimary,
                              letterSpacing: 0,
                              //height: 1.5
                            ),
                            headline5: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kTextPrimary,
                                letterSpacing: 0,
                                height: 1.5
                            ),
                            subtitle1: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.kTextPrimary,
                                letterSpacing: 0
                            ),
                            subtitle2: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,//medium
                                color: AppColors.kTextPrimary,
                                letterSpacing: 0
                            ),

                            bodyText1: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,  /// regular
                                color: AppColors.kTextPrimary,
                                letterSpacing: 0
                            ),
                            bodyText2: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,  /// Bold
                                color: AppColors.kTextPrimary,
                                letterSpacing: 0
                            ),
                          ),
                        ),//AppThemeDataFactory.prepareThemeData(),
                        debugShowCheckedModeBanner: false,

                        // home: MainApp(),
                        supportedLocales:
                        Languages.languages.map((e) => Locale(e.code)).toList(),

                         //builder: DevicePreview.appBuilder, // Add the builder Device preview here
                        locale: state.locale,
                        //Locale(Languages.languages[1].code),
                        localizationsDelegates: [
                          AppLocalizations.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                        ],

                        home:Preferences.getUserValidate()==true?BottomNavScreen():GetOtpScreen(),
                        initialRoute: '/',
                        routes: {
                          // When navigating to the "/" route, build the FirstScreen widget.
                          '/first': (context) =>
                              Container(
                                color: Colors.black12,
                              ),
                          // When navigating to the "/second" route, build the SecondScreen widget.
                          '/second': (context) =>
                              Container(
                                color: Colors.black26,
                              ),
                        },

                        // We use routeName so that we dont need to remember the name
                        // initialRoute: SignInScreen.routeName,
                        //routes: routes,
                      )
          );


        }else return SizedBox.shrink();


        }
      ),


      );
  }
}



class Banner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(

          body:Container(
            width: double.infinity,
            height: 150.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0XFF0061ff), Color(0XFF60efff)],
              ),
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(10),
            ),

            child: Column(

              children: [
                Expanded(flex:2,child:

            Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text('Referral discount',
                      overflow: TextOverflow.ellipsis,style: themeData.textTheme.headline3.copyWith(color: Colors.white)
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text('Flat 50 discount on each referral ',
                        overflow: TextOverflow.ellipsis,style: themeData.textTheme.subtitle2.copyWith(color: Colors.white)
                    ),
                  ),
                ),

              ],
            )),
                Expanded(flex:4,child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      runSpacing: 1.0,
                      spacing: 2.0,
                      direction: Axis.vertical,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: _generateChildren(6),
                    ),
                  ),
                )),
                Expanded(child:  SizedBox(
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [ Text('Offer valid to ',
                    overflow: TextOverflow.ellipsis,style: themeData.textTheme.subtitle2.copyWith(color: Colors.white)),
                      Text('Add long text here',
                        overflow: TextOverflow.ellipsis,style: themeData.textTheme.subtitle1.copyWith(color: Colors.white))]
                  ),
                ),)

              ],
            ),

         /*   child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

               *//* Expanded(
                  flex: 3,
                  child:Container(color: Colors.redAccent),
                ),


                Expanded(
                    flex: 7,

                    child: SizedBox(
                      height: double.infinity,
                      child: Wrap(
                        direction: Axis.vertical,
                        children: _generateChildren(12),
                      ),
                    )

                  *//**//*child:Container(
                      width: double.infinity,
                      //height: 150.h,
                      child: Wrap(
                        alignment:WrapAlignment.start,
                        children: _generateChildren(12),
                      ),
                    )*//**//*

                  //SizedBox()

                ),*//*
              ],
            ),*/

            /* child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex:2,child: Text(
                            '${oResultlst.name}',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 25.sp,
                              height: 1.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),),
                      Expanded(
                        flex:2,child:RichText(
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          maxLines: 10,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                  '${oResultlst.description}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500)),

                            ],
                          ),
                        ),),

                          FittedBox(
                            child: Expanded(child: Text(
                              'Offers Valid till on: ${oResultlst.endsOn}',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ignore: unrelated_type_equality_checks

                  oResultlst.promotionalDiscount!=null?promotionalDiscount():unitBasedDiscount()


                ],
              ),
            ),*/
          )

      ),
    );


  }

  Widget _generateItem(double width, double height) {
    return Container(
      width: width,
      height: height,
     /* decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        //color: Colors.pink,
      ),*/
      child:Row(
        crossAxisAlignment:CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text('3 Month',
              overflow: TextOverflow.ellipsis,style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Roboto',
                    fontSize: 12.sp)
            ),
          ),
          Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[

                    TextSpan(
                        text: '50.00',//?oResultlst.promotionalDiscount!.standardDiscount!.discount!.split(',').first:oResultlst.promotionalDiscount!.standardDiscount!.discount!}',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Haettenschweiler',
                            fontSize: 20.sp)),


                    TextSpan(
                        text: ' ',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Haettenschweiler',
                            fontSize: 10.sp)),
                    TextSpan(
                      text: '% ',
                      style: TextStyle(
                          fontFamily: 'Haettenschweiler', fontSize: 15.sp),
                    ),
                  ],
                ),
              )
          ),
        ],
      )
    );
  }

  List<Widget> _generateChildren(int count) {
    List<Widget> items = [];

    for (int i = 0; i < count; i++) {
      items.add(_generateItem(100.w, 20.h));
    }

    return items;
  }
}



