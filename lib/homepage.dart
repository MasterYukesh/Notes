import 'package:flutter/material.dart';
import 'package:notes/aboutpage.dart';
import 'package:notes/databasehelper.dart';
import 'package:notes/notepage.dart';
import 'package:notes/searchpage.dart';
import 'note.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  List<Note> notes = List.empty();
  DateFormat formatter = DateFormat("MMMM dd ").add_jm();
  bool listMode = true;
  bool gridMode = false;

  String listGrid = "Grid View";

  @override
  void initState() {
    super.initState();
    getnotes();
  }

  void getnotes() async {
    //await DatabaseHelper.instance.droptable();
    notes = await DatabaseHelper.instance.queryall();
    setState(() {});
  }

  void showpopup1(BuildContext context) {
    showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(100, 150, 10, 10),
        items: [
          PopupMenuItem(
              onTap: (() {
                setState(() {
                  if (listGrid == "Grid View") {
                    listGrid = "List View";
                    gridMode = !gridMode;
                    listMode = !listMode;
                  } else {
                    listGrid = "Grid View";
                    gridMode = !gridMode;
                    listMode = !listMode;
                  }
                });
              }),
              child: Text(listGrid)),
          PopupMenuItem(
            child: const Text('About'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutPage())),
          )
        ]);
  }

  void showpopup2(BuildContext context, Note selectednote) {
    showMenu(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        color: Colors.grey,
        context: context,
        position: RelativeRect.fromSize(
            const Rect.fromLTWH(60, 700, 0, 0), const Size.fromHeight(0)),
        items: [
          PopupMenuItem(
              child: Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Reminder Alert!'),
                              content:
                                  const Text('Do you want to delete this note'),
                              actions: [
                                ElevatedButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    DatabaseHelper.instance
                                        .delete(selectednote.id!);
                                    Navigator.pop(context);
                                    getnotes();
                                    showSnackBar(
                                        context, 'Note deleted Successfuly');
                                  },
                                )
                              ],
                            ));
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.update(Note(
                        id: selectednote.id,
                        title: selectednote.title,
                        content: selectednote.content,
                        bgColor: selectednote.bgColor,
                        isImportant: !selectednote.isImportant,
                        dateTime: selectednote.dateTime));
                    getnotes();
                  },
                  child: const Text(
                    'Pin/Unpin',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'YukeNotes',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () =>
                        showSearch(context: context, delegate: SearchPage()),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () => showpopup1(context),
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ))
              ],
            ),
            Visibility(
              visible: gridMode,
              child: Flexible(
                child: GridView.builder(
                    itemCount: notes.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1.5),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          trailing: notes[index].isSelected == null
                              ? Visibility(
                                  visible: notes[index].isImportant,
                                  child: const Icon(
                                    Icons.push_pin_sharp,
                                  ),
                                )
                              : notes[index].isSelected == true
                                  ? const Icon(Icons.check_box)
                                  : null,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          tileColor: Color(notes[index].bgColor),
                          title: Text(
                            notes[index].title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          subtitle:
                              Text(formatter.format(notes[index].dateTime)),
                          onTap: (() async {
                            if (index < notes.length) {
                              bool result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotePage(
                                          note: Note(
                                              id: notes[index].id,
                                              title: notes[index].title,
                                              content: notes[index].content,
                                              bgColor: notes[index].bgColor,
                                              isImportant:
                                                  notes[index].isImportant,
                                              dateTime:
                                                  notes[index].dateTime))));
                              if (result) {
                                getnotes();
                              }
                            }
                          }),
                          onLongPress: () {
                            showpopup2(context, notes[index]);
                          },
                        ),
                      );
                    }),
              ),
            ),
            Visibility(
                visible: listMode,
                child: Flexible(
                  child: ListView.builder(
                    primary: true,
                    shrinkWrap: true,
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          trailing: notes[index].isSelected == null
                              ? Visibility(
                                  visible: notes[index].isImportant,
                                  child: const Icon(
                                    Icons.push_pin_sharp,
                                  ),
                                )
                              : notes[index].isSelected == true
                                  ? const Icon(Icons.check_box)
                                  : null,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          tileColor: Color(notes[index].bgColor),
                          title: Text(
                            notes[index].title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          subtitle:
                              Text(formatter.format(notes[index].dateTime)),
                          onTap: (() async {
                            if (index < notes.length) {
                              bool result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotePage(
                                          note: Note(
                                              id: notes[index].id,
                                              title: notes[index].title,
                                              content: notes[index].content,
                                              bgColor: notes[index].bgColor,
                                              isImportant:
                                                  notes[index].isImportant,
                                              dateTime:
                                                  notes[index].dateTime))));
                              if (result) {
                                getnotes();
                              }
                            }
                          }),
                          onLongPress: () {
                            showpopup2(context, notes[index]);
                          },
                        ),
                      );
                    },
                  ),
                ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotePage(
                              note: Note(
                            title: "",
                            content: "",
                            dateTime: DateTime.now(),
                            bgColor: Colors.purple.value,
                            isImportant: false,
                          ))));
              if (result) {
                getnotes();
                setState(() {});
              }
            },
            backgroundColor: Colors.deepOrangeAccent,
            child: const Icon(
              Icons.add,
              color: Colors.black,
            )),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
