import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../../auth/controller/auth_controller.dart';

class CommissionerProfilePage extends ConsumerWidget {
  const CommissionerProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commissioner Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) => user == null
            ? const Center(child: Text('No user data'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: user.profileImage != null
                                ? NetworkImage(user.profileImage!)
                                : null,
                            child: user.profileImage == null
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                          const SizedBox(height: AppConstants.defaultPadding),
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Commissioner',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding * 2),
                    _buildSection(context, 'Contact Information', [
                      _buildInfoRow(context, 'Email', user.email),
                      if (user.phoneNumber != null)
                        _buildInfoRow(context, 'Phone', user.phoneNumber!),
                    ]),
                    const SizedBox(height: AppConstants.defaultPadding * 2),
                    _buildSection(context, 'Account Information', [
                      _buildInfoRow(
                        context,
                        'Member Since',
                        _formatDate(user.createdAt),
                      ),
                      _buildInfoRow(
                        context,
                        'Last Updated',
                        _formatDate(user.updatedAt),
                      ),
                    ]),
                    const SizedBox(height: AppConstants.defaultPadding * 2),
                    _buildSection(context, 'Verification Status', [
                      _buildVerificationStatus(context, 'Email', true),
                      _buildVerificationStatus(
                        context,
                        'Phone',
                        user.phoneNumber != null,
                      ),
                      _buildVerificationStatus(context, 'Government ID', false),
                    ]),
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppConstants.defaultPadding),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildVerificationStatus(
    BuildContext context,
    String label,
    bool isVerified,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Row(
            children: [
              Icon(
                isVerified ? Icons.verified : Icons.warning,
                color: isVerified ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                isVerified ? 'Verified' : 'Not Verified',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isVerified ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
