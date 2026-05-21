
import '../../core/app_export.dart';
import '../../widgets/app_navigation.dart';
import './widgets/add_appointment_sheet_widget.dart';
import './widgets/appointment_list_widget.dart';
import './widgets/hero_headline_widget.dart';
import './widgets/home_app_bar_widget.dart';

// TODO: Replace with Riverpod/Bloc for production state management
class BersichtScreen extends StatefulWidget {
  const BersichtScreen({super.key});

  @override
  State<BersichtScreen> createState() => _BersichtScreenState();
}

class _BersichtScreenState extends State<BersichtScreen> {
  int _navIndex = 0;
  bool _isLoading = true;

  // Mock user data — TODO: Replace with auth user from backend
  final Map<String, dynamic> _currentUser = {
    'firstName': 'Thomas',
    'lastName': 'Bergmann',
    'email': 'admin@familyhub.de',
    'role': 'Admin',
    'avatarUrl':
        'https://img.rocket.new/generatedImages/rocket_gen_img_1ca5ca16b-1763296399047.png',
    'avatarSemanticLabel':
        'Profilbild von Thomas Bergmann, mittelalterlicher Mann mit kurzen braunen Haaren',
  };

  // Mock appointment data — TODO: Replace with API data
  final List<Map<String, dynamic>> _appointmentMaps = [
    {
      'id': 'apt_001',
      'title': 'Zahnarzt Termin',
      'date': '2026-05-18',
      'time': '09:30',
      'location': 'Zahnarztpraxis Dr. Müller, Hauptstraße 12, München',
      'description': 'Routineuntersuchung und Reinigung',
      'colorHex': '3B5BDB',
    },
    {
      'id': 'apt_002',
      'title': 'Elternabend Grundschule',
      'date': '2026-05-18',
      'time': '19:00',
      'location': 'Grundschule am Park, Aula',
      'description': 'Jahresplanung und Ausflugsbesprechung',
      'colorHex': '7C3AED',
    },
    {
      'id': 'apt_003',
      'title': 'Autowerkstatt',
      'date': '2026-05-20',
      'time': '08:00',
      'location': 'KFZ Meister Schreiber, Industriestraße 5',
      'description': 'Hauptuntersuchung (HU/AU) fällig',
      'colorHex': 'E6A817',
    },
    {
      'id': 'apt_004',
      'title': 'Steuerberater',
      'date': '2026-05-20',
      'time': '14:30',
      'location': 'Kanzlei Hoffmann & Partner, Marktplatz 3',
      'description': 'Jahressteuererklärung 2025 besprechen',
      'colorHex': '2D9E5F',
    },
    {
      'id': 'apt_005',
      'title': 'Familienfest Oma Renate',
      'date': '2026-05-23',
      'time': '15:00',
      'location': 'Gartenstraße 8, Augsburg',
      'description': '80. Geburtstag, Kaffee und Kuchen ab 15 Uhr',
      'colorHex': 'D32F2F',
    },
    {
      'id': 'apt_006',
      'title': 'Sportverein Mitgliederversammlung',
      'date': '2026-05-26',
      'time': '20:00',
      'location': 'TSV Vereinsheim, Sportanlage West',
      'description': 'Jahreshauptversammlung mit Wahlen',
      'colorHex': '3B5BDB',
    },
  ];

  List<Map<String, dynamic>> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() async {
    // TODO: Replace with real API call to fetch user appointments
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _appointments = _appointmentMaps;
        _isLoading = false;
      });
    }
  }

  int get _todayCount {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return _appointments.where((a) => a['date'] == todayStr).length;
  }

  void _showAddAppointmentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddAppointmentSheetWidget(
        onSave: (appointment) {
          // TODO: Replace with real API call to save appointment
          setState(() {
            _appointments = [..._appointments, appointment];
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.geldTrackerScreen);
    } else {
      setState(() => _navIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAppointmentSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Termin hinzufügen'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: isTablet
          ? null
          : AppNavigation(
              currentIndex: _navIndex,
              onDestinationSelected: _onNavTap,
            ),
    );
  }

  Widget _buildPhoneLayout() {
    return SafeArea(
      child: Column(
        children: [
          HomeAppBarWidget(user: _currentUser),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(milliseconds: 800));
                // TODO: Replace with real refresh API call
                setState(() => _isLoading = false);
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: HeroHeadlineWidget(todayCount: _todayCount),
                    ),
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 24)),
                  AppointmentListWidget(
                    appointments: _appointments,
                    isLoading: _isLoading,
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SafeArea(
      child: Row(
        children: [
          AppNavigation(
            currentIndex: _navIndex,
            onDestinationSelected: _onNavTap,
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                HomeAppBarWidget(user: _currentUser),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() => _isLoading = true);
                      await Future.delayed(const Duration(milliseconds: 800));
                      setState(() => _isLoading = false);
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                            child: HeroHeadlineWidget(todayCount: _todayCount),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                        AppointmentListWidget(
                          appointments: _appointments,
                          isLoading: _isLoading,
                          isTablet: true,
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
