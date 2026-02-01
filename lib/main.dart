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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Temporarily set to Admin Dashboard for testing
      home: const AdminDashboardScreen(), 
      routes: {
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
      },
    );
  }
}
