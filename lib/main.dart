import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/Helper/Constance/const_firebase.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Constance/const_state.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Constance/const_theme.dart';
import 'package:social_app/Views/Authentication/Login/main_login_screen.dart';
import 'package:social_app/Views/Main/app_localizations.dart';
import 'package:social_app/Views/Main/bottom_bar.dart';
import 'package:social_app/Views/Main/routes_builder.dart';
import 'package:social_app/Views/View/test.dart';
import 'package:social_app/firebase_options.dart';

Future<void> messageBackGround(RemoteMessage message) async {
  await Fluttertoast.showToast(msg: 'Google');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

 print(await FirebaseMessaging.instance.getToken());

 await FirebaseMessaging.instance.getInitialMessage();

 FirebaseMessaging.onBackgroundMessage(messageBackGround);

  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  // // final NotificationSettings settings = await messaging.requestPermission(
  // //   alert: true,
  // //   announcement: false,
  // //   badge: true,
  // //   carPlay: false,
  // //   criticalAlert: false,
  // //   provisional: false,
  // //   sound: true,
  // // );


  // FirebaseMessaging.onMessage.listen((event) {
  //   Fluttertoast.showToast(msg: 'Google');
  // });

  // runApp(DevicePreview(
  //     enabled: !kReleaseMode ,
  //   builder: (context) {
  //     return const ProviderScope(child: MyApp());
  //   }
  // ));


  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MaterialApp(
      title: 'Social App' ,
      debugShowCheckedModeBanner: false ,
      routes: RouteBuilder.routes ,
      theme: lightTheme ,
      darkTheme: darkTheme ,
      themeMode: ThemeMode.light,
    //  home: const TestPage(),
       home: Consumer(
        builder: (context,prov,_) {
          return prov.watch(_saveUser).when(
              error: (err,stack)=>errorProvider(err) ,
              loading: ()=>Scaffold(body: loadingProvider()) ,
            data: (user)=> user == null ? const MainLoginScreen(): const MainBottomBarScreen()
          );
        }
      ),
      restorationScopeId: 'root' ,
      locale: TextTranslate.switchLang(ref.watch(langProv).lang) ,
      supportedLocales: const [
        Locale("en","") ,
        Locale("ar","") ,
        Locale('es','')
      ] ,
      localizationsDelegates: const [
        AppLocalization.delegate ,
        GlobalWidgetsLocalizations.delegate ,
        GlobalMaterialLocalizations.delegate ,
        GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: ( currentLocal , supportedLocal ) {
        if( currentLocal != null ) {
          for( Locale loopLocal in supportedLocal ) {
            if( currentLocal.languageCode == loopLocal.languageCode ){
              return currentLocal;
            }
          }
        }
        return supportedLocal.first ;
      },
    );
  }
}


final _saveUser = StreamProvider((ref)=>firebaseAuth.authStateChanges());