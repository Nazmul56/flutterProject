import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'about_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _updater = ShorebirdUpdater();
  late final bool _isUpdaterAvailable;
  var _currentTrack = UpdateTrack.stable;
  var _isCheckingForUpdates = false;
  Patch? _currentPatch;

  @override
  void initState() {
    super.initState();
    // Check whether Shorebird is available.
    setState(() => _isUpdaterAvailable = _updater.isAvailable);

    // Read the current patch (if there is one.)
    // `currentPatch` will be `null` if no patch is installed.
    _updater.readCurrentPatch().then((currentPatch) {
      setState(() => _currentPatch = currentPatch);
    }).catchError((Object error) {
      // If an error occurs, we log it for now.
      debugPrint('Error reading current patch: $error');
    });
  }

  Future<void> _checkForUpdate() async {
    if (_isCheckingForUpdates) return;

    try {
      setState(() => _isCheckingForUpdates = true);
      // Check if there's an update available.
      final status = await _updater.checkForUpdate(track: _currentTrack);
      if (!mounted) return;
      // If there is an update available, show a banner.
      switch (status) {
        case UpdateStatus.upToDate:
          _showNoUpdateAvailableBanner();
        case UpdateStatus.outdated:
          _showUpdateAvailableBanner();
        case UpdateStatus.restartRequired:
          _showRestartBanner();
        case UpdateStatus.unavailable:
        // Do nothing, there is already a warning displayed at the top of the
        // screen.
      }
    } catch (error) {
      // If an error occurs, we log it for now.
      debugPrint('Error checking for update: $error');
    } finally {
      setState(() => _isCheckingForUpdates = false);
    }
  }

  void _showDownloadingBanner() {
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        const MaterialBanner(
          content: Text('Downloading...'),
          actions: [
            SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
  }

  void _showUpdateAvailableBanner() {
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content: Text(
            'Update available for the ${_currentTrack.name} track.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                await _downloadUpdate();
                if (!mounted) return;
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('Download'),
            ),
          ],
        ),
      );
  }

  void _showNoUpdateAvailableBanner() {
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content: Text(
            'No update available on the ${_currentTrack.name} track.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
  }

  void _showRestartBanner() {
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content: const Text('A new patch is ready! Please restart your app.'),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
  }

  void _showErrorBanner(Object error) {
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content: Text(
            'An error occurred while downloading the update: $error.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
  }

  Future<void> _downloadUpdate() async {
    _showDownloadingBanner();
    try {
      // Perform the update (e.g download the latest patch on [_currentTrack]).
      // Note that [track] is optional. Not passing it will default to the
      // stable track.
      await _updater.update(track: _currentTrack);
      if (!mounted) return;
      // Show a banner to inform the user that the update is ready and that they
      // need to restart the app.
      _showRestartBanner();
    } on UpdateException catch (error) {
      // If an error occurs, we show a banner with the error message.
      _showErrorBanner(error.message);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform login logic
      String username = _usernameController.text;
      String password = _passwordController.text;
      // Implement your login logic here
      print('Username: $username, Password: $password');

      loginUser();
    }
  }

  void loginUser() async {
    final url = Uri.parse('https://dummyjson.com/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': 'emilys',
        'password': 'emilyspass',
        'expiresInMins': 30, // optional, defaults to 60
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);

      // Navigator.push(
      //   context,
      //   //MaterialPageRoute(builder: (context) => SecondScreen()),
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );s

      Navigator.pushNamed(context, '/home');
    } else {
      print('Failed to login: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    final List<Widget> aboutBoxChildren = <Widget>[
      const SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text: "Flutter is Google's UI toolkit for building beautiful, "
                    'natively compiled applications for mobile, web, and desktop '
                    'from a single codebase. Learn more about Flutter at '),
            TextSpan(
                style: textStyle.copyWith(color: theme.colorScheme.primary),
                text: 'https://flutter.dev'),
            TextSpan(style: textStyle, text: '.'),
          ],
        ),
      ),
    ];

    return Scaffold(
      // appBar: AppBar(
      //     //title: Text('Login Page'),
      //     ),
      backgroundColor: Colors.lightBlue.shade50,
      body: Center( child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            Column(
              children: [
                if (!_isUpdaterAvailable) const _ShorebirdUnavailable(),
                //const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Patch update', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 10),
                    Text("Current patch: ${_currentPatch?.number ?? "No Patch"}"),
                  ],
                ),
                const SizedBox(height: 12),
                _TrackPicker(
                  currentTrack: _currentTrack,
                  onChanged: (track) {
                    setState(() => _currentTrack = track);
                  },
                ),
                //const Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            Image.network(
              'https://picsum.photos/id/127/400/200',
              width: 400,
              height: 200,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const CircularProgressIndicator();
              },
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('About'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ))
      ),

        floatingActionButton: FloatingActionButton(
        onPressed: _isCheckingForUpdates ? null : _checkForUpdate,
    tooltip: 'Check for update',
    child: _isCheckingForUpdates
        ? const _LoadingIndicator()
        : const Icon(CupertinoIcons.refresh),
    ),
    );
  }
}

/// Widget that is mounted when Shorebird is not available.
class _ShorebirdUnavailable extends StatelessWidget {
  const _ShorebirdUnavailable();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  Center(
      child: Text(
        '''
Shorebird is not available.
Please make sure the app was generated via `shorebird release` and that it is running in release mode.''',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}

/// Widget that displays the current patch version.
class _CurrentPatchVersion extends StatelessWidget {
  const _CurrentPatchVersion({required this.patch});

  final Patch? patch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Current patch version:'),
          Text(
            patch != null ? '${patch!.number}' : 'No patch installed',
            style: theme.textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}

/// Widget that allows selection of update track.
class _TrackPicker extends StatelessWidget {
  const _TrackPicker({
    required this.currentTrack,
    required this.onChanged,
  });

  final UpdateTrack currentTrack;

  final ValueChanged<UpdateTrack> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Update track:'),
        SegmentedButton<UpdateTrack>(
          segments: [
            const ButtonSegment(
              label: Text('Stable'),
              icon: Icon(CupertinoIcons.hammer_fill),
              value: UpdateTrack.stable,
            ),
            const ButtonSegment(
              label: Text('Beta'),
              icon: Icon(CupertinoIcons.rocket),
              value: UpdateTrack.beta,
            ),
            ButtonSegment(
              label: const Text('Staging-'),
              icon: Image.network(
                'https://img.icons8.com/ios/50/ant.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const CircularProgressIndicator();
                },
              ),
              value: UpdateTrack.staging,
            ),
          ],
          selected: {currentTrack},
          onSelectionChanged: (tracks) => onChanged(tracks.single),
        ),
      ],
    );
  }
}

/// A reusable loading indicator.
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 14,
      width: 14,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
