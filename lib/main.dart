import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/presentation/viewmodel/number_trivia_view_model.dart';
import 'package:provider/provider.dart';
import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => NumberTriviaViewModel()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: NumberTriviaPage(),
    );
  }
}