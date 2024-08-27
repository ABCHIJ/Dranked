import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sperro_neu/screens/location_screen.dart';
import 'package:sperro_neu/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'screens/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'provider/category_provider.dart';
import 'provider/product_provider.dart';
import 'screens/auth/email_verify_screen.dart';
import 'screens/main_navigatiion_screen.dart';
import 'screens/auth/phone_auth_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/category/category_list_screen.dart';
import 'screens/category/subcategory_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/post/my_post_screen.dart';
import 'screens/profile_screen.dart';
import 'forms/sell_car_form.dart';
import 'forms/user_form_review.dart';
import 'forms/common_form.dart';
import 'screens/category/product_by_category_screen.dart';
import 'screens/chat/user_chat_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/product/product_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        // Add other providers here if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          WelcomeScreen.id, // Ensure WelcomeScreen.id is correctly defined
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
        LocationScreen.id: (context) => LocationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        EmailVerifyScreen.id: (context) => EmailVerifyScreen(),
        ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
        CategoryListScreen.id: (context) => CategoryListScreen(),
        SubCategoryScreen.id: (context) => SubCategoryScreen(),
        MainNavigationScreen.id: (context) => MainNavigationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        MyPostScreen.id: (context) => MyPostScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        SellCarForm.id: (context) => SellCarForm(),
        UserFormReview.id: (context) => UserFormReview(),
        CommonForm.id: (context) => CommonForm(),
        ProductDetail.id: (context) => ProductDetail(),
        ProductByCategory.id: (context) => ProductByCategory(),
        UserChatScreen.id: (context) => UserChatScreen(),
      },
    );
  }
}
