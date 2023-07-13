import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

String? val;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterMidi fmidi = FlutterMidi();
  @override
  void initState() {
    load('assets/sf2/Guitars.sf2');
    super.initState();
  }

  void load(String asset) async {
    fmidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    fmidi.prepare(
        sf2: _byte, name: 'assets/sf2/$val.sf2'.replaceAll('assets/sf2/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            DropdownButton<String?>(
              value: val ?? 'Guitars',
              items: const [
                DropdownMenuItem(
                  child: Text('Guitars'),
                  value: 'Guitars',
                ),
                DropdownMenuItem(
                  child: Text('Strings'),
                  value: 'Strings',
                ),
                DropdownMenuItem(
                  child: Text('Piano'),
                  value: 'Piano',
                )
              ],
              onChanged: (value) {
                setState(() {
                  val = value;
                });
                load('assets/sf2/$val.sf2');
              },
            ),
          ],
          title: Center(child: Text('piano')),
        ),
        body: Center(
          child: InteractivePiano(
            highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
            noteRange: NoteRange.forClefs([
              Clef.Treble,
            ]),
            onNotePositionTapped: (position) {
              fmidi.playMidiNote(midi: position.pitch);
            },
            naturalColor: Colors.white,
            accidentalColor: Colors.black,
            keyWidth: 60,
          ),
        ),
      ),
    );
  }
}
