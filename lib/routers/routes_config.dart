import 'package:jawara_mobile_v2/screens/admin/activities_and_broadcast/activities_and_broadcast_menu_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/activities_and_broadcast/activities_list_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/activities_and_broadcast/add_activity_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/activities_and_broadcast/broadcasts_list_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/activities_and_broadcast/add_broadcast_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/dashboard/population_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/family_relocation/family_relocation_creation_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/family_relocation/family_relocation_detail_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/family_relocation/family_relocation_list_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/family_relocation/family_relocation_menu_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/income/income_menu_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/income/income_categories_list_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/income/income_category_detail_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/income/add_income_category_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/income/bill_income_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/income/bills_list_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/income/bill_detail_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/income/other_income_list_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/income/add_other_income_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/income/income_detail_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/residents_and_houses/family/family_detail_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/residents_and_houses/house/add_house_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/residents_and_houses/resident/add_resident_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/residents_and_houses/resident/resident_detail_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/transfer_channel/transfer_channel_creation_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/transfer_channel/transfer_channel_detail_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/transfer_channel/transfer_channel_list_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/user_management/user_detail_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/user_management/user_management_menu_screen.dart';
import 'package:jawara_mobile_v2/screens/warga/income/my_bill_detail_screen.dart';
import 'package:jawara_mobile_v2/screens/warga/income/my_bills_screen.dart';
import 'package:jawara_mobile_v2/screens/warga/family/user_family_menu_screen.dart';
import 'package:jawara_mobile_v2/screens/warga/family/user_family_profile_screen.dart';
import 'package:jawara_mobile_v2/screens/warga/family/user_family_members_screen.dart';
import 'package:jawara_mobile_v2/screens/warga/family/add_user_family_screen.dart';
import '../screens/admin/activities_and_broadcast/activity_detail_screen.dart';
import '../screens/admin/activities_and_broadcast/broadcast_detail_screen.dart';
import '../screens/admin/dashboard/activities_screen.dart';
import '../screens/admin/dashboard/dashboard_menu_screen.dart';
import '../screens/admin/dashboard/finance_screen.dart';
import '../screens/admin/expenditure/expenditure_menu_screen.dart';
import '../screens/admin/expenditure/expenditure_list_screen.dart';
import '../screens/admin/expenditure/expenditure_detail_screen.dart';
import '../screens/admin/expenditure/add_expenditure_screen.dart';
import '../screens/admin/family_mutation/family_mutation_menu_screen.dart';
import '../screens/admin/financial_reports/financial_report_screen.dart';
import '../screens/admin/financial_reports/financial_reports_menu_screen.dart';
import '../screens/admin/residents_and_houses/family/families_list_screen.dart';
import '../screens/admin/residents_and_houses/house/house_detail_screen.dart';
import '../screens/admin/residents_and_houses/house/houses_list_screen.dart';
import '../screens/admin/residents_and_houses/resident/residents_list_screen.dart';
import '../screens/admin/residents_and_houses/residents_and_houses_menu_screen.dart';
import '../screens/admin/transfer_channel/transfer_channel_menu_screen.dart';
import '../screens/admin/user_management/add_user_screen.dart';
import '../screens/admin/user_management/users_list_screen.dart';
import '../screens/warga/activities/activities_list_this_mount.dart';
import '../screens/warga/activities/activities_menu_screen.dart';
import '../screens/warga/broadcast/broadcast_list_this_week_screen.dart';
import '../screens/warga/broadcast/broadcast_menu_screen.dart';
import '../screens/warga/fruit/fruit_menu_screen.dart';
import '../screens/warga/fruit/fruit_classification_screen.dart';
import '../screens/warga/fruit/fruit_image_list_screen.dart';
import 'app_route_item.dart';
import '../screens/home_screen.dart';

