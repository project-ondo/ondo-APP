import 'package:flutter/material.dart';
import 'package:ondo/presentation/home/widgets/home_recent_popular_list.dart';
import 'package:ondo/presentation/home/widgets/home_top_bar.dart';



void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),
    )
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
              HomeTopBar(),

              HomeRecentPopularList(),


            ],
          ),
        ),
      ),
    );
  }
}
