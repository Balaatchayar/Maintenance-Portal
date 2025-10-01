import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/plant_mapping_model.dart';
import '../models/notification_model.dart';
import '../models/pm_details_model.dart';
import '../models/work_order_model.dart';
import '../widgets/notifications_section.dart';
import '../widgets/work_orders_section.dart';
import '../widgets/pm_details_section.dart';
import '../widgets/plant_mapping_section.dart';
import 'login_page.dart';

class DashboardPage extends StatefulWidget {
  final String engineerId;

  const DashboardPage({super.key, required this.engineerId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PlantMappingResponse? _plantMapping;
  NotificationResponse? _notifications;
  PmDetailsResponse? _pmDetails;
  WorkOrderResponse? _workOrders;
  String? _selectedPlantId;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<ApiService>();

      // Load plant mapping and PM details
      final plantMappingFuture = apiService.getPlantMapping(widget.engineerId);
      final pmDetailsFuture = apiService.getPmDetails(widget.engineerId);

      final results = await Future.wait([
        plantMappingFuture,
        pmDetailsFuture,
      ]);

      _plantMapping = results[0] as PlantMappingResponse;
      _pmDetails = results[1] as PmDetailsResponse;

      // Load notifications and work orders for the first plant (if available)
      if (_plantMapping!.plants.isNotEmpty) {
        _selectedPlantId = _plantMapping!.plants.first.plantId;
        await _loadPlantData(_selectedPlantId!);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadPlantData(String plantId) async {
    setState(() => _isLoading = true);

    try {
      final apiService = context.read<ApiService>();
      
      final results = await Future.wait([
        apiService.getNotifications(plantId),
        apiService.getWorkOrders(plantId),
      ]);

      _notifications = results[0] as NotificationResponse;
      _workOrders = results[1] as WorkOrderResponse;
      _selectedPlantId = plantId;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          if (_plantMapping?.plants.isNotEmpty == true)
            PopupMenuButton<String>(
              icon: const Icon(Icons.factory_outlined),
              tooltip: 'Select Plant',
              onSelected: _loadPlantData,
              itemBuilder: (context) => _plantMapping!.plants
                  .map((plant) => PopupMenuItem(
                        value: plant.plantId,
                        child: Text(
                          'Plant ${plant.plantId}',
                          style: TextStyle(
                            fontWeight: plant.plantId == _selectedPlantId
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInitialData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.notifications), text: 'Notifications'),
            Tab(icon: Icon(Icons.work), text: 'Work Orders'),
            Tab(icon: Icon(Icons.engineering), text: 'PM Details'),
            Tab(icon: Icon(Icons.map), text: 'Plant Mapping'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    NotificationsSection(notifications: _notifications),
                    WorkOrdersSection(workOrders: _workOrders),
                    PmDetailsSection(pmDetails: _pmDetails),
                    PlantMappingSection(plantMapping: _plantMapping),
                  ],
                ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Data',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'An unknown error occurred',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loadInitialData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}