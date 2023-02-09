class NoteFields {
  static String id = "id";
  static String title = "title";
  static String content = "content";
  static String dateTime = "dateTime";
  static String isImportant = "isImportant";
  static String bgColor = "bgColor";
}

const tablename = "Notes";

class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime dateTime;
  final int bgColor;
  final bool isImportant;
  final bool? isSelected;

  const Note(
      {this.id,
      required this.title,
      required this.content,
      required this.dateTime,
      required this.bgColor,
      required this.isImportant,
      this.isSelected});

  Note copy(
      {int? id,
      String? title,
      String? content,
      DateTime? dateTime,
      int? bgColor,
      bool? isImportant,
      bool? isSelected}) {
    return Note(
        id: id ?? this.id,
        bgColor: bgColor ?? this.bgColor,
        dateTime: dateTime ?? this.dateTime,
        title: title ?? this.title,
        content: content ?? this.content,
        isImportant: isImportant ?? this.isImportant,
        isSelected: this.isSelected);
  }

  Map<String, Object?> toMap() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.content: content,
        NoteFields.dateTime: dateTime.toIso8601String(),
        NoteFields.bgColor: bgColor,
        NoteFields.isImportant: isImportant,
      };

  static Note toNote(Map<String, Object?> map) => Note(
        id: map[NoteFields.id] as int,
        title: map[NoteFields.title] as String,
        content: map[NoteFields.content] as String,
        bgColor: int.parse(map[NoteFields.bgColor].toString()),
        isImportant: map[NoteFields.isImportant] == 1,
        dateTime: DateTime.parse(map[NoteFields.dateTime].toString()),
      );
}
