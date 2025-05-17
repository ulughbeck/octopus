import 'package:example/src/common/router/routes.dart';
import 'package:example/src/feature/shop/widget/shop_scope.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

/// {@template shop_screen}
/// ShopScreen widget.
/// {@endtemplate}
class ShopScreen extends StatefulWidget {
  /// {@macro shop_screen}
  const ShopScreen({super.key});

  static const String tabIdentifier = 'tab';
  static String catalogTab = '${Routes.catalog.name}-$tabIdentifier';
  static String basketTab = '${Routes.basket.name}-$tabIdentifier';
  static String favoritesTab = '${Routes.favorites.name}-$tabIdentifier';

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) => OctopusTabs(
        tabIdentifier: ShopScreen.tabIdentifier,
        root: Routes.shop,
        tabs: const [
          Routes.catalog,
          Routes.basket,
          Routes.favorites,
        ],
        builder: (context, child, currentIndex, onTabPressed) => ShopScope(
          child: Scaffold(
            body: NoAnimationScope(child: child),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.shop),
                  label: 'Catalog',
                  backgroundColor: Colors.green,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_basket),
                  label: 'Basket',
                  backgroundColor: Colors.blue,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                  backgroundColor: Colors.pink,
                ),
              ],
              currentIndex: currentIndex,
              selectedItemColor: Colors.amber[800],
              onTap: onTabPressed,
              // onTap: (index) {
              //   onTabPressed.call(index);
              //   if (index == currentIndex) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //         content: Text('Popped to tab root at double tap'),
              //         backgroundColor: Colors.green,
              //       ),
              //     );
              //   }
              // },
            ),
          ),
        ),
      );
}
