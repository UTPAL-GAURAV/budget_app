import 'package:budget_app/View/popups/sideMenu_menu.dart';
import 'package:flutter/material.dart';
import '../../Utils/constants.dart' as constant;
import '../screens/home_screen.dart';
import '../screens/budget_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

var scaffoldKey = GlobalKey<ScaffoldState>();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffF5F5F5),
          drawer: Drawer(child: menuItems(context)),
          appBar: AppBar(
            title: const Text(constant.appName),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Home",
                ),
                Tab(
                  text: "Budget",
                )
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              HomeScreen(),
              BudgetScreen(),
            ],
          ),
        ),
      ),
    );
  }
}


