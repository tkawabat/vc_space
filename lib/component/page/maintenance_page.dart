import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dotenv.get('TITLE', fallback: '')),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(children: [
            Text(dotenv.get('MAINTENANCE', fallback: ''),
                style: const TextStyle(fontSize: 20)),
          ]),
        ),
      ),
    );
  }
}
