import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer/sunmi_printer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SunmiPrinter.bindingPrinter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MyHomePage(title: 'تجربة طباعة'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'اكتب الذى تريد طباعته',
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    label: Text("العنوان"),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 10,
                  minLines: 1,
                ),
                const SizedBox(height: 15.0,),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(
                    label: Text("المحتوى"),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  minLines: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await SunmiPrinter.startTransactionPrint();
          await SunmiPrinter.setAlignment(PrintAlign.CENTER);
          await SunmiPrinter.printText(titleController.text);
          await SunmiPrinter.setAlignment(PrintAlign.RIGHT);
          await SunmiPrinter.lineWrap(2);
          await SunmiPrinter.printText(bodyController.text);
          await SunmiPrinter.lineWrap(2);
          await SunmiPrinter.printText('');
          await SunmiPrinter.submitTransactionPrint();
          await SunmiPrinter.exitTransactionPrint();
        },
        tooltip: 'print',
        child: const Icon(Icons.print),
      ),
    );
  }
}
