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
          drawer: Drawer(child: menuItems(context)),
          appBar: AppBar(
            title: Text(constant.appName),
            bottom: TabBar(
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
          body: TabBarView(
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


