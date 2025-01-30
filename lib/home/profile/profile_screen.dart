import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';
import 'package:trokot_dealer_mobile/services/user.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:html' as html;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceClient = context.read<ServiceClient>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: serviceClient.ping,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: serviceClient.userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            if (user == null) {
              return Container();
            } else {
              return ProfileScreenBody(user: user);
            }
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: ProfileScreenButtons(
        serviceClient: serviceClient,
        screenContext: context,
      ),
    );
  }
}

class ProfileScreenBody extends StatelessWidget {
  final User user;

  const ProfileScreenBody({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Имя', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(user.name)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Контрагент', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(user.partner.name),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ИНН', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(user.partner.tin),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Баланс', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(user.balance.toStringAsFixed(2)),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileScreenButtons extends StatelessWidget {
  final ServiceClient serviceClient;
  final BuildContext screenContext;

  const ProfileScreenButtons({
    super.key,
    required this.serviceClient,
    required this.screenContext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            serviceClient.checkBalancePayment();
          },
          child: const Text('Проверить баланс'),
        ),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {
            showAmountInputDialog(context).then((amount) {
              if (amount != null) {
                serviceClient
                    .createBalancePaymentUrl(
                  description: "Пополнение баланса на сумму $amount руб.",
                  amount: amount,
                )
                    .then((paymentUrl) {
                  final paymentUri = Uri.parse(paymentUrl);
                  launchUrl(paymentUri, mode: LaunchMode.externalApplication);
                }).catchError((error) {
                  print('+++ balance url error: $error');
                });
              }
            });
          },
          child: const Text('Пополнить баланс'),
        ),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: serviceClient.logOut,
          child: const Text('Выйти'),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     // _createDownloadLink('http://localhost/docs/invoice.pdf');
        //     _downloadFile('http://localhost/docs/invoice.pdf');
        //   },
        //   child: const Text('Скачать'),
        // ),
      ],
    );
  }
}

Future<Decimal?> showAmountInputDialog(BuildContext context) async {
  Decimal amount = Decimal.zero;
  final controller = TextEditingController();

  return showDialog<Decimal>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Сумма пополнения'),
        content: TextField(
          controller: controller,
          onChanged: (value) => amount = Decimal.parse(value),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (amount > Decimal.zero) {
                Navigator.of(context).pop(amount);
              }
            },
            child: const Text('ОК'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
        ],
      );
    },
  );
}

void _createDownloadLink(String url) {
  // Create an anchor element
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'invoice.pdf') // Optional: Set the default file name
    ..target = '_blank'; // Open in a new tab (optional)

  // Programmatically click the anchor to trigger the download
  anchor.click();
}

void _downloadFile(String url) {
  // Create an anchor element
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'invoice.pdf'); // Optional: Set the default file name
    // ..target = '_blank'; // Open in a new tab (optional)

  // Programmatically click the anchor to trigger the download
  anchor.click();
}

