import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Load file'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<String> fetchFileFromAssets(String fileName) async {
  try {
    return await rootBundle
        .loadString('assets/' + fileName + '.txt')
        .then((file) => file.toString());
  } catch (e) {
    return Future.error('​файл ${fileName} не найден');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final fileNameController = TextEditingController();

  Future<String>? _fileContent;
  String _fileName = '';

  @override
  void dispose() {
    fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: fileNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            bottomLeft: const Radius.circular(15)),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                          ),
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        _fileName = fileNameController.text;
                        _fileContent = fetchFileFromAssets(_fileName);

                        setState(() {});
                      },
                      child: const Text(
                        'Найти',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              FutureBuilder<String>(
                future: _fileContent,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                        child: Text('Введите название файла'),
                      );
                    case ConnectionState.done:
                      return Center(
                        child: snapshot.data != null
                            ? Text('Содержимое файла ${_fileName}.txt:')
                            : _fileName.isEmpty
                                ? Text('Введите название файла')
                                : Text('Файл ${_fileName}.txt не найден!'),
                      );

                    default:
                      return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<String>(
                  future: _fileContent,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Container();
                      case ConnectionState.done:
                        return SingleChildScrollView(
                            child: snapshot.data != null
                                ? Text(snapshot.data)
                                : Container());
                      default:
                        return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
