import 'package:flutter/material.dart';
import 'package:sharing_into_flutter_app/pages/homepage.dart';

void bootstrap(String env) => runApp(MyApp(env: env));

class MyApp extends StatelessWidget {
  const MyApp({
    required this.env,
    super.key,
  });
  final String env;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        if (env == 'production') return child!;
        return Banner(
          message: env.toUpperCase(),
          location: BannerLocation.topEnd,
          child: child,
        );
      },
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
