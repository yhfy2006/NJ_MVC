import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:mvc_appointment/home_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NJ MVC Appointment Finder',
      navigatorObservers: <NavigatorObserver>[observer],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomeMainScreen(analytics: analytics),
      routes: {
        HomeMainScreen.routeName: (ctx) => HomeMainScreen(
              analytics: analytics,
            ),
      },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: MaterialApp(
//           title: 'NJ MVC',
//           debugShowCheckedModeBanner: false,

//           // ThemeData(
//           //   // fontFamily: 'Quicksand',
//           //   // primarySwatch: Colors.lightBlue,
//           //   primaryColor: Colors.black,
//           //   accentColor: MyColors.mainAppColor_light,
//           //   // accentColor: MyColors.textHintGrey,
//           //   // scaffoldBackgroundColor: Colors.white,
//           //   visualDensity: VisualDensity.adaptivePlatformDensity,
//           // ),
//           themeMode: ThemeMode.system,
//           home: HomeMainScreen(),
//           routes: {
//             HomeMainScreen.routeName: (ctx) => HomeMainScreen(
//                   analytics: analytics,
//                 ),
//           },
//         ),
//       ),
//     );
//   }
// }
