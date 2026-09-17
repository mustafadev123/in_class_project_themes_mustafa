import 'package:flutter/material.dart';

void main() {
  runApp(const RunMyApp());
}

// Extra feature 3: keep our online status color in the theme too.
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  const AppColors({required this.success});

  // Keep the old color if theres no new one passed in.
  @override
  AppColors copyWith({Color? success}) =>
      AppColors(success: success ?? this.success);

  // Blend the two status colors while the theme is changing.
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
    // Rebuild with the mode picked from either button.
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Status Card Demo',

      // Extra feature 1: Flutter makes the palette from this purple seed.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.grey[200],
        // Register our extra color so widgets can get it from the theme.
        extensions: [AppColors(success: Colors.indigo.shade900)],
      ),
      // darkertheme seed
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        // A lighter status dot is easier to see on the teal badge.So added for good UX
        extensions: [AppColors(success: Colors.indigo.shade100)],
      ),
      themeMode: _themeMode,
      // Let the wrapper below handle the apps theme fade.
      themeAnimationDuration: Duration.zero,

      // This context can see the theme inside MaterialApp.
      home: Builder(
        // Extra feature 4: fade the theme across the whole screen.
        builder: (context) => AnimatedTheme(
          data: Theme.of(context),
          // Half a second gives the colors a little time to blend.
          duration: const Duration(milliseconds: 500),
          // Widgets below need to read this animated theme as it changes.
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

                    
                    // The badge gets its own color animation when modes change.
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
                          // Extra feature 3: use the status color we stored above.
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
