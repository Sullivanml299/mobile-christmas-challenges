import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goblin_vault/clues.dart';
import 'package:goblin_vault/qr_scanner.dart';

class Clue extends StatefulWidget {
  const Clue({super.key, required this.data, required this.notifier});

  final ClueData data;
  final Function notifier;

  @override
  State<Clue> createState() => _ClueState();
}

class _ClueState extends State<Clue> {
  List<bool> tracker = clueTracker;

  @override
  void initState() {
    super.initState();
  }

  bool validate(dynamic password) {
    if (password == widget.data.password) {
      widget.notifier();
      tracker[widget.data.index] = true;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ClueData data = widget.data;
    return FittedBox(
        child: SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Column(
        children: [
          Row(children: [
            Text(data.prompt),
          ]),
          Row(
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => data.solver(
                                validate,
                              )),
                    );
                  },
                  icon: const Icon(Icons.scanner),
                  label: const Text("scanner"))
            ],
          )
          // Row(
          //   children: [
          //     Expanded(
          //         child: TextField(
          //             controller: _controller,
          //             onSubmitted: ((String value) => submit(value)))),
          //   ],
          // )
        ],
      ),
    ));
  }
}
