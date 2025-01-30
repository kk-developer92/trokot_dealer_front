import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/common/ui/text_field.dart';
import 'package:trokot_dealer_mobile/auth/login_notifier.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginNotifier state;
  late StreamSubscription<String> errorSubscription;

  @override
  void initState() {
    super.initState();
    state = LoginNotifier(serviceClient: context.read<ServiceClient>());

    errorSubscription = state.errorStream.listen((errorMessage) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    state.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<LoginNotifier>.value(
          // create: (context) => LoginProvider(),
          value: state,
          child: Consumer<LoginNotifier>(
            builder: (context, state, child) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/logo.svg'),
                    const SizedBox(height: 20),
                    AppTextField(
                      text: state.username,
                      decoration: const InputDecoration(
                        label: Text('Логин'),
                        border: OutlineInputBorder(),
                      ),
                      closeButton: false,
                      onChanged: state.setUsername,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      text: state.password,
                      decoration: const InputDecoration(
                        label: Text('Пароль'),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      closeButton: false,
                      onChanged: state.setPassword,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.login,
                        child: const Text('Войти',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text('ООО "Трокот"', style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text('ИНН: 5038098890', style: TextStyle(fontSize: 12)),
                    const Text('КПП: 503801001', style: TextStyle(fontSize: 12)),
                    const Text('ОГРН 1135038003748', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 5),
                    const Text('Адрес: 141281, Московская обл, Ивантеевка г,', style: TextStyle(fontSize: 12)),
                    const Text('Заречная ул, дом 1, Пом 3/8', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 5),
                    const Text('Самовывоз: Московская область , г. Ивантеевка, ул. Заречная д.1 п/э 3', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 5),
                    const Text('Транспортные компании: СДЭК, Почта России.', style: TextStyle(fontSize: 12)),
                    const Text('Стоимость доставки зависит от региона и габаритов груза,', style: TextStyle(fontSize: 12)),
                    const Text(' рассчитывается индивидуально каждая отправленная партия.', style: TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          )),
    );
  }
}
