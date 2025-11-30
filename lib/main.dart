import 'package:flutter/material.dart';
import 'package:jawara_mobile/providers/channel_transfer_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawara_mobile/router.dart';
import 'package:jawara_mobile/providers/kegiatan_form_provider.dart';
import 'package:jawara_mobile/providers/pemasukan_form_provider.dart';
import 'package:jawara_mobile/providers/pengeluaran_form_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KegiatanFormProvider()),
        ChangeNotifierProvider(create: (_) => PemasukanFormProvider()),
        ChangeNotifierProvider(create: (_) => PengeluaranFormProvider()),
        ChangeNotifierProvider(create: (_) => ChannelTransferFormProvider()),
      ],
      child: MaterialApp.router(
        title: 'Jawara Pintar Mobile',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
