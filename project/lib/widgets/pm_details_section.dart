import 'package:flutter/material.dart';
import '../models/pm_details_model.dart';

class PmDetailsSection extends StatelessWidget {
  final PmDetailsResponse? pmDetails;

  const PmDetailsSection({super.key, this.pmDetails});

  @override
  Widget build(BuildContext context) {
    if (pmDetails == null) {
      return const Center(
        child: Text('No PM details data available'),
      );
    }

    if (pmDetails!.pmDetails.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.engineering_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No PM details available',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.engineering,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Engineer: ${pmDetails!.engineerId}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: pmDetails!.pmDetails.length,
            itemBuilder: (context, index) {
              final detail = pmDetails!.pmDetails[index];
              return _buildPmDetailCard(detail, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPmDetailCard(PmDetail detail, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.factory,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.name ?? 'Unknown Plant',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (detail.plant != null)
                        Text(
                          'Plant ID: ${detail.plant}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              Icons.location_city,
              'City',
              detail.city ?? 'N/A',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.map,
              'Region',
              detail.region ?? 'N/A',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.public,
              'Country',
              detail.country ?? 'N/A',
            ),
            if (detail.engineerId != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                Icons.person,
                'Engineer ID',
                detail.engineerId!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}