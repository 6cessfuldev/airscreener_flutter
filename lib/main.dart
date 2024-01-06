import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'common/style.dart';
import 'screen/checkin_counter_page.dart';

Future main() async {
  await dotenv.load(fileName: "assets/api_key.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: darkBlueColor),
        useMaterial3: true,
      ),
      
      home: const MyHomePage(title: 'Air Screener'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkBlueColor, 
        body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              Container(
                color: Colors.blueGrey,
              ),
              const CheckInCounterPage(),
              Container(
                color: Colors.blueGrey,
              ),
            ]),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: lightBlueColor,
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (mounted) {
              setState(() {
                _selectedIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.backpack_sharp), label: '휴대'),
            BottomNavigationBarItem(
                icon: Icon(Icons.luggage_outlined), label: '위탁'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          ],
        ),
      ),
    );
  }
}
