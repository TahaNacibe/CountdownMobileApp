import 'package:countdown_mobile/auth/auth_services.dart';
import 'package:countdown_mobile/dialogs/sign_out.dart';
import 'package:countdown_mobile/providers/theme_provider.dart';
import 'package:countdown_mobile/screens/welcomeScreen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  AuthServices authServices = AuthServices();
  // State variables for toggleable settings
  bool _notificationsEnabled = true;
  bool _locationEnabled = false;

  // Custom section widget to create grouped settings with a title
  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(children: children),
      ],
    );
  }

  // Custom settings item with dividers
  Widget _buildSettingsItem({
    required String label,
    String? desc,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Container(
      // color: Colors.white,
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Icon(icon),
            title: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: desc != null
                ? Text(
                    desc,
                    style: TextStyle(),
                  )
                : null,
            trailing:
                trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: onTap,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: [
          // Preferences Section
          _buildSettingsSection(
            title: 'Preferences',
            children: [
              // Notifications Setting
              _buildSettingsItem(
                label: "Notifications",
                desc: "Receive app notifications",
                icon: Icons.notifications_outlined,
                trailing: Switch(
                  inactiveThumbColor: Theme.of(context).iconTheme.color,
                  activeTrackColor: Colors.teal.withOpacity(.4),
                  activeColor: Colors.teal,
                  value: _notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ),

              // Dark Mode Setting
              _buildSettingsItem(
                label: "Dark Mode",
                desc: "Switch between light and dark themes",
                icon: Icons.dark_mode_outlined,
                trailing: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                  return Switch(
                    inactiveThumbColor: Theme.of(context).iconTheme.color,
                    activeTrackColor: Colors.teal.withOpacity(.4),
                    activeColor: Colors.teal,
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (bool value) {
                      setState(() {
                        themeProvider.toggleTheme(value);
                      });
                    },
                  );
                }),
              ),

              // Location Services
              _buildSettingsItem(
                label: "Location Services",
                desc: "Allow app to access your location",
                icon: Icons.location_on_outlined,
                trailing: Switch(
                  inactiveThumbColor: Theme.of(context).iconTheme.color,
                  activeTrackColor: Colors.teal.withOpacity(.4),
                  activeColor: Colors.teal,
                  value: _locationEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _locationEnabled = value;
                    });
                  },
                ),
                showDivider: false,
              ),
            ],
          ),

          // Account Section
          _buildSettingsSection(
            title: 'Account',
            children: [
              // Profile Settings
              _buildSettingsItem(
                label: "Edit Profile",
                desc: "Change your personal information",
                icon: Icons.person_outline,
                onTap: () {
                  // Navigate to profile edit page
                },
              ),

              // Security Settings
              _buildSettingsItem(
                label: "Security",
                desc: "Manage password and security",
                icon: Icons.security_outlined,
                onTap: () {
                  // Navigate to security settings
                },
              ),

              // log out Settings
              _buildSettingsItem(
                label: "Log out",
                desc: "Log out of your account",
                icon: Ionicons.log_out_outline,
                onTap: () async {
                  bool answer = await showLogoutDialog(context);
                  if (answer) {
                    authServices.signUserOut().then((_) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
                    });
                  }
                },
              ),

              // Privacy Settings
              _buildSettingsItem(
                label: "Privacy",
                desc: "Control your data and privacy",
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  // Navigate to privacy settings
                },
                showDivider: false,
              ),
            ],
          ),

          // Support Section
          _buildSettingsSection(
            title: 'Support',
            children: [
              // Help Center
              _buildSettingsItem(
                label: "Help Center",
                desc: "Get assistance and answers",
                icon: Icons.help_outline,
                onTap: () {
                  // Navigate to help center
                },
              ),

              // Contact Support
              _buildSettingsItem(
                label: "Contact Support",
                desc: "Reach out to our support team",
                icon: Icons.support_agent_outlined,
                onTap: () {
                  // Navigate to contact support
                },
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
