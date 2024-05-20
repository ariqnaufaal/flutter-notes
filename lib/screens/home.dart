import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_flutter/constants/colors.dart';
import 'package:note_flutter/database/save_to_firestore.dart';
import 'package:note_flutter/features/calendar.dart';
import 'package:note_flutter/models/note.dart';
import 'package:note_flutter/screens/edit.dart';
import 'package:note_flutter/screens/setting.dart';

class HomeScreen extends StatefulWidget {
  
  final List<Note> notes;

  HomeScreen({super.key, required this.notes});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  User? user = FirebaseAuth.instance.currentUser;
  
  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();
  
  late List<Note> notes;
  
  bool sorted = false;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    notes = widget.notes; // Update the notes list from the widget property
  }

  void sortNotesByModifiedTime() {
    notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    if (!sorted) notes = notes.reversed.toList();
    sorted = !sorted;
  }

  void filterNotesByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Color getRandomColor() {
    Random random = Random();
    int index = random.nextInt(backgroundColors.length);
    return backgroundColors[index];
  }

  Future<void> _addOrEditNote([Note? note]) async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(note: note, notes: notes),
      ),
    );

    if (result != null) {
      setState(() {
        if (note == null) {
          notes.add(result);
        } else {
          final index = notes.indexOf(note);
          notes[index] = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Get data user:  $user');
    String? userEmail = user?.email;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingScreen(),
                      ),
                    );
                  },
                ),
                Text(
                  'Notes',
                  style: TextStyle(fontSize: 30, color: Colors.grey.shade800),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          sortNotesByModifiedTime();
                        });
                      },
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.sort,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CalendarScreen(),
                          ),
                        );
                      },
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: "Search notes",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                fillColor: Colors.grey.shade300,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryContainer(
                  category: 'All',
                  onTap: filterNotesByCategory,
                ),
                CategoryContainer(
                  category: 'Favorites',
                  onTap: filterNotesByCategory,
                ),
                CategoryContainer(
                  category: 'To Do Lists',
                  onTap: filterNotesByCategory,
                ),
                CategoryContainer(
                  category: 'Tasks',
                  onTap: filterNotesByCategory,
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            StreamBuilder(
              stream: database.getNotesStream(userEmail!), 
              builder: (context, snapshot){
                // show loading circle
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                    );
                }

              // get all notes by current user
              final notes = snapshot.data!.docs;
              debugPrint('Get data notes:  $notes');


              // no data? 
              if (snapshot.data == null || notes.isEmpty) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Text("No notes found."),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    if (selectedCategory != 'All' && note['category'] != selectedCategory) {
                      return Container();
                    }
                    return GestureDetector(
                      onTap: () => _addOrEditNote(note as Note?),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 20),
                        color: getRandomColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note['title'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        height: 1.5,
                                      ),
                                    ),
                                    if (note['content'].isNotEmpty)
                                      Text(
                                        note['content'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (note['imagePath'] != "" || note['sketchPath'] != "")
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    children: [
                                      if (note['imagePath'] != null)
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.file(
                                              File(note['imagePath']!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      if (note['sketchPath'] != null)
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.file(
                                              File(note['sketchPath']!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            /*
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  if (selectedCategory != 'All' && note.category != selectedCategory) {
                    return Container();
                  }
                  return GestureDetector(
                    onTap: () => _addOrEditNote(note),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      color: getRandomColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      height: 1.5,
                                    ),
                                  ),
                                  if (note.content.isNotEmpty)
                                    Text(
                                      note.content,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (note.imagePath != null || note.sketchPath != null)
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Stack(
                                  children: [
                                    if (note.imagePath != null)
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.file(
                                            File(note.imagePath!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    if (note.sketchPath != null)
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.file(
                                            File(note.sketchPath!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            */
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final String category;
  final void Function(String) onTap;

  const CategoryContainer({
    required this.category,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(category);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}