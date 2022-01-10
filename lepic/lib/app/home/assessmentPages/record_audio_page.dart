import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:exp/app/home/model/results.dart';
import 'package:exp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:exp/app/home/statistics/statistics.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';
import 'package:date_format/date_format.dart';
import 'package:word_selectable_text/word_selectable_text.dart';


class AudioPage extends StatefulWidget {

  const AudioPage({ Key? key, required this.studentId, required this.assessId }) : super(key: key);
  final String studentId;
  final String assessId;

  static Future<void> show(BuildContext context, String studentId, String assessId) async {

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AudioPage(studentId: studentId,assessId: assessId,),
        fullscreenDialog: true,
      ),
    );
  }
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  var text = "Taste is how food feels in your mouth. Basically, it is whether it is good food or not. For example, I think McDonald’s tastes good, but some people think it tastes bad. I think dark chocolate tastes better than milk chocolate, but you might think the opposite. If something tastes of nothing, then it does not have a strong taste.";
  final date = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
  var setDefaultMake = true;
  double totalReadingTime = 0.0;
  double numOfWordsReadPM = 0.0;
  int numOfWordsReadFM = 0;
  int totalWordsRead = 0;
  double numOfCorrectWordsReadPM = 0.0;
  int numOfIncorrectWords = 0;
  bool _isButtonDisabled = true;

  Duration duration = Duration();
  Timer? timer;
  late Results results;

  void addTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer() {
    setState(() => timer?.cancel());
  }

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _isButtonDisabled = true;
  }


  @override
  Widget build(BuildContext context) {
    String twoDigites(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigites(duration.inMinutes.remainder(60));
    final seconds = twoDigites(duration.inSeconds.remainder(60));
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Recording',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 1,
          actions: <Widget>[
            _buildCounterButton(),
          ],
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme
              .of(context)
              .primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed:  () {_listen(minutes, seconds);
            Future.delayed(Duration(seconds:60)).whenComplete((){
              oneMinWord();}); 
            },
              
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('assessments')
                          .where('assessId', isEqualTo: widget.assessId)
                          .get()
                          .asStream(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (setDefaultMake) {
                          text = snapshot.data!.docs[0].get('text');
                        }
                        return Container(
                          child:
                          Text(
                              text,
                              style: TextStyle(fontSize: 18)
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child:
                      Text(
                          'Reading Time: $minutes:$seconds',
                          style: TextStyle(fontSize: 15, color: Colors.white)
                      ),
                      color: Colors.blue[600],
                    ),
                    SizedBox(height: 20,),
              WordSelectableText(
                  selectable:  true,
                  highlight:  true,
                  text: _text,
                  onWordTapped: (word, index) {print("The word touched is $word");
                  numOfIncorrectWords = numOfIncorrectWords+1; },
                  style:  TextStyle(fontWeight: FontWeight.bold,fontSize:  20,
                    color: Colors.blue[300],)
              ),
                  ])
          ),
        )

    );
  }

  Future<void> _listen(String minutes, String seconds) async {
    if (!_isListening) {
      startTimer();
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) =>
              setState(() {
                _text = val.recognizedWords;
                print(_text);
                if (val.hasConfidenceRating && val.confidence > 0) {
                  _confidence = val.confidence;
                }
              }),
        );
      }
    } else {
      stopTimer();
      setState(() => _isListening = false);
      _speech.stop();
      final List<String> l = _text.split(" ");
      print(l.length);
      totalWordsRead = l.length;
      var min = int.parse(minutes);
      var sec = int.parse(seconds);
      assert(min is int);
      assert(sec is int);
      totalReadingTime = min + sec/60.0;
      if(min==0){
        numOfWordsReadPM = 0.0;
        numOfWordsReadFM = totalWordsRead;
        numOfCorrectWordsReadPM = 0.0;
      }
      else{
        numOfWordsReadPM = totalWordsRead/totalReadingTime;
        numOfCorrectWordsReadPM = (totalWordsRead - numOfIncorrectWords)/totalReadingTime;
      }
      _saveResult();
      setState(() => _isButtonDisabled = false);
    }
  }
  
void oneMinWord(){
    if(_isListening){
      final List l = _text.split(" ");
      numOfWordsReadFM = l.length;
    }
}


  Future<void> _saveResult() async {
    final resultId = Uuid().v4();
    final newResult = Results(assessId: widget.assessId, studentId: widget.studentId,
        resultId: resultId,
        totalReadingTime: totalReadingTime,
        date: date,
      numOfWordsReadPM: numOfWordsReadPM,
      numOfWordsReadFM: numOfWordsReadFM,
      numOfCorrectWordsReadPM: numOfCorrectWordsReadPM,
      numOfIncorrectWords: numOfIncorrectWords,
    );
    results = newResult;
    await FirestoreDatabase(uid: FirebaseAuth.instance.currentUser!.uid).createResult(newResult);
    //Navigator.of(context).pop();

  }
  Widget _buildCounterButton() {
    return ElevatedButton(
      child: const Text("Statistics"),
      onPressed:_isButtonDisabled ? null : ()=>ChartPage.show(context,results,),
    );
  }
}


