import 'package:decora/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InvitationDialog extends StatelessWidget {
  const InvitationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 30),
                Text(
                  AppLocalizations.of(context)!.invitation,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Icons row
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SocialIcon(
                  icon: FontAwesomeIcons.link,
                  color: Color(0xFF1976D2),
                ),
                _SocialIcon(
                  icon: FontAwesomeIcons.whatsapp,
                  color: Color(0xFF25D366),
                ),
                _SocialIcon(
                  icon: FontAwesomeIcons.telegram,
                  color: Color(0xFF26A4E3),
                ),
                _SocialIcon(
                  icon: FontAwesomeIcons.facebookMessenger,
                  color: Color(0xFF9C27B0),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 🔹 Label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.enter_user_name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Text Field
            TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enter_user_name,
                hintStyle: TextStyle(color: Colors.grey[500]),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Invite Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF47654D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.invite,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SocialIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: color,
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}
