import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

void main() {
  Get.put(Controller()); // Initiallise Controller
  runApp(MyApp());
}

class Controller extends GetxController {
  var count = 0.obs;
  void increament() => count++;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: GetMaterialApp(
        // Use GetMaterialApp
        title: 'Today\'s flutter app',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 169, 243, 169)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isClicked = false; // Button state

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    final Controller c = Get.find(); // 使用全局 Controller

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
            backgroundColor: Colors.green[100],
            extended: false,
            destinations: [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(
                  icon: Icon(Icons.favorite), label: Text('Favourites')),
            ],
            selectedIndex: 0,
            onDestinationSelected: (value) => print('selected: $value'),
          )),
          Expanded(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigCard(pair: pair), // Show the current word pair
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isClicked = !isClicked; // Toggle the state
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            isClicked ? Icons.favorite : Icons.favorite_outline,
                            color: isClicked ? Colors.red : Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Text('Like'),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () {
                          c.increament();
                        },
                        child: Icon(Icons.add)),
                    SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () {
                          Get.to(NextPage());
                        },
                        child: Icon(Icons.next_plan))
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  BigCard({
    super.key,
    required this.pair,
  });

  final Controller c = Get.find();

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
        color: theme.colorScheme.primary,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(() => Text(
                  c.count.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ))));
  }
}

class NextPage extends StatelessWidget {
  final Controller c = Get.find();
  NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hello, this is the next page'),
          backgroundColor: const Color.fromARGB(255, 238, 153, 220),
        ),
        body: SafeArea(
          child: Text(
              "Hello, welcome to the next page. The counter number is: ${c.count}",
              style: TextStyle(
                  color: const Color.fromARGB(255, 54, 41, 228), fontSize: 20)),
        ));
  }
}
