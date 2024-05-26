import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box? _todosBox;
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Hive.openBox("todos_box").then((_box) {
      setState(() {
        _todosBox = _box;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Note It",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: _bhuildUi(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bhuildUi() {
    if (_todosBox == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ValueListenableBuilder(
        valueListenable: _todosBox!.listenable(),
        builder: (context, box, widget) {
          final todosKeys = box.keys.toList();

          return SizedBox.expand(
            child: ListView.builder(
                itemCount: todosKeys.length,
                itemBuilder: (context, index) {
                  Map todo = _todosBox!.get(todosKeys[index]);
                  return ListTile(
                    title: Text(
                      todo["content"],
                    ),
                    subtitle: Text(todo["time"].toString()),
                    onLongPress: () async {
                      await _todosBox!.delete(todosKeys[index]);
                    },
                    trailing: Checkbox(
                        value: todo["isDone"],
                        onChanged: (value) async {
                          todo["isDone"] = value;
                          await _todosBox!.put(todosKeys[index], todo);
                        }),
                  );
                }),
          );
        });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add A Todo"),
            content: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(hintText: "Todos"),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  _todosBox?.add({
                    "content": _textEditingController.text,
                    "time": DateTime.now(),
                    "isDone": false,
                  });
                  Navigator.pop(context);
                  _textEditingController.clear();
                },
                color: Colors.redAccent,
                textColor: Colors.white,
                child: const Text("OK"),
              )
            ],
          );
        });
  }
}
