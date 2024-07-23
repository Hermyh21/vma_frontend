import 'package:flutter/material.dart';
import 'package:vma_frontend/src/constants/constants.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Trigger the animation after the page has loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _visible = true;
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About SecureGate',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.customColor,
      leading: IconButton(
        icon: const Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),),
      body: SingleChildScrollView(
        child: Center(
          // Center the content horizontally
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Center(
                //   child: AnimatedOpacity(
                //     opacity: _visible ? 1.0 : 0.0,
                //     duration: const Duration(seconds: 1),
                //     child: Image.asset('assets/about.jpg',
                //         width: 400, height: 500),
                //   ),
                // ),
                const SizedBox(height: 20),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: _visible ? 0 : 50),
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    "What's SecureGate?",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    'SecureGate is a visitors management app designed to streamline the process of managing visitors at the Ethiopian Artificial Intelligence Institute, ensuring security and efficient visitor tracking.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: _visible ? 0 : 50),
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    'About the Institute',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    'The Ethiopian Artificial Intelligence Institute is dedicated to advancing AI technology and research in Ethiopia. The institute aims to foster innovation and develop solutions that benefit industries and communities across the nation.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: _visible ? 0 : 50),
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    'Development Team',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    'Hermela Hailegiorgis - Lead Developer',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: _visible ? 0 : 50),
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    'Contact Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    'Email: info@aiethiopia.org\nPhone: +251 123 456 789',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'App Version 1.0.0',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
