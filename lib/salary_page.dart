import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'store.dart';
import 'widgets/glass_card.dart';
import 'widgets/gradient_background.dart';
import 'widgets/number_ticker.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({super.key});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      animated: true,
      child: ListenableBuilder(
        listenable: appStore,
        builder: (context, _) {
          final salaries = appStore.getAllSalaries(
            startDate: _startDate,
            endDate: _endDate,
          );

          final sortedUsers = salaries.entries.toList()
            ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

          return Column(
            children: [
              // Header cu filtre GLASS
              Padding(
                padding: const EdgeInsets.all(12),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Salarizare',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              _startDate != null && _endDate != null
                                  ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                  : 'Toate pontajele',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Filtrează pe perioadă',
                        icon: const Icon(Icons.date_range),
                        onPressed: () => _showDateRangeDialog(),
                      ),
                      if (_startDate != null || _endDate != null)
                        IconButton(
                          tooltip: 'Resetează filtre',
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _startDate = null;
                              _endDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: salaries.isEmpty
                    ? Center(
                        child: GlassCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Niciun utilizator',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: sortedUsers.length,
                        itemBuilder: (context, index) {
                          final entry = sortedUsers[index];
                          final username = entry.key;
                          final data = entry.value;
                          final salaryAmount = data['salaryAmount'] as double;
                          final salaryType = data['salaryType'] as SalaryType;
                          final currency = data['currency'] as Currency;
                          final totalHours = data['totalHours'] as double;
                          final totalDays = data['totalDays'] as int;
                          final salary = data['salary'] as double;

                          final currencySymbol = currency == Currency.euro ? '€' : 'lei';

                          return GlassCard(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.zero,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                childrenPadding: EdgeInsets.zero,
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.secondary,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      username[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  salaryAmount > 0
                                      ? salaryType == SalaryType.monthly
                                          ? 'Salariu fix: ${salaryAmount.toStringAsFixed(2)} $currencySymbol/lună'
                                          : 'Tarif: ${salaryAmount.toStringAsFixed(2)} $currencySymbol/oră'
                                      : 'Salariu nesetat',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    NumberTicker(
                                      value: salary,
                                      decimals: 2,
                                      suffix: ' $currencySymbol',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                    ),
                                    Text(
                                      salaryType == SalaryType.monthly ? 'fix/lună' : '$totalDays zile',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(16),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        if (salaryType == SalaryType.hourly) ...[
                                          _InfoRow(
                                            label: 'Total ore lucrate',
                                            value: '${totalHours.toStringAsFixed(2)}h',
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                        _InfoRow(
                                          label: 'Zile lucrate',
                                          value: '$totalDays',
                                        ),
                                        const SizedBox(height: 8),
                                        _InfoRow(
                                          label: salaryType == SalaryType.monthly ? 'Salariu lunar' : 'Tarif orar',
                                          value: salaryType == SalaryType.monthly
                                              ? '${salaryAmount.toStringAsFixed(2)} $currencySymbol/lună'
                                              : '${salaryAmount.toStringAsFixed(2)} $currencySymbol/oră',
                                        ),
                                        const Divider(height: 24),
                                        _InfoRow(
                                          label: 'Total de plată',
                                          value: '${salary.toStringAsFixed(2)} $currencySymbol',
                                          isTotal: true,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: GlassButton(
                                                onPressed: () => _editSalary(
                                                  username,
                                                  salaryAmount,
                                                  salaryType,
                                                  currency,
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.edit, size: 18),
                                                    SizedBox(width: 8),
                                                    Text('Editează'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: GlassButton(
                                                onPressed: () => Navigator.pushNamed(
                                                  context,
                                                  '/userEntries',
                                                  arguments: {'user': username},
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.list, size: 18),
                                                    SizedBox(width: 8),
                                                    Text('Pontaje'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showDateRangeDialog() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _editSalary(
    String username,
    double currentAmount,
    SalaryType currentType,
    Currency currentCurrency,
  ) async {
    final amountController = TextEditingController(
      text: currentAmount > 0 ? currentAmount.toStringAsFixed(2) : '',
    );
    SalaryType selectedType = currentType;
    Currency selectedCurrency = currentCurrency;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Editează salariu - $username'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tip salariu
                Text(
                  'Tip salariu',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SegmentedButton<SalaryType>(
                  segments: const [
                    ButtonSegment(
                      value: SalaryType.hourly,
                      icon: Icon(Icons.access_time, size: 18),
                      label: Text('Orar'),
                    ),
                    ButtonSegment(
                      value: SalaryType.monthly,
                      icon: Icon(Icons.calendar_month, size: 18),
                      label: Text('Lunar'),
                    ),
                  ],
                  selected: {selectedType},
                  onSelectionChanged: (Set<SalaryType> selection) {
                    setDialogState(() {
                      selectedType = selection.first;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Monedă
                Text(
                  'Monedă',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SegmentedButton<Currency>(
                  segments: const [
                    ButtonSegment(
                      value: Currency.lei,
                      label: Text('Lei (RON)'),
                    ),
                    ButtonSegment(
                      value: Currency.euro,
                      label: Text('Euro (€)'),
                    ),
                  ],
                  selected: {selectedCurrency},
                  onSelectionChanged: (Set<Currency> selection) {
                    setDialogState(() {
                      selectedCurrency = selection.first;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Sumă
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: selectedType == SalaryType.monthly
                        ? 'Salariu lunar'
                        : 'Tarif orar',
                    hintText: 'Ex: 25.50',
                    prefixIcon: const Icon(Icons.attach_money),
                    suffixText: selectedType == SalaryType.monthly
                        ? (selectedCurrency == Currency.euro ? '€/lună' : 'lei/lună')
                        : (selectedCurrency == Currency.euro ? '€/oră' : 'lei/oră'),
                  ),
                  autofocus: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anulează'),
            ),
            FilledButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                Navigator.pop(context, {
                  'amount': amount,
                  'type': selectedType,
                  'currency': selectedCurrency,
                });
              },
              child: const Text('Salvează'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      final amount = result['amount'] as double;
      final type = result['type'] as SalaryType;
      final currency = result['currency'] as Currency;

      if (amount >= 0) {
        appStore.setUserSalary(
          username: username,
          amount: amount,
          type: type,
          currency: currency,
        );

        if (mounted) {
          final currencySymbol = currency == Currency.euro ? '€' : 'lei';
          final typeLabel = type == SalaryType.monthly ? 'lunar' : 'orar';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Salariu actualizat: ${amount.toStringAsFixed(2)} $currencySymbol/$typeLabel',
              ),
            ),
          );
        }
      }
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )
              : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
        ),
      ],
    );
  }
}
