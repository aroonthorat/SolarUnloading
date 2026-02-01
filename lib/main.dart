import 'screens/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SolarUnloadingApp());
}

class SolarUnloadingApp extends StatelessWidget {
  const SolarUnloadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar Unloading App',
      debugShowCheckedModeBanner: false,
      // Reverting to Login Screen for mobile usage
      home: const LoginScreen(), 
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
