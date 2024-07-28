import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'descriptionNotes.dart';
import 'getData.dart';


class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {

  final _firestore = FirebaseFirestore.instance;
  bool upd = false;
  bool _canPop = false;

  void confirmDelete(id){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              titleTextStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              title: const Center(
                  child: Text(
                    'Confirm Delete',
                  )
              ),
              content: const Column(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                    size: 130,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: Text(
                        "Are you sure you want to delete this note?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
              actions: [
                Theme(
                  data: ThemeData(
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.8), // Adjust the border radius as needed
                          ),
                        ),
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor:
                        WidgetStateProperty.all(Colors.lightGreen),
                        foregroundColor:
                        WidgetStateProperty.all(Colors.black),
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Theme(
                  data: ThemeData(
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.8), // Adjust the border radius as needed
                          ),
                        ),
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor:
                        WidgetStateProperty.all(Colors.lightGreen),
                        foregroundColor:
                        WidgetStateProperty.all(Colors.black),
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () async{
                      Navigator.of(context).pop();
                      // TODO: Perform delete operation using Delete function
                      try{
                        CollectionReference collection = _firestore.collection(
                          'notes'
                        );
                        DocumentReference docref = collection.doc(id);
                        await docref.delete();
                      }
                      catch(e){
                        if (kDebugMode) {
                          print("Error Deleting Document: $e");
                        }
                      }
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
        onPopInvoked: (bool didpop) => _goBack(context),
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.amberAccent,
            title: const Text(
              "JotSpot",
            ),
            centerTitle: true,
          ),
          // TODO: Floating Action Button Implementation
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              tooltip: "Add Note",
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.add,
                size: 40,
                weight: 50,
              ),
              onPressed: () {
                Get.to(
                      () => GetData(
                        upd: false,
                      ),
                );
              },
            ),
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _firestore.collection("notes").orderBy('time').snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              } else if (snapshot.hasError){
                return Text('Error: \n${snapshot.error}');
              } else {
                final notes = snapshot.data?.docs;//.reversed
                List<Widget> noteTextWidget = [];

                for(var note in notes!){
                  final titleText = note.data()['title'];
                  final descriptionText = note.data()['description'];
                  final timeText = note.data()['time'];
                  final color = note.data()['color'];
                  final docId = note.id;

                  final noteWidget = DescriptionNote(   // Custom Class
                    title: titleText,
                    time: timeText,
                    description: descriptionText,
                    id: docId,
                    color: color,
                    deleteData: (String? id) => confirmDelete(id),  // Custom function
                  );
                  noteTextWidget.add(noteWidget);
                }
                return ListView(
                  reverse: false,
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  children: noteTextWidget,
                );
              }
            },
          ),
        ),
    );
  }

  Future<bool> _goBack(BuildContext context) async{
    final shouldpop = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: const EdgeInsets.all(15),
          titlePadding: const EdgeInsets.only(top: 10),
          contentPadding: const EdgeInsets.only(top: 10),
          title: const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Hold on a sec! 🚦",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Text(
                'Exiting the application\nAre you certain you want to exit?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Close dialog and prevent app exit
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
    );
    if (shouldpop != null && shouldpop) {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    } else {
      setState(() {
        _canPop = false;
      });
    }
    return Future.value(true);
  }
}

