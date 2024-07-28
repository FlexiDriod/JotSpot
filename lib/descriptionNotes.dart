import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'getData.dart';

class DescriptionNote extends StatelessWidget {
  const DescriptionNote({
    super.key,
    required this.time,
    required this.title,
    required this.description,
    required this.id,
    required this.color,
    required this.deleteData
  });

  final String title;
  final String time;
  final String description;
  final String? id;
  final String? color;
  final Function(String?)? deleteData;

  dynamic randomColorGenerator() {
    final random = Random();
    final red = 150 + random.nextInt(106);
    final green = 150 + random.nextInt(106);
    final blue = 150 + random.nextInt(106);
    return Color.fromARGB(255, red, green, blue);
  }

  Color hexToColor(String hexCode){
    final buffer = StringBuffer();
    if(hexCode.length == 6 || hexCode.length == 7){
      buffer.write('ff');
    }
    buffer.write(hexCode.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return /*Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){

        deleteData!(id);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('$title deleted')),
        // );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
            Icons.delete_forever_rounded,
            size: 40,
            color: Colors.white
        ),
      ),
      child:*/ Padding(
          padding: const EdgeInsets.all(6.0),
        child: GestureDetector(
          onTap: (){
            Get.to(
                  () => GetData(
                    upd: true,
                    title: title,
                    description: description,
                    time: time,
                    docId: id,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: hexToColor(color!),
              ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth:240),
                        child: Text(
                          title==""?"Undefined":title,
                          style: const TextStyle(
                            //TODO: Applying Title Text Style
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth:240),
                      child: Text(
                        description==""?"Undefined":description,
                        softWrap: true,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          //TODO: Applying Title Text Style
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        maxLines:2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      time,
                        style: const TextStyle(
                          //TODO: Applying Title Text Style
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
                Center(
                  child: IconButton(
                    onPressed: () => deleteData!(id),
                    icon: Icon(
                      Icons.delete_forever_rounded,
                      size: 60,
                      color: Colors.grey.shade800,
                    ),
                  ),
                )
              ],
            ),
            ),
          ),
        // ),
    );
  }
}