class RoutesConfig {
  static final List<AppRouteItem> routes = [
    AppRouteItem(
      path: '/',
      name: 'home',
      label: 'Beranda',
      builder: (context, state) => const HomeScreen(),
    ),

    // DASHBOARD SUB-ROUTES
    AppRouteItem(
      path: '/dashboard-menu',
      name: 'dashboard_menu',
      label: 'Dashboard',
      builder: (context, state) => const DashboardMenuScreen(),
    ),
    AppRouteItem(
      path: '/dashboard-menu/finance',
      name: 'dashboard-finance',
      label: 'Keuangan',
      builder: (context, state) => const FinanceScreen(),
    ),
    AppRouteItem(
      path: '/financial-report-screen',
      name: 'print_financial_report',
      label: 'Laporan Keuangan',
      builder: (context, state) => const FinancialReportScreen(),
    ),
    AppRouteItem(
      path: '/dashboard-menu/activities',
      name: 'dashboard-activities',
      label: 'Kegiatan',
      builder: (context, state) => const ActivitiesScreen(),
    ),
    AppRouteItem(
      path: '/dashboard-menu/population',
      name: 'dashboard-population',
      label: 'Kependudukan',
      builder: (context, state) => const PopulationScreen(),
    ),

    // RESIDENTS AND HOUSE ROUTES
    AppRouteItem(
      path: '/residents-and-houses-menu',
      name: 'residents_and_houses_menu',
      label: 'Data Warga dan Rumah',
      builder: (context, state) => const ResidentsAndHousesMenuScreen(),
    ),
    AppRouteItem(
      path: '/residents-list',
      name: 'residents_list',
      label: 'Daftar Warga',
      builder: (context, state) => const ResidentsListScreen(),
    ),
    AppRouteItem(
      path: '/resident-detail/:id',
      name: 'resident_detail',
      label: 'Detail Warga',
      builder: (context, state) {
        final residentId = state.pathParameters['id']!;
        return ResidentDetailScreen(id: residentId);
      },
    ),
    AppRouteItem(
      path: '/add-resident',
      name: 'add_resident',
      label: 'Tambah Warga',
      builder: (context, state) => const AddResidentScreen(),
    ),
    AppRouteItem(
      path: '/families-list',
      name: 'families_list',
      label: 'Daftar Keluarga',
      builder: (context, state) => const FamiliesListScreen(),
    ),
    AppRouteItem(
      path: '/family-detail/:id',
      name: 'family_detail',
      label: 'Detail Keluarga',
      builder: (context, state) {
        final familyId = state.pathParameters['id']!;
        return FamilyDetailScreen(id: familyId);
      },
    ),

    AppRouteItem(
      path: '/houses-list',
      name: 'houses_list',
      label: 'Daftar Alamat',
      builder: (context, state) => const HousesListScreen(),
    ),
    AppRouteItem(
      path: '/house-detail/:id',
      name: 'house_detail',
      label: 'Detail Rumah',
      builder: (context, state) {
        final houseId = state.pathParameters['id']!;
        return HouseDetailScreen(id: houseId);
      },
    ),
    AppRouteItem(
      path: '/add-house',
      name: 'add_house',
      label: 'Tambah Rumah',
      builder: (context, state) => const AddHouseScreen(),
    ),

    // INCOME ROUTES
    AppRouteItem(
      path: '/income_menu',
      name: 'income_menu',
      label: 'Pemasukan',
      builder: (context, state) => const IncomeMenuScreen(),
    ),
    AppRouteItem(
      path: '/income-categories-list',
      name: 'income_categories_list',
      label: 'Daftar Kategori Iuran',
      builder: (context, state) => const IncomeCategoriesListScreen(),
    ),
    AppRouteItem(
      path: '/add-income-category',
      name: 'add_income_category',
      label: 'Tambah Kategori Iuran',
      builder: (context, state) => const AddIncomeCategoryScreen(),
    ),
    AppRouteItem(
      path: '/income-category/:id',
      name: 'income_category_detail',
      label: 'Category Detail',
      builder: (context, state) {
        final categoryId = state.pathParameters['id']!;
        return IncomeCategoryDetailScreen(categoryId: categoryId);
      },
    ),
    AppRouteItem(
      path: '/other-income-list',
      name: 'other_income_list',
      label: 'Daftar Pemasukan Lain',
      builder: (context, state) => const OtherIncomeListScreen(),
    ),
    AppRouteItem(
      path: '/add-other-income',
      name: 'add_other_income',
      label: 'Tambah Pemasukan Lain',
      builder: (context, state) => const AddOtherIncomeScreen(),
    ),
    AppRouteItem(
      path: '/income-detail/:id',
      name: 'income_detail',
      label: 'Detail Pemasukan',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return IncomeDetailScreen(id: id);
      },
    ),
    AppRouteItem(
      path: '/bill-income',
      name: 'bill_income',
      label: 'Tagih Iuran',
      builder: (context, state) => const BillIncomeScreen(),
    ),
    AppRouteItem(
      path: '/bills-list',
      name: 'bills_list',
      label: 'Daftar Tagihan Warga',
      builder: (context, state) => const BillsListScreen(),
    ),
    AppRouteItem(
      path: '/bill-detail/:id',
      name: 'bill_detail',
      label: 'Detail Tagihan Warga',
      builder: (context, state) {
        final billId = state.pathParameters['id']!;
        return BillDetailScreen(billId: billId);
      },
    ),

