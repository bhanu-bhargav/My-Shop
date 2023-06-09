import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/auth.dart';
import '/screens/product_overview_screen.dart';
import '/provider/cart.dart';
import '/provider/products.dart';
import '/screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import 'provider/orders.dart';
import 'screens/products_detail_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),

        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token, 
            auth.userId,
            previousProducts == null ? [] : previousProducts.items),
          //create: (ctx) => Products(),
        ),

        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),

        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousProducts) => Orders(
            auth.token, 
            auth.userId,
            previousProducts == null ? [] : previousProducts.orders),
          // create: (ctx) => Orders(),
        ),
      ],
      child: Consumer<Auth>(builder:(ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            fontFamily: 'Lato', colorScheme: ColorScheme.light(primary: Colors.purple).copyWith(secondary: Colors.deepOrange),
          ),
          home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          }),
    ));
  }
}
