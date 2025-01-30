import 'package:flutter/material.dart';
import 'package:trokot_dealer_mobile/common/events.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => DemoScreenState();
}

class DemoScreenState extends State<DemoScreen> {
  String text = '';

  late ServiceClient serviceClient;

  @override
  void initState() {
    super.initState();

    // const baseUrl = 'http://10.0.2.2:3000';
    const baseUrl = 'http://localhost:3000';

    
    serviceClient = ServiceClient(baseUrl: baseUrl, eventBus: EventBus.broadcast());
  }

  _getData() async {
    var result = (await serviceClient.callFunction(path: '/test')).toString();

    setState(() {
      // final person = <String, dynamic>{
      //   'name': 'Denis',
      //   'age': 40,
      // };
      // text = person.toString();

      text = result.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Screen'),
      ),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Text(text),
      //   ],
      // ),
      body: Center(
        child: Text(text),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        child: const Icon(Icons.add),
      ),
    );
  }
}