    // EXPENDITURE ROUTES
    AppRouteItem(
      path: '/expenditure_menu',
      name: 'expenditure_menu',
      label: 'Pengeluaran',
      builder: (context, state) => const ExpenditureMenuScreen(),
    ),
    AppRouteItem(
      path: '/expenditures_list',
      name: 'expenditures_list',
      label: 'Daftar Pengeluaran',
      builder: (context, state) => const ExpenditureListScreen(),
    ),
    AppRouteItem(
      path: '/expenditure_detail/:id',
      name: 'expenditure_detail',
      label: 'Detail Pengeluaran',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ExpenditureDetailScreen(id: id);
      },
    ),
    AppRouteItem(
      path: '/add_expenditure',
      name: 'add_expenditure',
      label: 'Tambah Pengeluaran',
      builder: (context, state) => const AddExpenditureScreen(),
    ),
    // FINANCIAL REPORTS ROUTES
    AppRouteItem(
      path: '/financial_reports_menu',
      name: 'financial_reports_menu',
      label: 'Laporan Keuangan',
      builder: (context, state) => const FinancialReportsMenuScreen(),
    ),
    // ACTIVITIES AND BROADCAST ROUTES
    AppRouteItem(
      path: '/activities-and-broadcast-menu',
      name: 'activities_and_broadcast_menu',
      label: 'Kegiatan & Broadcast',
      builder: (context, state) => const ActivitiesAndBroadcastMenuScreen(),
    ),
    AppRouteItem(
      path: '/activities-list',
      name: 'activities_list',
      label: 'Daftar Kegiatan',
      builder: (context, state) => const ActivitiesListScreen(),
    ),
    AppRouteItem(
      path: '/add-activity',
      name: 'add_activity',
      label: 'Tambah Kegiatan',
      builder: (context, state) => const AddActivityScreen(),
    ),
    AppRouteItem(
      path: '/activities/:id',
      name: 'activity_detail',
      label: 'Detail Kegiatan',
      builder: (context, state) {
        final activityId = state.pathParameters['id']!;
        return ActivityDetailScreen(activityId: activityId);
      },
    ),
    AppRouteItem(
      path: '/broadcasts-list',
      name: 'broadcasts_list',
      label: 'Daftar Broadcast',
      builder: (context, state) => const BroadcastsListScreen(),
    ),
    AppRouteItem(
      path: '/add-broadcast',
      name: 'add_broadcast',
      label: 'Tambah Broadcast',
      builder: (context, state) => const AddBroadcastScreen(),
    ),
    AppRouteItem(
      path: '/broadcasts/:id',
      name: 'broadcast_detail',
      label: 'Detail Broadcast',
      builder: (context, state) {
        final broadcastId = state.pathParameters['id']!;
        return BroadcastDetailScreen(broadcastId: broadcastId);
      },
    ),

    // CITIZEN MESSAGE ROUTES
    // (To be added in the future)

    // CITIZEN RECIPIENT ROUTES
    // (To be added in the future)

    // FAMILY MUTATION ROUTES
    AppRouteItem(
      path: '/family-mutation-menu',
      name: 'family_mutation_menu',
      label: 'Mutasi Keluarga',
      builder: (context, state) => const FamilyMutationMenuScreen(),
    ),

    // LOG ACTIVITY ROUTES
    // (To be added in the future)

    // USER MANAGEMENT
    AppRouteItem(
      path: '/user-management-menu',
      name: 'user_management_menu',
      label: 'Manajemen Pengguna',
      builder: (context, state) => const UserManagementMenuScreen(),
    ),
    AppRouteItem(
      path: '/users-list',
      name: 'users_list',
      label: 'Daftar Pengguna',
      builder: (context, state) => const UsersListScreen(),
    ),
    AppRouteItem(
      path: '/user-detail/:id',
      name: 'user_detail',
      label: 'Detail Pengguna',
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return UserDetailScreen(id: userId);
      },
    ),
    AppRouteItem(
      path: '/add-user',
      name: 'add_user',
      label: 'Tambah Pengguna',
      builder: (context, state) => const AddUserScreen(),
    ),

    // TRANSFER CHANNEL ROUTES
    AppRouteItem(
      path: '/transfer-channel-menu',
      name: 'transfer_channel_menu',
      label: 'Saluran Transfer',
      builder: (context, state) => const TransferChannelMenuScreen(),
    ),

    AppRouteItem(
      path: '/transfer-channels-list',
      name: 'transfer_channels_list',
      label: 'Daftar Saluran Transfer',
      builder: (context, state) => const TransferChannelListScreen(),
    ),

    AppRouteItem(
      path: '/transfer-channels/:id',
      name: 'transfer_channel_detail',
      label: 'Detail Saluran Transfer',
      builder: (context, state) {
        final residentId = state.pathParameters['id']!;
        return TransferChannelDetailScreen(id: residentId);
      },
    ),

    AppRouteItem(
      path: '/add-transfer-channel',
      name: 'add_transfer_channel',
      label: 'Tambah Saluran Transfer',
      builder: (context, state) => const TransferChannelCreationScreen(),
    ),

    // ROLE USER
    // RESIDENT ACTIVITIES MENU
    AppRouteItem(
      path: '/resident-activities-menu',
      name: 'resident_activities_menu',
      label: 'Kegiatan Warga',
      builder: (context, state) => const ResidentActivitiesMenuScreen(),
    ),
    AppRouteItem(
      path: '/resident-activities-this-month',
      name: 'resident_activities_this_month',
      label: 'Kegiatan Bulan Ini',
      builder: (context, state) => const ActivitiesListThisMonth(),
    ),
    // RESIDENT BROADCAST MENU
    AppRouteItem(
      path: '/resident-broadcast-menu',
      name: 'resident_broadcast_menu',
      label: 'Broadcast Warga',
      builder: (context, state) => const ResidentBroadcastMenuScreen(),
    ),
    AppRouteItem(
      path: '/resident-broadcasts-this-week',
      name: 'resident_broadcasts_this_week',
      label: 'Broadcast Minggu Ini',
      builder: (context, state) => const BroadcastListThisWeekScreen(),
    ),

    // USER BILL MENU
    AppRouteItem(
      path: '/my-bills-list',
      name: 'my_bills_list',
      label: 'Daftar Tagihan ',
      builder: (context, state) => const MyBillsScreen(),
    ),
    AppRouteItem(
      path: '/my-bill-detail/:id',
      name: 'my_bill_detail',
      label: 'Detail Tagihan',
      builder: (context, state) {
        final billId = state.pathParameters['id']!;
        return MyBillDetailScreen(billId: billId);
      },
    ),
    AppRouteItem(
      path: '/user-family-menu',
      name: 'family_data',
      label: 'Data Keluarga',
      builder: (context, state) => const UserFamilyMenuScreen(),
    ),
    AppRouteItem(
      path: '/user-family-profile',
      name: 'family_profile',
      label: 'Profil Keluarga',
      builder: (context, state) => const UserFamilyProfileScreen(),
    ),
    AppRouteItem(
      path: '/user-family-members',
      name: 'family_members',
      label: 'Daftar Anggota',
      builder: (context, state) => const UserFamilyMembersScreen(),
    ),
    AppRouteItem(
      path: '/add-user-family-member',
      name: 'add_user_family_member',
      label: 'Tambah Anggota Keluarga',
      builder: (context, state) => const AddUserFamilyScreen(),
    ),

    AppRouteItem(
      path: '/family-relocation-menu',
      name: 'family_relocation_menu',
      label: 'Mutasi Keluarga',
      builder: (context, state) => const FamilyRelocationMenuScreen(),
    ),

    AppRouteItem(
      path: '/family-relocation-list',
      name: 'family_relocation_list',
      label: 'Daftar Mutasi Keluarga',
      builder: (context, state) => const FamilyRelocationListScreen(),
    ),

    AppRouteItem(
      path: '/family-relocation/:id',
      name: 'family_relocation_detail',
      label: 'Detail Mutasi Keluarga',
      builder: (context, state) {
        final familyRelocationId = state.pathParameters['id']!;
        return FamilyRelocationDetailScreen(id: familyRelocationId);
      },
    ),
    AppRouteItem(
      path: '/family-relocation-creation',
      name: 'add_family_relocation',
      label: 'Tambah Mutasi Keluarga',
      builder: (context, state) => const FamilyRelocationCreationScreen(),
    ),

    // FRUIT CLASSIFICATION ROUTES (USER ONLY)
    AppRouteItem(
      path: '/fruit-menu',
      name: 'fruit_menu',
      label: 'Klasifikasi Buah',
      builder: (context, state) => const FruitMenuScreen(),
    ),
    AppRouteItem(
      path: '/fruit-classification',
      name: 'fruit_classification',
      label: 'Klasifikasi Buah',
      builder: (context, state) => const FruitClassificationScreen(),
    ),
    AppRouteItem(
      path: '/fruit-image-list',
      name: 'fruit_image_list',
      label: 'Daftar Gambar Buah',
      builder: (context, state) => const FruitImageListScreen(),
    ),
  ];
}
