import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/drawer/drawer.dart';
import 'package:catalyst/features/home/presentation/views/home_view.dart';
import 'package:catalyst/features/teachers%20corses/presentation/views/teatcher_corses.dart';
import 'package:catalyst/features/my_lessons/presentation/views/my_classes_view.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_navbar/liquid_glass_navbar.dart';
//import 'package:liquid_glass_navbar/liquid_glass_navbar.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _index = 0;

  final items = [
    LiquidGlassNavItem(icon: Icons.home, label: "Home"),
    LiquidGlassNavItem(icon: Icons.class_, label: "My Classes"),
    LiquidGlassNavItem(icon: Icons.school, label: "Classes"),
    LiquidGlassNavItem(icon: Icons.person, label: "Profile"),
  ];

  final pages = [
    const HomeView(),
    const MyClassesView(),
    const TeacherCoursesView(),
    const Scaffold(
      body: Center(child: CustomText(text: "Profile")),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppBar(
        title: items[_index].label,
        actions: [
          if (_index == 0)
            IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),

          if (_index == 3)
            IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      drawer: const CustomDrawer(),
      child: LiquidGlassNavBar(
        bubbleColor: Colors.white,
        backgroundColor: AppColors.color1,
        backgroundOpacity: 0.9,
        itemColor: Colors.white,
        currentIndex: _index,
        onPageChanged: (i) => setState(() => _index = i),
        pages: pages,
        items: items,
        bottomPadding: 16,
        horizontalPadding: 16,
        bubbleBorderWidth: 1,
        bubbleOpacity: 0.4,
      ),
    );
  }
}
