import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/database/models/health_measurement.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/measurement_repository.dart';
import 'measurement_form_page.dart';

enum PeriodFilter { days7, days15, days30, all }

class MeasurementsPage extends StatefulWidget {
  const MeasurementsPage({super.key});

  @override
  State<MeasurementsPage> createState() => _MeasurementsPageState();
}

class _MeasurementsPageState extends State<MeasurementsPage> {
  final _repository = MeasurementRepository();
  bool _isLoading = true;
  List<HealthMeasurement> _records = [];

  String _selectedType = 'blood_pressure';
  PeriodFilter _selectedPeriod = PeriodFilter.days7;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    DateTime? startDate;
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case PeriodFilter.days7:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case PeriodFilter.days15:
        startDate = now.subtract(const Duration(days: 15));
        break;
      case PeriodFilter.days30:
        startDate = now.subtract(const Duration(days: 30));
        break;
      case PeriodFilter.all:
        startDate = null;
        break;
    }

    final data = await _repository.getMeasurements(
      type: _selectedType,
      start: startDate,
      end: startDate != null ? now : null,
    );

    if (!mounted) return;

    setState(() {
      _records = data;
      _isLoading = false;
    });
  }

  void _addMeasurement() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MeasurementFormPage()),
    );
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aferições de Saúde'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTypeFilters(),
            _buildPeriodFilter(),
            const Divider(),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_records.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Nenhum registro para este período.'),
                ),
              )
            else ...[
              _buildSummaryCard(),
              _buildChartSection(),
              const Divider(),
              _buildListSection(),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMeasurement,
        icon: const Icon(Icons.add),
        label: const Text('Nova Aferição'),
      ),
    );
  }

  Widget _buildTypeFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _typeChip(
              'Pressão Arterial',
              'blood_pressure',
              Icons.favorite,
              Colors.red,
            ),
            const SizedBox(width: AppSpacing.sm),
            _typeChip('Saturação (O2)', 'blood_oxygen', Icons.air, Colors.blue),
            const SizedBox(width: AppSpacing.sm),
            _typeChip(
              'Glicemia',
              'blood_sugar',
              Icons.bloodtype,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(String label, String type, IconData icon, Color color) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      avatar: Icon(icon, color: isSelected ? Colors.white : color, size: 18),
      label: Text(label),
      selected: isSelected,
      selectedColor: color,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      onSelected: (val) {
        if (val) {
          setState(() => _selectedType = type);
          _loadData();
        }
      },
    );
  }

  Widget _buildPeriodFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Período de visualização: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<PeriodFilter>(
            value: _selectedPeriod,
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedPeriod = val);
                _loadData();
              }
            },
            items: const [
              DropdownMenuItem(
                value: PeriodFilter.days7,
                child: Text('Últimos 7 dias'),
              ),
              DropdownMenuItem(
                value: PeriodFilter.days15,
                child: Text('Últimos 15 dias'),
              ),
              DropdownMenuItem(
                value: PeriodFilter.days30,
                child: Text('Últimos 30 dias'),
              ),
              DropdownMenuItem(
                value: PeriodFilter.all,
                child: Text('Todo o histórico'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    if (_records.isEmpty) return const SizedBox.shrink();

    double minVal = _records.first.primaryValue;
    double maxVal = _records.first.primaryValue;
    double sumVal = 0;

    for (var r in _records) {
      if (r.primaryValue < minVal) minVal = r.primaryValue;
      if (r.primaryValue > maxVal) maxVal = r.primaryValue;
      sumVal += r.primaryValue;
    }
    double avgVal = sumVal / _records.length;
    final unit = _records.first.unit ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Card(
        color: Colors.grey.shade100,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem('Média', '${avgVal.toStringAsFixed(1)} $unit'),
              _summaryItem('Mínima', '${minVal.toStringAsFixed(0)} $unit'),
              _summaryItem('Máxima', '${maxVal.toStringAsFixed(0)} $unit'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    if (_records.length < 2) {
      return Container(
        height: 150,
        alignment: Alignment.center,
        child: const Text(
          'Adicione mais de um registro para ver a evolução.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final reversed = _records.reversed.toList();
    List<FlSpot> primarySpots = [];
    List<FlSpot> secondarySpots = [];

    // Map datetime to ms to plot properly on X axis
    double minX = reversed.first.measuredAt.millisecondsSinceEpoch.toDouble();
    double maxX = reversed.last.measuredAt.millisecondsSinceEpoch.toDouble();

    if (minX == maxX) {
      minX -= 1000;
      maxX += 1000;
    }

    for (var r in reversed) {
      final x = r.measuredAt.millisecondsSinceEpoch.toDouble();
      primarySpots.add(FlSpot(x, r.primaryValue));
      if (r.secondaryValue != null) {
        secondarySpots.add(FlSpot(x, r.secondaryValue!));
      }
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: 0,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final dt = DateTime.fromMillisecondsSinceEpoch(
                    spot.x.toInt(),
                  );
                  final formattedDate =
                      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  return LineTooltipItem(
                    '$formattedDate\n${spot.y}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Mostra apenas os labels de acordo com a disponibilidade de espacamento
                  if (value == minX || value == maxX) {
                    return const SizedBox.shrink();
                  }
                  final dt = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${dt.day}/${dt.month}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  );
                },
                interval: (maxX - minX) / 3, // mostramos ~3 datas no rodape
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: primarySpots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: const FlDotData(show: true),
            ),
            if (secondarySpots.isNotEmpty)
              LineChartBarData(
                spots: secondarySpots,
                isCurved: true,
                color: Colors.redAccent,
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection() {
    return Expanded(
      child: ListView.separated(
        itemCount: _records.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final record = _records[index];
          String valueText = record.primaryValue.toStringAsFixed(0);
          if (_selectedType == 'blood_pressure' &&
              record.secondaryValue != null) {
            valueText += ' / ${record.secondaryValue!.toStringAsFixed(0)}';
          }
          valueText += ' ${record.unit}';

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: const Icon(Icons.favorite_border, color: Colors.blue),
            ),
            title: Text(
              valueText,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              '${record.measuredAt.day.toString().padLeft(2, '0')}/${record.measuredAt.month.toString().padLeft(2, '0')} às ${record.measuredAt.hour.toString().padLeft(2, '0')}:${record.measuredAt.minute.toString().padLeft(2, '0')}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _confirmDelete(record.id),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir aferição?'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _repository.deleteMeasurement(id);
              _loadData();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
