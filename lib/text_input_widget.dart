import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputWidget extends StatefulWidget {
  final Function(List<String>) callback;

  TextInputWidget(this.callback);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final List<TextEditingController> controllers =
      List.generate(5, (i) => TextEditingController());

  void click() {
    widget.callback(List.generate(3, (index) => controllers[index].text));
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
                              ? "Quantity (numbers only)"
                              : "Unit (if necessary)",
                    )));
          }),
          IconButton(
            onPressed: click,
            icon: Icon(Icons.add),
            tooltip: "Add item",
            splashColor: Colors.green,
          )
        ]));
  }
}
