import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mylastfm/data/i_lastfm_service.dart';
import 'package:mylastfm/data/i_local_storage_service.dart';
import 'package:mylastfm/logic/artists_cubit.dart';
import 'package:mylastfm/logic/locst_albums_cubit.dart';
import 'package:mylastfm/logic/locst_remover_cubit.dart';
import 'package:mylastfm/ui/screens/shared.dart';
import 'package:provider/provider.dart';
import '../widgets/home_screen_widgets/artists_search_result.dart';
import '../widgets/home_screen_widgets/home_screen_title.dart';
import '../widgets/home_screen_widgets/saved_albums_content.dart';
import '../widgets/home_screen_widgets/search_field_state.dart';

//
class HomeScreen extends StatefulWidget {
  static const route = '/';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late final TabController _tabController;

  void _onNavTapped(int navIndex) {
    if (_selectedIndex == navIndex) return;
    setState(() {
      _selectedIndex = navIndex;
      _tabController.index = navIndex;
    });
  }

  final List<BottomNavigationBarItem> _bottomNav = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Artist'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _bottomNav.length);
    _tabController.addListener(() => {
          if (_selectedIndex != _tabController.index)
            {
              setState(() {
                _selectedIndex = _tabController.index;
              })
            }
        });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _cancelSearchCallback() {
    _onNavTapped(0);
  }

  @override
  Widget build(BuildContext context) {
    final _needsLoading = context.watch<SharedRepo>().isSavedAlbumsNeedsReLoading;
    if (_needsLoading) {
      BlocProvider.of<LocstAlbumsCubit>(context, listen: false).toInitial();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocstRemoverCubit(locSt: GetIt.I<ILocalStorageService>())),
        BlocProvider(create: (_) => ArtistsCubit(lastfmService: GetIt.I<ILastfmService>())),
      ],
      child: ChangeNotifierProvider(
        create: (_) => SearchFieldState(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: HomeScreenTitle(
              index: _selectedIndex,
              cancelSearchCallback: _cancelSearchCallback,
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                SavedAlbumsContent(needsLoading: _needsLoading),
                const ArtistsSearchResult(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: _bottomNav,
            currentIndex: _selectedIndex,
            onTap: _onNavTapped,
            iconSize: 30,
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
