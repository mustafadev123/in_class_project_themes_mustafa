import 'package:flutter/material.dart';

void main() {
  runApp(const RunMyApp());
}

// Extra feature: keep the online color in the theme too.
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  const AppColors({required this.success});

  @override
  AppColors copyWith({Color? success}) =>
      AppColors(success: success ?? this.success);

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(success: Color.lerp(success, other.success, t)!);
  }
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  // Start with the devices theme.
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Status Card Demo',

      // Extra feature: one seed makes the Material 3 colors.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.grey[200],
        extensions: [AppColors(success: Colors.indigo.shade900)],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        extensions: [AppColors(success: Colors.indigo.shade100)],
      ),
      themeMode: _themeMode,
      // Let the wrapper below handle the apps theme fade.
      themeAnimationDuration: Duration.zero,

      // This context can see the theme inside MaterialApp.
      home: Builder(
        builder: (context) => AnimatedTheme(
          data: Theme.of(context),
          duration: const Duration(milliseconds: 500),
          // Extra feature 4: fade the theme across the whole screen.
          child: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Status Card Demo')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Part 1: avatar and title.
                    CircleAvatar(
                      radius: 45,
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? Colors.teal
                          : Colors.blueGrey,
                      child: const Icon(
                        Icons.person,
                        size: 42,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Flutter Theme Lab',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Part 2, tasks 1 and 3: animate the badge for 400 ms.
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 220,
                      height: 64,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.teal
                            : Colors.amber,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: Theme.of(context)
                                .extension<AppColors>()!
                                .success,
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'Status: Online',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Choose the Theme:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),

                    // Part 1: these buttons change the whole apps theme.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => changeTheme(ThemeMode.light),
                          child: const Text('Light Theme'),
                        ),
                        ElevatedButton(
                          onPressed: () => changeTheme(ThemeMode.dark),
                          child: const Text('Dark Theme'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
