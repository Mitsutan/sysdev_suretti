import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum OptionLabel {
  option1('宿泊地'),
  option2('観光地'),
  option3('飲食店'),

  optionError('error');

  const OptionLabel(this.label);
  final String label;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Settings',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Test(title: 'Flutter Demo Home Page'),
    );
  }
}

class Test extends StatefulWidget {
  const Test({super.key, required this.title});
  final String title;

  @override
  State<Test> createState() => _MyAppState();
}

class _MyAppState extends State<Test> {
  OptionLabel? selectedOption1;
  OptionLabel? selectedOption2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownMenu<OptionLabel>(
                width: 400,
                requestFocusOnTap: true,
                enableSearch: true,
                enableFilter: true,
                label: const Text('カテゴリー'),
                onSelected: (OptionLabel? option) {
                  setState(() {
                    selectedOption1 = option;
                  });
                },
                dropdownMenuEntries: OptionLabel.values
                    .map<DropdownMenuEntry<OptionLabel>>((OptionLabel option) {
                  return DropdownMenuEntry<OptionLabel>(
                    value: option,
                    label: option.label,
                    style: MenuItemButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 400,
                child: TextFormField(
                  cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                  decoration: InputDecoration(
                    labelText: 'おすすめの場所',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 400,
                child: TextFormField(
                  cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                  decoration: InputDecoration(
                    labelText: '住所',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 400,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 5,
                  cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                  decoration: InputDecoration(
                    labelText: 'メッセージ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  // フォームが送信されたときの処理を記述
                },
                child: const Text('送信'),
              )
            ],
          ),
        ));
  }
}
