import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/breakpoints.dart';
import '../../domain/entities/invoice_item.dart';
import '../providers/pos_provider.dart';

class InvoicePanel extends StatelessWidget {
  const InvoicePanel({super.key});

  static final _currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  Widget build(BuildContext context) {
    return Consumer<PosProvider>(
      builder: (context, provider, _) {
        final invoice = provider.invoice;
        return Container(
          color: AppColors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CustomerFields(provider: provider),
                      const Divider(height: 1),
                      _InvoiceTable(
                        items: invoice.items,
                        onRemove: provider.removeInvoiceItem,
                        onQuantityChanged: provider.updateInvoiceItemQuantity,
                        onDiscountChanged: provider.updateInvoiceItemDiscount,
                        currencyFormat: _currencyFormat,
                      ),
                      _Summary(
                        invoice: invoice,
                        currencyFormat: _currencyFormat,
                      ),
                    ],
                  ),
                ),
              ),
              _ActionButtons(
                onSave: provider.saveInvoice,
                onSaveAndPrint: provider.saveAndPrintInvoice,
                isSaving: provider.isSaving,
                hasItems: invoice.items.isNotEmpty,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < Breakpoints.tablet;
    final padding = isMobile ? 12.0 : 16.0;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long,
            color: AppColors.primary,
            size: isMobile ? 24 : 28,
          ),
          SizedBox(width: isMobile ? 6 : 8),
          Expanded(
            child: Text(
              'Invoice',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 18 : null,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (!isMobile)
            IconButton(
              icon: const Icon(Icons.grid_view_rounded),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}

class _CustomerFields extends StatelessWidget {
  const _CustomerFields({required this.provider});

  final PosProvider provider;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < Breakpoints.tablet;
    final invoice = provider.invoice;
    final padding = isMobile ? 12.0 : 16.0;
    final spacing = isMobile ? 10.0 : 12.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DropdownField(
                  label: 'Customer',
                  value: invoice.customerName,
                  onTap: () {},
                  isMobile: true,
                ),
                SizedBox(height: spacing),
                _AccountField(
                  value: invoice.accountName,
                  onTap: () {},
                  isMobile: true,
                ),
                SizedBox(height: spacing),
                Row(
                  children: [
                    Expanded(
                      child: _DropdownField(
                        label: 'Salesman',
                        value: invoice.salesman,
                        onTap: () {},
                        isMobile: true,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: _DropdownField(
                        label: 'Payment',
                        value: invoice.paymentType,
                        onTap: () {},
                        isMobile: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                _ExchangeRateField(
                  value: invoice.exchangeRate,
                  currency: invoice.exchangeCurrency,
                  onChanged: (v, c) => provider.updateInvoiceFields(
                    exchangeRate: v,
                    exchangeCurrency: c,
                  ),
                  isMobile: true,
                ),
              ],
            )
          : Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                _DropdownField(
                  label: 'Customer',
                  value: invoice.customerName,
                  onTap: () {},
                  isMobile: false,
                ),
                _AccountField(
                  value: invoice.accountName,
                  onTap: () {},
                  isMobile: false,
                ),
                _DropdownField(
                  label: 'Salesman',
                  value: invoice.salesman,
                  onTap: () {},
                  isMobile: false,
                ),
                _DropdownField(
                  label: 'Payment Type',
                  value: invoice.paymentType,
                  onTap: () {},
                  isMobile: false,
                ),
                _ExchangeRateField(
                  value: invoice.exchangeRate,
                  currency: invoice.exchangeCurrency,
                  onChanged: (v, c) => provider.updateInvoiceFields(
                    exchangeRate: v,
                    exchangeCurrency: c,
                  ),
                  isMobile: false,
                ),
              ],
            ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    this.label,
    required this.value,
    required this.onTap,
    required this.isMobile,
  });

  final String? label;
  final String value;
  final VoidCallback onTap;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isMobile ? double.infinity : 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: TextStyle(
                fontSize: isMobile ? 11 : 12,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: isMobile ? 2 : 4),
          ],
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 12,
                vertical: isMobile ? 10 : 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: isMobile ? 13 : 14),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, size: isMobile ? 18 : 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountField extends StatelessWidget {
  const _AccountField({
    required this.value,
    required this.onTap,
    required this.isMobile,
  });

  final String value;
  final VoidCallback onTap;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isMobile ? double.infinity : 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Account',
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: isMobile ? 2 : 4),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet, size: isMobile ? 18 : 20),
                  SizedBox(width: isMobile ? 6 : 8),
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: isMobile ? 13 : 14),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, size: isMobile ? 18 : 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExchangeRateField extends StatelessWidget {
  const _ExchangeRateField({
    required this.value,
    required this.currency,
    required this.onChanged,
    required this.isMobile,
  });

  final double value;
  final String currency;
  final void Function(double value, String currency) onChanged;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isMobile ? double.infinity : 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Exchange Rate',
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: isMobile ? 2 : 4),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _formatNumber(value),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: isMobile ? 13 : 14),
                  decoration: InputDecoration(
                    isDense: isMobile,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 12,
                      vertical: isMobile ? 10 : 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                    ),
                  ),
                  onChanged: (v) {
                    final parsed = double.tryParse(v.replaceAll(',', ''));
                    if (parsed != null) onChanged(parsed, currency);
                  },
                ),
              ),
              SizedBox(width: isMobile ? 6 : 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 10 : 12,
                  vertical: isMobile ? 10 : 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                ),
                child: Text(
                  currency,
                  style: TextStyle(fontSize: isMobile ? 13 : 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(double v) {
    return NumberFormat('#,###').format(v);
  }
}

class _InvoiceTable extends StatelessWidget {
  const _InvoiceTable({
    required this.items,
    required this.onRemove,
    required this.onQuantityChanged,
    required this.onDiscountChanged,
    required this.currencyFormat,
  });

  final List<InvoiceItem> items;
  final void Function(int index) onRemove;
  final void Function(int index, int qty) onQuantityChanged;
  final void Function(int index, double discount) onDiscountChanged;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < Breakpoints.tablet;

    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        child: Center(
          child: Text(
            'Add products from the catalog',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isMobile ? 13 : 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final item = items[i];
            return _InvoiceItemCard(
              item: item,
              currencyFormat: currencyFormat,
              onRemove: () => onRemove(i),
              onQuantityChanged: (q) => onQuantityChanged(i, q),
            );
          },
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
        columns: const [
          DataColumn(label: Text('Item Name')),
          DataColumn(label: Text('Package')),
          DataColumn(label: Text('Qty')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Dis.%')),
          DataColumn(label: Text('Total')),
          DataColumn(label: SizedBox.shrink()),
        ],
        rows: List.generate(items.length, (i) {
          final item = items[i];
          return DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: 140,
                  child: Text(
                    item.product.name.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(Text(item.package)),
              DataCell(
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    initialValue: '${item.quantity}',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(isDense: true),
                    onChanged: (v) {
                      final q = int.tryParse(v);
                      if (q != null) onQuantityChanged(i, q);
                    },
                  ),
                ),
              ),
              DataCell(Text(item.unitPrice.toStringAsFixed(2))),
              DataCell(
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    initialValue: '${item.discountPercent.toInt()}',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(isDense: true),
                    onChanged: (v) {
                      final d = double.tryParse(v);
                      if (d != null) onDiscountChanged(i, d);
                    },
                  ),
                ),
              ),
              DataCell(Text(currencyFormat.format(item.total))),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => onRemove(i),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _InvoiceItemCard extends StatelessWidget {
  const _InvoiceItemCard({
    required this.item,
    required this.currencyFormat,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  final InvoiceItem item;
  final NumberFormat currencyFormat;
  final VoidCallback onRemove;
  final void Function(int) onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.product.name.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppColors.soldOut,
                  ),
                  onPressed: onRemove,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: TextFormField(
                    initialValue: '${item.quantity}',
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onChanged: (v) {
                      final q = int.tryParse(v);
                      if (q != null) onQuantityChanged(q);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '× \$${item.unitPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12),
                ),
                const Spacer(),
                Text(
                  currencyFormat.format(item.total),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.invoice, required this.currencyFormat});

  final dynamic invoice;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < Breakpoints.tablet;
    final padding = isMobile ? 12.0 : 16.0;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: currencyFormat.format(invoice.subtotal),
            isMobile: isMobile,
          ),
          _SummaryRow(
            label: 'Discount',
            value: currencyFormat.format(invoice.totalDiscount),
            isMobile: isMobile,
          ),
          const Divider(),
          _SummaryRow(
            label: 'TOTAL',
            value: currencyFormat.format(invoice.total),
            isTotal: true,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isMobile = false,
  });

  final String label;
  final String value;
  final bool isTotal;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final double fontSize = isTotal
        ? (isMobile ? 16.0 : 18.0)
        : (isMobile ? 13.0 : 14.0);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 2 : 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onSave,
    required this.onSaveAndPrint,
    required this.isSaving,
    required this.hasItems,
  });

  final VoidCallback onSave;
  final VoidCallback onSaveAndPrint;
  final bool isSaving;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < Breakpoints.tablet;
    final padding = isMobile ? 12.0 : 16.0;
    final verticalPadding = isMobile ? 12.0 : 14.0;
    final spacing = isMobile ? 8.0 : 12.0;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: hasItems && !isSaving ? onSave : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Save',
                        style: TextStyle(fontSize: isMobile ? 14.0 : 16.0),
                      ),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: OutlinedButton(
                onPressed: hasItems && !isSaving ? onSaveAndPrint : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                ),
                child: Text(
                  'Save & Print',
                  style: TextStyle(fontSize: isMobile ? 13.0 : 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
