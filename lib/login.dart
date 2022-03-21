import 'package:flutter/material.dart';
import 'ordering_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String name;
  TextEditingController controller = TextEditingController();

  void click() {
    name = controller.text;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OrderingPage(name)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Senior Shoppers")),
        body: Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Type Your Name",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 5, color: Colors.black)),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.done),
                          splashColor: Colors.blue,
                          tooltip: "Submit",
                          onPressed: click,
                        ))))));
  }
}
