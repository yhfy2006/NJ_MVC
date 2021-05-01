import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mvc_appointment/appoint_type.dart';
import 'package:mvc_appointment/model/Site.dart';
import 'package:mvc_appointment/utils/my_colors.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:html' as html;

class HomeMainScreen extends StatefulWidget {
  HomeMainScreen({Key? key}) : super(key: key);
  static const routeName = 'HomeMainScreen';

  @override
  _HomeMainScreenState createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  bool _initialized = false;
  bool _error = false;
  List<Site> sites = [];
  bool isSearching = false;
  List<AppType> typeSelected = [];
  StreamSubscription<QueryEvent>? _eventsSubscription;
  FlutterTts flutterTts = FlutterTts(); // make some sound

  AlertDialog noTypeDiag(BuildContext context) {
    return AlertDialog(
      title: Text("Appointment Type"),
      content: Text("Please select one or more appointment type"),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initializeApp(
        apiKey: "AIzaSyBSsQRwaMis7UVx_k6HtbykkW5T2wt53q4",
        authDomain: "mvc-search.firebaseapp.com",
        databaseURL: "https://mvc-search-default-rtdb.firebaseio.com",
        projectId: "mvc-search",
        storageBucket: "mvc-search.appspot.com");
  }

  Future _speak() async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);

    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak("found appointment");
  }

  void subscripStream() {
    print('subscriped');
    Database db = database();
    DatabaseReference ref = db.ref('/');
    _eventsSubscription = ref.onValue.listen((e) {
      DataSnapshot datasnapshot = e.snapshot;
      List<Site> tmpList = [];
      if (datasnapshot.val() != null) {
        Map<String, dynamic>? valMap = datasnapshot.val();
        valMap?.forEach((key, json) {
          final site = Site(
            json['type'] as String,
            json['siteName'] as String,
            json['slotTime'] as String,
            json['link'] as String,
          );
          tmpList.add(site);
        });
      }

      // filter
      final currentTypeSet = typeSelected.map((e) => e.name).toSet();
      tmpList = tmpList
          .where((element) => currentTypeSet.contains(element.type))
          .toList();

      setState(() {
        sites = tmpList;
        if (sites.length > 0) {
          _speak();
        }
        print(sites);
      });

      // Do something with datasnapshot
    });
  }

  void cancelStreamSubscription() {
    print('subscription cancelled');
    _eventsSubscription?.cancel();
  }

  static List<AppType> _appTypes = [
    AppType(id: 1, name: "Renewal"),
    AppType(id: 2, name: "RealID")
  ];

  final _items = _appTypes
      .map((animal) => MultiSelectItem<AppType>(animal, animal.name))
      .toList();

  final spinkit = SpinKitDualRing(
    color: Colors.white,
    size: 18.0,
  );

  @override
  Widget build(BuildContext context) {
    if (_error) {
      print(_error);
    }

    // Show a loader until FlutterFire is initialized
    print(_initialized);
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size(screenSize.width, 4000),
      //   child: Card(
      //     child: Container(
      //       color: Colors.white,
      //       child: Padding(
      //         padding: EdgeInsets.all(0),
      //         child: Row(
      //           children: [
      //             Text(''),
      //             Expanded(
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   InkWell(
      //                     onTap: () {},
      //                     child: Text(
      //                       'Discover',
      //                       style: TextStyle(color: Colors.black),
      //                     ),
      //                   ),
      //                   SizedBox(width: screenSize.width / 20),
      //                   InkWell(
      //                     onTap: () {},
      //                     child: Text(
      //                       'Contact Us',
      //                       style: TextStyle(color: Colors.black),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             InkWell(
      //               onTap: () {},
      //               child: Text(
      //                 'Sign Up',
      //                 style: TextStyle(color: Colors.black),
      //               ),
      //             ),
      //             SizedBox(
      //               width: screenSize.width / 50,
      //             ),
      //             InkWell(
      //               onTap: () {},
      //               child: Text(
      //                 'Login',
      //                 style: TextStyle(color: Colors.black),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
          Container(
              height: screenSize.height * 0.6,
              color: MyColors.mainAppColor_blue,
              child: Padding(
                padding: const EdgeInsets.all(100.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: double.infinity,
                      width: screenSize.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              'NJ MVC \nAppointment \nAuto Search',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 80),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              'We know it\'s so hard to find a MVC appointment, \nso we do the search automatically for you',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      height: screenSize.width * 0.3,
                      width: screenSize.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: [
                          MultiSelectChipField(
                            items: _items,
                            initialValue: [],
                            title: Text("Select the appointment type"),
                            headerColor:
                                MyColors.mainAppColor_blue.withOpacity(0.5),
                            chipColor: Colors.white,
                            textStyle:
                                TextStyle(color: MyColors.mainAppColor_blue),
                            selectedChipColor:
                                MyColors.mainAppColor_blue.withOpacity(0.5),
                            selectedTextStyle:
                                TextStyle(color: MyColors.mainAppColor_blue),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: MyColors.mainAppColor_blue,
                                      width: 1)),
                            ),
                            onTap: (values) {
                              setState(() {
                                typeSelected = values.cast<AppType>().toList();
                              });
                            },
                          ),
                          Expanded(
                              child: Container(
                            child: Center(
                              child: FittedBox(
                                child: TextButton(
                                    child: Container(
                                        width: 200,
                                        height: 60,
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            isSearching
                                                ? Center(child: spinkit)
                                                : Container(),
                                            SizedBox(
                                              width: isSearching ? 10 : 0,
                                            ),
                                            Text(
                                              isSearching
                                                  ? 'Stop Search'
                                                  : 'Click to Search!',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            )
                                          ],
                                        ))),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.orange)),
                                    onPressed: () {
                                      print('Pressed');
                                      if (typeSelected.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return noTypeDiag(context);
                                          },
                                        );
                                      } else {
                                        setState(() {
                                          isSearching = !isSearching;
                                          if (isSearching) {
                                            subscripStream();
                                          } else {
                                            cancelStreamSubscription();
                                          }
                                        });
                                      }
                                    }),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    //  MultiSelectDialogField(
                    //   items: _items,
                    //   title: Text("Animals"),
                    //   selectedColor: Colors.blue,
                    //   decoration: BoxDecoration(
                    //     color: Colors.blue.withOpacity(0.1),
                    //     borderRadius: BorderRadius.all(Radius.circular(40)),
                    //     border: Border.all(
                    //       color: Colors.blue,
                    //       width: 2,
                    //     ),
                    //   ),
                    //   buttonIcon: Icon(
                    //     Icons.pets,
                    //     color: Colors.blue,
                    //   ),
                    //   buttonText: Text(
                    //     "Favorite Animals",
                    //     style: TextStyle(
                    //       color: Colors.blue[800],
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    //   onConfirm: (results) {
                    //     //_selectedAnimals = results;
                    //   },
                    // ),
                  ],
                ),
              )),
          Container(
            height: screenSize.height * 0.35,
            width: double.infinity,
            color: Colors.amber,
            child: Row(
              children: [
                Expanded(child: Container()),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: screenSize.width * 0.4,
                    color: Colors.amber,
                    child: sites.isEmpty
                        ? Center(
                            child: Text(
                              !isSearching
                                  ? ''
                                  : '* Once started the search, the result will show here automatically and you can click the result to the appointment page. \n \n * The appointment will be booked very fast, so do not be surprised when you not seeing the appointment avaiable when you ready to book. Just wait for next serach result and do it quickly.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            itemCount: sites.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: ListTileTheme(
                                  child: ListTile(
                                    //leading: _menuItem[index]['icon'],
                                    leading: Icon(
                                      Icons.date_range_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    title: Text(
                                      sites[index].siteName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(sites[index].slotTime,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                    //selected: _menuItem[index]['selected'],
                                    trailing: Text(
                                      sites[index].type,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      html.window
                                          .open(sites[index].link, 'new tab');
                                    },
                                  ),
                                ),
                              );
                            },
                          )),
                Expanded(child: Container()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
