import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mawjud_1/widgets/bottomColorContainer.dart';
import 'package:mawjud_1/widgets/bottom_bar.dart';

class DashbordScreen extends StatefulWidget {
  const DashbordScreen({Key? key}) : super(key: key);

  @override
  _DashbordScreenState createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  DateTime now = DateTime.now();

  Future fetchData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.email)
        .snapshots();
  }
  Future fetchData1() async {
    await FirebaseFirestore.instance
        .collection("Courses")
        .doc()
        .snapshots();
  }

  String? day_name;
  @override
  void initState() {
    super.initState();
    day_name = DateFormat('EEEE').format(now);
    print(user!.email);
    print('***************');
    print(DateFormat('EEEE').format(now));
    fetchData();
    print('=======');
    fetchData1();
    print('=======');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Text(
                'الرئيسية',
                textAlign: TextAlign.center,
                style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: const Color(0xFF004146),
                      fontSize: 20,
                    ),
              ),
            ),
            actions: const [],
            centerTitle: true,
            toolbarHeight: 70,
            elevation: 5,
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(user!.email)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      snapshot.data!['UsersName'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: const Color(0xFF3F4343),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                    child: Text(
                      snapshot.data!['Job'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: const Color(0xFF3F4343),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(300, 10, 0, 10),
                    child: Text(
                      'التالي',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: const Color(0xFFB38E44),
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  Container(
                    height: 200,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(36, 5, 35, 0),
                      child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("Courses")
                            .where('days', arrayContains: day_name)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var item = snapshot.data!.docs[index];
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.height * 0.14,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 6,
                                        color: Color(0x33000000),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  /*child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SecondPage(room: item['Room']),
                                        ),
                                      );
                                    },*/ //AR navigation
                                    child: ListTile(
                                      title: Text('${item['CourseName']}'),
                                      subtitle: Text('${item['Start']}'),
                                        trailing/*: item['Job'] == "محاضر"
                                          ? RaisedButton(
                                        onPressed: () {
                                          // Add your code to handle the button press here
                                        },
                                        child: Text("Preparation"),
                                      )*/
                                          : Text('${item['Room']}'),
                                    ),
                                 // ),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return Text('loading');
                        },
                      ),
                    ),
                  ),

                  const Spacer(),
                    Column(
                    children: [
                      const BottomBar(),
                      const BottomColorContainer(),
                    ],
                  ),
                  ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
