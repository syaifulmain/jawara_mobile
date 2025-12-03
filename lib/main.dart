import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jawara_mobile_v2/constants/color_constant.dart';
import 'package:jawara_mobile_v2/providers/address_provider.dart';
import 'package:jawara_mobile_v2/providers/broadcast_provider.dart';
import 'package:jawara_mobile_v2/providers/family_provider.dart';
import 'package:jawara_mobile_v2/providers/resident_provider.dart';
import 'package:jawara_mobile_v2/providers/transfer_channel_provider.dart';
import 'package:jawara_mobile_v2/providers/user_provider.dart';
import 'package:jawara_mobile_v2/providers/income_categories_provider.dart';
import 'package:jawara_mobile_v2/providers/income_provider.dart';
import 'package:jawara_mobile_v2/providers/bill_provider.dart';
import 'package:provider/provider.dart';
import 'constants/rem_constant.dart';
import 'providers/auth_provider.dart';
import 'providers/activity_provider.dart';
import 'routers/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Indonesian locale for date formatting
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BroadcastProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ResidentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FamilyProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => IncomeCategoriesProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => IncomeProvider()
        ),
        ChangeNotifierProvider(
            create: (_) => TransferChannelProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => BillProvider()
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (!authProvider.isInitialized) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading...'),
                    ],
                  ),
                ),
              ),
            );
          }

          return MaterialApp.router(
            title: 'Flutter App',
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.backgroundColor,
              primaryColor: AppColors.primaryColor,

              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.backgroundColor,
                titleTextStyle: GoogleFonts.poppins(
                  fontSize:
                      Rem.rem1_5, // Pastikan class 'Rem' Anda sudah diimport
                  fontWeight: FontWeight.w500,
                  color: Colors.black, // Warna teks judul
                ),

                // 3. Menambahkan Garis Bawah (Border Bottom)
                shape: const Border(
                  bottom: BorderSide(
                    color: Colors.grey, // Warna garis bawah
                    width: 1.0, // Ketebalan garis
                  ),
                ),

                elevation: 0,
                scrolledUnderElevation: 0,
              ),
            ),
            routerConfig: createAppRouter(authProvider),
          );
        },
      ),
    );
  }
}
