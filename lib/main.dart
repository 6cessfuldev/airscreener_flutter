import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'common/route_manager.dart';
import 'common/style.dart';
import 'provider/flights_info_provider.dart';
import 'screen/checkin_counter_page.dart';
import 'screen/passenger_notice_page.dart';
import 'screen/search_page.dart';
import 'service/preferences_service.dart';

Future main() async {
  await dotenv.load(fileName: "assets/api_key.env");
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService().init();
  runApp(MultiProvider(providers: [
    Provider(create: (_) => FlightsInfoProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteManager.generateRoute,
      home: MyHomePage(title: 'Air Screener'),
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
    return Scaffold(
      extendBody: true,
      backgroundColor: lightestBlueColor,
      appBar: AppBar(
        title: const Text(
          '강미연 화이팅💕',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: darkestBlueColor,
      ),
      body: SafeArea(
        child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: const [
              CheckInCounterPage(),
              SearchPage(),
              PassengerNoticePage(),
            ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: lightBlueColor,
        selectedItemColor: darkestBlueColor,
        unselectedItemColor: Colors.white,
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
              icon: Icon(Icons.luggage_outlined), label: '목록'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(
              icon: Icon(Icons.co_present_outlined), label: '승객 예고'),
        ],
      ),
    );
  }
}
