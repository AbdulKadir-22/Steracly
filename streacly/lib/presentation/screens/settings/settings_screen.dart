import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Light background from design
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ACCOUNT SECTION ---
            const _SectionHeader(title: "ACCOUNT"),
            _SettingsContainer(
              children: [
                _SettingsTile(
                  icon: Icons.person,
                  title: "Edit Profile",
                  subtitle: "Abdulkadir Shaikh",
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.verified,
                  title: "Subscription Plan",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5), // Light Green
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "PRO",
                      style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- PREFERENCES SECTION ---
            const _SectionHeader(title: "PREFERENCES"),
            _SettingsContainer(
              children: [
                _SettingsTile(
                  icon: Icons.notifications,
                  title: "Notifications",
                  isSwitch: true,
                  switchValue: true,
                  onChanged: (val) {},
                ),
                _SettingsTile(
                  icon: Icons.palette,
                  title: "Appearance",
                  trailingText: "Light",
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.calendar_today,
                  title: "Start Week On",
                  trailingText: "Sunday",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- DATA & PRIVACY SECTION ---
            const _SectionHeader(title: "DATA & PRIVACY"),
            _SettingsContainer(
              children: [
                _SettingsTile(
                  icon: Icons.download,
                  title: "Export Data",
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.lock,
                  title: "Privacy Policy",
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.description,
                  title: "Terms of Service",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- ABOUT SECTION ---
            const _SectionHeader(title: "ABOUT"),
            _SettingsContainer(
              children: [
                _SettingsTile(
                  icon: Icons.info,
                  title: "About Streacly",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 40),

            // --- FOOTER ---
            Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Logo Placeholder
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                      ]
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 24),
                    
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Streacly",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Version 1.0.2 (Build 405)",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HELPER WIDGETS ---

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF8F92A1), // Text Secondary
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _SettingsContainer extends StatelessWidget {
  final List<Widget> children;
  const _SettingsContainer({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;
          return Column(
            children: [
              widget,
              if (index != children.length - 1)
                const Divider(height: 1, indent: 60, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? trailingText;
  final bool isSwitch;
  final bool switchValue;
  final Function(bool)? onChanged;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.trailingText,
    this.isSwitch = false,
    this.switchValue = false,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: isSwitch ? null : onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF0FF), // Light blue icon bg
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: Colors.grey[500], fontSize: 12))
          : null,
      trailing: isSwitch
          ? Switch.adaptive(
              value: switchValue,
              activeThumbColor: AppColors.primary,
              onChanged: onChanged,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (trailingText != null)
                  Text(trailingText!, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                if (trailing != null) trailing!,
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),
    );
  }
}