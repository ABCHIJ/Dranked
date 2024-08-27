import 'package:sperro_neu/constants/colors.dart';
import 'package:sperro_neu/screens/category/category_list_screen.dart';
import 'package:sperro_neu/screens/chat/chat_screen.dart';
import 'package:sperro_neu/screens/home_screen.dart';
import 'package:sperro_neu/screens/post/my_post_screen.dart';
import 'package:sperro_neu/screens/profile_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String id = 'main_nav_screen';
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  List<Widget> pages = [
    const HomeScreen(),
    const ChatScreen(),
    const CategoryListScreen(isForForm: true),
    const MyPostScreen(),
    const ProfileScreen(),
  ];
  PageController controller = PageController();
  int _index = 0;

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("More Options",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                  "Here you can add more interactive options or details for the user.",
                  style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  _bottomNavigationBar() {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: DotNavigationBar(
        backgroundColor: blackColor,
        margin: EdgeInsets.zero,
        paddingR: EdgeInsets.zero,
        selectedItemColor: secondaryColor,
        currentIndex: _index,
        dotIndicatorColor: Colors.transparent,
        unselectedItemColor: disabledColor,
        enablePaddingAnimation: true,
        enableFloatingNavBar: false,
        onTap: (index) {
          setState(() {
            _index = index;
          });
          controller.jumpToPage(index);
          if (index == 2) {
            // Suppose we want to show the bottom sheet when the third icon is tapped
            _showModalBottomSheet(context);
          }
        },
        items: [
          DotNavigationBarItem(
            icon: Icon(Icons.home,
                color: _index == 0 ? secondaryColor : disabledColor),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.chat,
                color: _index == 1 ? secondaryColor : disabledColor),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.add,
                color: _index == 2 ? secondaryColor : disabledColor),
          ),
          DotNavigationBarItem(
            icon: Icon(
                _index == 3 ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: _index == 3 ? secondaryColor : disabledColor),
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.person,
                color: _index == 4 ? secondaryColor : disabledColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: PageView.builder(
            itemCount: pages.length,
            controller: controller,
            onPageChanged: (page) {
              setState(() {
                _index = page;
              });
            },
            itemBuilder: (context, position) {
              return pages[position];
            }),
        bottomNavigationBar: _bottomNavigationBar());
  }
}
