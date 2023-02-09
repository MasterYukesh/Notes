import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/databasehelper.dart';
import 'package:notes/notepage.dart';
import 'note.dart';

class SearchPage extends SearchDelegate {
  List<Note> notes = List.empty();
  DateFormat formatter = DateFormat("MMMM dd ").add_jm();
  void init() async {
    notes = await DatabaseHelper.instance.queryall();
  }

  // void unfocus(BuildContext context) {
  //   FocusScopeNode currentFocus = FocusScope.of(context);
  //   if (!currentFocus.hasPrimaryFocus) {
  //     currentFocus.unfocus();
  //   }
  // }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isNotEmpty) {
              query = '';
            } else {
              close(context, null);
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          //unfocus(context);
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    init();
    List<Note> searchList = [];
    if (query.isNotEmpty) {
      for (Note item in notes) {
        if (item.title.toLowerCase().contains(query.toLowerCase())) {
          searchList.add(item);
        }
      }
    } else {
      searchList = notes;
    }
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        itemCount: searchList.length,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  tileColor: Color(searchList[index].bgColor),
                  title: RichText(
                    text: TextSpan(
                        text:
                            searchList[index].title.substring(0, query.length),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                              text: searchList[index]
                                  .title
                                  .substring(query.length),style: const TextStyle(color: Colors.white))
                        ]),
                  ),
                  subtitle: Text(formatter.format(searchList[index].dateTime)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NotePage(note: searchList[index])));
                  }),
            ));
  }
}
