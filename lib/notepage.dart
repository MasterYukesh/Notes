import 'package:flutter/material.dart';
import 'package:notes/databasehelper.dart';
import 'package:notes/note.dart';

class NotePage extends StatefulWidget {
  final Note note;
  const NotePage({Key? key, required this.note}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _NotePage();
  }
}

class _NotePage extends State<NotePage> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  bool isImportant = false;
  Color bgColor = Colors.purple;
  late bool delflag;
  bool isSaveVisible = true;
  @override
  void initState() {
    super.initState();
    title.text = widget.note.title;
    content.text = widget.note.content;
    bgColor = Color(widget.note.bgColor);
    isImportant = widget.note.isImportant;
    delflag = false;
  }

  void changebgc(Color color) {
    setState(() {
      bgColor = color;
    });
  }

  void savenote() {
    if (widget.note.id == null) {
      if (title.text == "" && content.text == "") {
      } else {
        DatabaseHelper.instance.insert(Note(
            title: title.text,
            content: content.text,
            dateTime: DateTime.now(),
            isImportant: false,
            bgColor: bgColor.value));
      }
    } else {
      DatabaseHelper.instance.update(Note(
          id: widget.note.id,
          title: title.text,
          content: content.text,
          dateTime: DateTime.now(),
          isImportant: widget.note.isImportant,
          bgColor: bgColor.value));
    }
  }

  void deletenote() {
    DatabaseHelper.instance.delete(widget.note.id!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          actions: [
            Visibility(
                visible: widget.note.id != null,
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context1) => AlertDialog(
                              title: const Text('Reminder Alert!'),
                              content: const Text(
                                  'Do you want to delete this note?'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context1);
                                    },
                                    child: const Text('No')),
                                ElevatedButton(
                                    onPressed: () {
                                      deletenote();
                                      delflag = true;
                                      Navigator.pop(context1);
                                      showSnackBar(
                                          context, "Note deleted Succesfully");
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text('Yes'))
                              ],
                            ));
                  },
                )),
            Visibility(
              visible: isSaveVisible,
              child: IconButton(
                icon: const Icon(Icons.done),
                color: Colors.white,
                onPressed: () {
                  savenote();
                  unfocus(context);
                  showSnackBar(context, "Note Saved Succesfully");
                },
              ),
            ),
          ],
        ),
        body: Column(children: [
          const SizedBox(
            height: 25,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              icon: const Icon(
                Icons.circle,
                color: Colors.purple,
                size: 40,
              ),
              onPressed: () {
                changebgc(Colors.purple);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(
                Icons.circle,
                color: Colors.red,
                size: 40,
              ),
              onPressed: () {
                changebgc(Colors.red);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(
                Icons.circle,
                color: Colors.orange,
                size: 40,
              ),
              onPressed: () {
                changebgc(Colors.orange);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(
                Icons.circle,
                color: Colors.blue,
                size: 40,
              ),
              onPressed: () {
                changebgc(Colors.blue);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(
                Icons.circle,
                color: Colors.green,
                size: 40,
              ),
              onPressed: () {
                changebgc(Colors.green);
              },
            ),
          ]),
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                isSaveVisible = true;
              });
            },
            controller: title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
            decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: const TextStyle(color: Colors.white, fontSize: 30),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: bgColor))),
          ),
          const SizedBox(
            height: 50,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                isSaveVisible = true;
              });
            },
            maxLines: null,
            controller: content,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            decoration: InputDecoration(
                hintText: 'Content',
                hintStyle: const TextStyle(color: Colors.white, fontSize: 30),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: bgColor))),
          ),
        ]),
      ),
    );
  }

  showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    ));
  }

  void unfocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
