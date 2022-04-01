// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputWidget extends StatefulWidget {
  final Function(List<String>) newItemCallback;
  final Function() saveCartCallback;

  TextInputWidget(this.newItemCallback, this.saveCartCallback);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final List<TextEditingController> controllers =
      List.generate(5, (i) => TextEditingController());

  void add() {
    var ret = List.generate(3, (index) => controllers[index].text);
    if (ret[2] == '') {
      ret[2] = ret[0];
    }
    widget.newItemCallback(ret);
    for (TextEditingController controller in controllers) {
      controller.clear();
    }
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Row(children: [
          ...List.generate(3, (int index) {
            return Expanded(
                child: TextField(
                    controller: controllers[index],
                    keyboardType: (index == 1) ? TextInputType.number : null,
                    inputFormatters: (index == 1)
                        ? <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ]
                        : null,
                    decoration: InputDecoration(
                      labelText: (index == 0)
                          ? "Item"
                          : (index == 1)
                              ? "Quantity"
                              : "Unit",
                    )));
          }),
          IconButton(
            onPressed: add,
            icon: Icon(Icons.add),
            tooltip: "Add item",
            splashColor: Colors.green,
          ),
          IconButton(
            onPressed: widget.saveCartCallback,
            icon: Icon(Icons.send),
            tooltip: "Send list",
            splashColor: Colors.green,
          )
        ]));
  }
}
