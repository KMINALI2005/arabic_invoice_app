import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/invoice_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => InvoiceProvider())],
      child: MaterialApp(
        title: 'تطبيق الفواتير',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: const Color(0xFFEF6C00), colorScheme: ColorScheme.fromSwatch().copyWith(primary: const Color(0xFFEF6C00))),
        home: const HomeScreen(),
      ),
    );
  }
}
