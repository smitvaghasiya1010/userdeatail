import 'package:flutter/material.dart';
import '../models/user.dart';

/// Screen displaying comprehensive details for a selected [User].
class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Header Card
                _buildHeaderCard(context, colorScheme, theme),
                const SizedBox(height: 16),

                // Contact Information Section
                _buildSectionCard(
                  context,
                  title: 'Contact Information',
                  icon: Icons.contact_mail_outlined,
                  children: [
                    _buildInfoTile(
                      context,
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: user.email,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildInfoTile(
                      context,
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      value: user.phone,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildInfoTile(
                      context,
                      icon: Icons.language_outlined,
                      title: 'Website',
                      value: user.website,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Address Section
                _buildSectionCard(
                  context,
                  title: 'Address & Location',
                  icon: Icons.location_on_outlined,
                  children: [
                    _buildInfoTile(
                      context,
                      icon: Icons.home_outlined,
                      title: 'Street & Suite',
                      value: '${user.address.suite.isNotEmpty ? '${user.address.suite}, ' : ''}${user.address.street}',
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildInfoTile(
                      context,
                      icon: Icons.location_city_outlined,
                      title: 'City & Zipcode',
                      value: '${user.address.city}, ${user.address.zipcode}',
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildInfoTile(
                      context,
                      icon: Icons.explore_outlined,
                      title: 'Coordinates',
                      value: 'Lat: ${user.address.geo.lat}, Lng: ${user.address.geo.lng}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Company Section
                _buildSectionCard(
                  context,
                  title: 'Company Details',
                  icon: Icons.business_outlined,
                  children: [
                    _buildInfoTile(
                      context,
                      icon: Icons.domain_outlined,
                      title: 'Company Name',
                      value: user.company.name,
                    ),
                    if (user.company.catchPhrase.isNotEmpty) ...[
                      const Divider(height: 1, indent: 56),
                      _buildInfoTile(
                        context,
                        icon: Icons.format_quote_outlined,
                        title: 'Catchphrase',
                        value: '"${user.company.catchPhrase}"',
                      ),
                    ],
                    if (user.company.bs.isNotEmpty) ...[
                      const Divider(height: 1, indent: 56),
                      _buildInfoTile(
                        context,
                        icon: Icons.work_outline,
                        title: 'Business Strategy',
                        value: user.company.bs,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: colorScheme.primary,
              child: Text(
                user.initials,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '@${user.username}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: colorScheme.surfaceContainerHighest,
        child: Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value.isNotEmpty ? value : 'N/A',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
      dense: true,
    );
  }
}
