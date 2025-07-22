import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class GuidesPage extends StatelessWidget {
  const GuidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guides')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _buildGuideSection(context, 'Getting Started', [
            'How to Search for Places',
            'Booking Process',
            'Payment Methods',
            'Cancellation Policy',
          ]),
          const SizedBox(height: AppConstants.defaultPadding * 2),
          _buildGuideSection(context, 'For Tenants', [
            'Your Rights and Responsibilities',
            'Communication with Hosts',
            'Extending Your Stay',
            'Reporting Issues',
          ]),
          const SizedBox(height: AppConstants.defaultPadding * 2),
          _buildGuideSection(context, 'For Hosts', [
            'Listing Your Property',
            'Setting House Rules',
            'Managing Bookings',
            'Host Protection Insurance',
          ]),
          const SizedBox(height: AppConstants.defaultPadding * 2),
          _buildGuideSection(context, 'Safety & Security', [
            'Safety Guidelines',
            'Emergency Contacts',
            'Privacy Policy',
            'Terms of Service',
          ]),
        ],
      ),
    );
  }

  Widget _buildGuideSection(
    BuildContext context,
    String title,
    List<String> guides,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppConstants.defaultPadding),
        ...guides.map((guide) => _buildGuideItem(context, guide)),
      ],
    );
  }

  Widget _buildGuideItem(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: Navigate to guide detail
        },
      ),
    );
  }
}
