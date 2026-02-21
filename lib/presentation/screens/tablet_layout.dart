import 'package:flutter/material.dart';

import '../widgets/invoice_panel.dart';
import 'pos_screen.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: ProductCatalog()),
        Flexible(flex: 1, child: InvoicePanel()),
      ],
    );
  }
}
