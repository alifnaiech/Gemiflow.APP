import 'package:flutter/material.dart';
import 'package:gemiflow/features/products_categories/pages/categories_page.dart';
import 'package:gemiflow/features/dashboard/pages/dashboard_page.dart';
import 'package:gemiflow/features/products/pages/products_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = DashboardPage();
        break;
      case 1:
        page = ProductsPage();
        break;
      case 2:
        page = CategoriesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  extended: constraints.maxWidth >= 800,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(
                        Icons.dashboard,
                        color: Colors.indigoAccent,
                      ),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.inventory_2_outlined),
                      selectedIcon: Icon(
                        Icons.inventory_2,
                        color: Colors.indigoAccent,
                      ),
                      label: Text('Prodotti'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.category_outlined),
                      selectedIcon: Icon(
                        Icons.category_rounded,
                        color: Colors.indigoAccent,
                      ),
                      label: Text('Categorie'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              VerticalDivider(width: 1),
              Expanded(
                child: ColoredBox(
                  color: Colors.white,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: page,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
