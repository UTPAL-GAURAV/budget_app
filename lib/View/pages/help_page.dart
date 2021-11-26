import '../../utils/constants.dart' as constant;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:  const Text(constant.appName+"  (Help)"),),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white , Colors.blueAccent.withOpacity(0.4)],
                // stops: [0.4, 1],
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.center, child: Text("FAQ", style: TextStyle(fontWeight: FontWeight.w800),)),
                Container(height: 30),

                Text("Is my data safe?", style: TextStyle(fontWeight: FontWeight.w600),),
                Text("Yes, your data never leaves your device.", style: TextStyle(fontWeight: FontWeight.w400)),
                Container(height: 20),

                Text("What is 'your worth'?", style: TextStyle(fontWeight: FontWeight.w600),),
                Text("Your worth is the total amount of money you will be left with after you return all your loans,"
                    " your borrowers return money to you, added with  your total budget investment.", style: TextStyle(fontWeight: FontWeight.w400)),
                Container(height: 20),

                Text("What is expense & investment in budget?", style: TextStyle(fontWeight: FontWeight.w600),),
                Text("Spending money in assets like cryptos, land, gold, stocks, etc. are considered as"
                    "investment and it does not affect 'your worth', but spending on liabilities like car, pet, "
                    "fashion, etc are counted as expense and affects 'your worth'.", style: TextStyle(fontWeight: FontWeight.w400)),
                Container(height: 20),

                Text("How to backup my data?", style: TextStyle(fontWeight: FontWeight.w600),),
                Text("As we have said that your data never leaves your device, there's no backup option.", style: TextStyle(fontWeight: FontWeight.w400)),
                Container(height: 20),

                Text("Upcoming features v1.0 -", style: TextStyle(fontWeight: FontWeight.w600),),
                Text("Better UI, dark mode, split bills, expense overview, and more.", style: TextStyle(fontWeight: FontWeight.w400)),
                Container(height: 20),

              ],
            ),
          ),
        )
    );
  }
}
