import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetData extends StatefulWidget {
  // String? title;
  // String? description;
  // String? time;
  // bool upd;
  // String? docId;

  String? description;
  String? title;
  String? time;
  bool upd;
  String? docId;

  GetData(
      {super.key,
      this.title,
      this.description,
      this.time,
      required this.upd,
      this.docId});

  @override
  State<GetData> createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  final _fireStore = FirebaseFirestore.instance;
  final List<String> _undoStack = [];
  final List<String> _redoStack = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  String? date;
  currentDate() {
    DateTime now = DateTime.now();
    String currDate = DateFormat('dd-MMM-yyyy | HH:MM').format(now);
    date = currDate;
  }

  Future<void> saveData() async {
    CollectionReference users = _fireStore.collection("notes");
    try {
      if (titleController.text == "" && desController.text == "") {
        showDialog(
          context: context,
          builder: (context) {
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
                    'Not Allowed',
                  )),
                  content: const Column(
                    children: [
                      Icon(
                        Icons.cancel_rounded,
                        color: Colors.red,
                        size: 130,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                          child: Text(
                        "Enter Some Data Before Saving",
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Okay',
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
      } else {
        await users.add({
          'title': titleController.text,
          'description': desController.text,
          'time': date!,
          'color': randomColorGenerator(),
        }).whenComplete(() {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AlertDialog(
                    titleTextStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    title: const Text('Successful'),
                    content: const Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 130,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Your Note Saved Successfully!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Okay',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          );
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("FireBase Error ---> $e");
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Column(
              children: [
                Icon(
                  Icons.cancel_rounded,
                  color: Colors.red,
                  size: 25,
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Try Again!"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay'),
              )
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    currentDate();
    if (widget.upd == true) {
      setState(() {
        titleController.text = '${widget.title}';
        desController.text = '${widget.description}';
        date = '${widget.time}';
      });
    }
  }

  void _undo() {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(desController.text); // Save current state for redo
      desController.text = _undoStack.removeLast(); // Revert to last state
      _moveCursorToEnd(); // Ensure the cursor stays at the end
    }
    setState(() {});
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(desController.text); // Save current state for undo
      desController.text = _redoStack.removeLast(); // Apply redo state
      _moveCursorToEnd(); // Ensure the cursor stays at the end
    }
    setState(() {});
  }

  void _moveCursorToEnd() {
    desController.selection =
        TextSelection.collapsed(offset: desController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.amberAccent,
        title: Text(
          (widget.upd == true) ? "Update Note" : "Add Note",
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _showShareOptions();
          },
          icon: const Icon(Icons.ios_share,
              color: Colors.white), // Share icon on the left
        ),
        actions: [
          IconButton(
            onPressed: () => _undo(),
            icon: const Icon(Icons.undo,
                color: Colors.white), // Undo icon on the right
          ),
          IconButton(
            onPressed: () => _redo(),
            icon: const Icon(Icons.redo,
                color: Colors.white), // Redo icon on the right
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: const Color(0xff4D4D4D),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: TextField(
                        // cursorColor: Colors.black,
                        controller: titleController,
                        onChanged: (value) => print(titleController.text),
                        style: const TextStyle(
                          // fontSize: 25,
                          overflow: TextOverflow.fade,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    textAlign: TextAlign.left,
                    date!,
                    // style: const TextStyle(
                    //   // fontSize: 16,
                    //   // color: Colors.grey,
                    //   // fontWeight: FontWeight.w500,
                    // ),
                  ),
                  Text(
                    ' | ${desController.text.length} characters',
                    // style: const TextStyle(
                    //   fontSize: 16,
                    //   color: Colors.grey,
                    //   fontWeight: FontWeight.w500,
                    // ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff4D4D4D),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  // cursorColor: Colors.black,
                  controller: desController,
                  onChanged: (text) {
                    // Update the UI to reflect changes in character count
                    // setState(() {});
                    setState(() {
                      if (_undoStack.isEmpty || _undoStack.last != text) {
                        _undoStack.add(text);
                        _redoStack.clear(); // Clear redo stack on new changes
                      }
                    });
                  },
                  // style: const TextStyle(
                  //   fontSize: 25,
                  // ),
                  decoration: const InputDecoration(
                    hintText: 'Enter description.......',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Theme(
                      data: ThemeData(
                        elevatedButtonTheme: ElevatedButtonThemeData(
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5.0), // Adjust the border radius as needed
                              ),
                            ),
                            elevation: WidgetStateProperty.all(0),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.yellow),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.black),
                          ),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Delete",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  Expanded(
                    child: Theme(
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
                                WidgetStateProperty.all(Colors.yellow),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.black),
                          ),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          (widget.upd == false) ? saveData() : updateData();
                        },
                        child: Text(
                          (widget.upd == true) ? "Update" : "Save",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        height: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Share note as text'),
                onTap: () {
                  Share.share(
                      '${titleController.text}: -\n\n${desController.text}');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Share note as picture'),
                onTap: () {
                  // Share using picture

                  // You can use a package like image_picker to select an image

                  // and then share it

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic randomColorGenerator() {
    final random = Random();
    final red = 150 + random.nextInt(106);
    final green = 150 + random.nextInt(106);
    final blue = 150 + random.nextInt(106);
    return "#${red.toRadixString(16).padLeft(2, '0').toUpperCase()}${green.toRadixString(16).padLeft(2, '0').toUpperCase()}${blue.toRadixString(16).padLeft(2, '0').toUpperCase()}";
  }

  void updateData() async {
    if (widget.title == titleController.text &&
        widget.description == desController.text) {
      showDialog(
          context: context,
          builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AlertDialog(
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    actionsPadding: const EdgeInsets.all(15),
                    titlePadding: const EdgeInsets.only(top: 10),
                    contentPadding: const EdgeInsets.only(top: 10),
                    title: const Center(
                      child: Text(
                        "Error",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.yellowAccent,
                          size: 130,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Update Some Data Before Updating',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
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
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Close',
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
                            Navigator.pop(context); // Close dialog and prevent app exit
                          },
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
      );
    }
    else{
      try{
        await _fireStore.collection('notes').doc(widget.docId).update({
          'title': titleController.text,
          'description': desController.text,
          'time' : date,
        }).whenComplete((){
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AlertDialog(
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    actionsPadding: const EdgeInsets.all(15),
                    titlePadding: const EdgeInsets.only(top: 10),
                    contentPadding: const EdgeInsets.only(top: 10),
                    title: const Center(
                      child: Text(
                        "Successfully Saved",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 130,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Your Data has Updated Successfully',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog and prevent app exit
                          },
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
          );
        });

      }catch(e){

      }
    }
  }
}
