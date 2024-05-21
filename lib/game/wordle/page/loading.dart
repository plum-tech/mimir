import 'package:flutter/material.dart';
import '../page/game.dart';
import '../generator.dart';
import '../widget/validation.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({
    super.key,
    required this.dicName,
  });

  final String dicName;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<List<String>> _loadDatabase({required String dicName}) async {
    var dataBase = await generateQuestionSet(dicName: dicName);
    if (ValidationProvider.validationDatabase.isEmpty) {
      ValidationProvider.validationDatabase = await generateDictionary();
    }
    return dataBase;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadDatabase(dicName: widget.dicName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GameWordle(
            database: snapshot.data!,
          );
        } else {
          return Scaffold(
            body: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(
                    color: Colors.teal[400],
                    strokeWidth: 4.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'Loading Libraries',
                    style: TextStyle(color: Colors.teal[400], fontWeight: FontWeight.bold, fontSize: 25.0),
                  ),
                ),
              ]),
            ),
          );
        }
      },
    );
  }
}
