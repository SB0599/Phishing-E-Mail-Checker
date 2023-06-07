import 'package:flutter/material.dart';

import '../fileIO.dart';

class Filtermethode extends StatelessWidget {
  var filtermethode = 2;

  bool urlhause = false;
  bool MISP = false;
  bool File = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Input"),
      ),
      body: Center(
        child: RadioExample(),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //      children: ;
        // [
        //           CheckboxListTile(
        //               title: Text("URLHause"),
        //               value: urlhause,
        //               //groupValue: filtermethode,
        //               onChanged: (value) {
        //                   setState(() {
        //   filtermethode = value;
        // });
        //                 filtermethode = value as int;
        //                 //selected value
        //               }),
        //           CheckboxListTile(
        //               title: Text("MISP"),
        //               value: MISP,
        //               //groupValue: filtermethode,
        //               onChanged: (value) {
        //                 filtermethode = value as int;

        //                 //selected value
        //               }),
        //           CheckboxListTile(
        //               title: Text("File Input"),
        //               value: File,
        //               //groupValue: filtermethode,
        //               onChanged: (value) {
        //                 filtermethode = value as int;

        //                 //filtermethode = value as int;
        //                 //selected value
        //               })
        //         ],
      ),
    );
  }
}

enum FiltermethodeOption { FileInput, URLHause, MISP }

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  FiltermethodeOption? choose = FiltermethodeOption.URLHause;

  FileIO IO = new FileIO();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('URLHause API'),
          leading: Radio<FiltermethodeOption>(
            value: FiltermethodeOption.URLHause,
            groupValue: choose,
            onChanged: (FiltermethodeOption? value) {
              IO.writeConfigFile("Filtermethode", "2");
              //var res = int.parse(IO.readConfigFile("Filtermethode") as String);
              //print(res);
              setState(() {
                choose = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('CSV File Input'),
          leading: Radio<FiltermethodeOption>(
            value: FiltermethodeOption.FileInput,
            groupValue: choose,
            onChanged: (FiltermethodeOption? value) {
              IO.writeConfigFile("Filtermethode", "1");
              setState(() {
                choose = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('MISP'),
          leading: Radio<FiltermethodeOption>(
            value: FiltermethodeOption.MISP,
            groupValue: choose,
            onChanged: (FiltermethodeOption? value) {
              IO.writeConfigFile("Filtermethode", "3");
              setState(() {
                choose = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
