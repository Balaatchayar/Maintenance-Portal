import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/work_order_model.dart';

class WorkOrdersSection extends StatefulWidget {
  final WorkOrderResponse? workOrders;

  const WorkOrdersSection({super.key, this.workOrders});

  @override
  State<WorkOrdersSection> createState() => _WorkOrdersSectionState();
}

class _WorkOrdersSectionState extends State<WorkOrdersSection> {
  bool _showOnlyOpen = false;

  @override
  Widget build(BuildContext context) {
    if (widget.workOrders == null) {
      return const Center(
        child: Text('No work orders data available'),
      );
    }

    final allOrders = widget.workOrders!.workOrders;
    final filteredOrders = _showOnlyOpen
        ? allOrders.where((order) => order.isOpen).toList()
        : allOrders;

    return Column(
      children: [
        // Filter Controls
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'Plant: ${widget.workOrders!.plantId}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              FilterChip(
                label: const Text('Open Only'),
                selected: _showOnlyOpen,
                onSelected: (selected) => setState(() => _showOnlyOpen = selected),
              ),
            ],
          ),
        ),

        // Statistics
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  allOrders.length.toString(),
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Open',
                  allOrders.where((order) => order.isOpen).length.toString(),
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Closed',
                  allOrders.where((order) => !order.isOpen).length.toString(),
                  Colors.green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Work Orders List
        Expanded(
          child: filteredOrders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _showOnlyOpen
                            ? 'No open work orders'
                            : 'No work orders available',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return _buildWorkOrderCard(order);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkOrderCard(WorkOrder order) {
    final isOpen = order.isOpen;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isOpen ? Colors.orange : Colors.green,
          child: Icon(
            isOpen ? Icons.build : Icons.check_circle,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          order.description ?? 'No description',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (order.orderNumber != null)
              Text('Order: ${order.orderNumber}'),
            if (order.orderType != null)
              Text('Type: ${order.orderType}'),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (order.shortText != null) ...[
                  Text(
                    'Short Text:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(order.shortText!),
                  const SizedBox(height: 8),
                ],
                if (order.longText != null) ...[
                  Text(
                    'Long Text:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(order.longText!),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    if (order.startDate != null) ...[
                      Icon(
                        Icons.play_arrow,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text('Start: ${_formatDate(order.startDate!)}'),
                      const SizedBox(width: 16),
                    ],
                    if (order.endDate != null && order.endDate!.isNotEmpty) ...[
                      Icon(
                        Icons.stop,
                        size: 16,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text('End: ${_formatDate(order.endDate!)}'),
                    ],
                  ],
                ),
                if (order.equipmentNumber.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.precision_manufacturing, size: 16),
                      const SizedBox(width: 4),
                      Text('Equipment: ${order.equipmentNumber}'),
                    ],
                  ),
                ],
                if (order.costCenter != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.account_balance_wallet, size: 16),
                      const SizedBox(width: 4),
                      Text('Cost Center: ${order.costCenter}'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}