class Note {
  final String title;
  final String content;
  final String category;
  final DateTime modifiedTime;
  final String? imagePath;
  final String? audioPath; // Added
  final String? sketchPath; // Added

  Note({
    required this.title,
    required this.content,
    required this.category,
    DateTime? modifiedTime,
    this.imagePath,
    this.audioPath, // Added
    this.sketchPath, // Added
    
  }) : modifiedTime = modifiedTime ?? DateTime.now();

  String? get getImagePath => imagePath;
  String? get getAudioPath => audioPath; // AddedD
  String? get getSketchPath => sketchPath; // AddedD

  Note copyWith({
    String? title,
    String? content,
    String? category,
    DateTime? modifiedTime,
    String? imagePath,
    String? audioPath, // Added
    String? sketchPath, // Added
  }) {
    return Note(
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      modifiedTime: modifiedTime ?? this.modifiedTime,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath, // Added
      sketchPath: sketchPath ?? this.sketchPath, // Added
    );
  }
}
