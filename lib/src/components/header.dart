import 'package:flutter/material.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:vma_frontend/src/services/auth_services.dart';

typedef NavigationCallback = void Function(String route);

class Header extends StatelessWidget implements PreferredSizeWidget {
  final NavigationCallback onNavigate;

  Header({Key? key, required this.onNavigate}) : super(key: key);

  void logoutUser(BuildContext context) {
    AuthService().logout(context);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Constants.customColor,
      title: const Text(
        'Secure Gate',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        if (MediaQuery.of(context).size.width > 600) ...[
          _buildTextButton('Home', () => onNavigate('/')),
          _buildTextButton('About', () => onNavigate('/about')),
          // _buildTextButton('Settings', () => onNavigate('/settings')),
          TextButton(
            onPressed: () => logoutUser(context),
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ] else
          Padding(
            padding: const EdgeInsets.only(left: 15.0), // Add left padding here
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              onSelected: (String value) {
                if (value == '/logout') {
                  logoutUser(context);
                } else {
                  onNavigate(value);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: '/', child: Text('Home')),
                const PopupMenuItem<String>(
                    value: '/about', child: Text('About')),
                // const PopupMenuItem<String>(
                //     value: '/settings', child: Text('Settings')),
                const PopupMenuItem<String>(
                    value: '/logout', child: Text('Log Out')),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTextButton(String label, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
