import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import '../../../logic/artists_cubit.dart';
import '_action_handlers.dart';
import 'search_field_state.dart';

class HomeScreenTitle extends StatefulWidget {
  final int index;
  final void Function() cancelSearchCallback;

  const HomeScreenTitle({
    Key? key,
    required this.index,
    required this.cancelSearchCallback,
  }) : super(key: key);

  @override
  State<HomeScreenTitle> createState() => _HomeScreenTitleState();
}

class _HomeScreenTitleState extends State<HomeScreenTitle> {
  final _controllerTextFieldSearch = TextEditingController();
  final _focusNodeSearch = FocusNode();
  String _prevText = '';

  @override
  void dispose() {
    _controllerTextFieldSearch.dispose();
    _focusNodeSearch.dispose();
    EasyDebounce.cancelAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _searchFieldState = Provider.of<SearchFieldState>(context, listen: false);
    final _isFocused = _searchFieldState.isFocused;
    final _doRefocus = _searchFieldState.doRefocus;
    //---
    // Home page on HomeScreen
    if (widget.index == 0) {
      FocusManager.instance.primaryFocus?.unfocus();
      _searchFieldState.setFocusedStateTo(false);
      _searchFieldState.setDoRefocusTo(true);
    }
    // Artist page on HomeScreen
    else if (widget.index == 1) {
      if (!_isFocused) {
        if (_doRefocus) {
          FocusScope.of(context).requestFocus(_focusNodeSearch);
          _searchFieldState.setFocusedStateTo(true);
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      }
    }
    //---
    return IndexedStack(
      index: widget.index,
      children: [
        Row(
          children: [
            const SizedBox(height: kToolbarHeight),
            Expanded(
              child: Text(
                'last.fm',
                style: GoogleFonts.pacifico(
                  color: const Color(0xEEFFFFFF),
                  fontSize: 29,
                ),
              ),
            ),
            SizedBox(
              width: 26,
              child: PopupMenuButton(
                icon: const Icon(Icons.more_vert, size: 25),
                padding: EdgeInsets.zero,
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: const Text('Remove all saved albums'),
                    height: 38,
                    padding: const EdgeInsets.only(left: 16),
                    onTap: () => ActionHandlers.removeAllSavedAlbumsItemTapHandler(context),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(height: kToolbarHeight),
            Expanded(child: textFieldSearch(context)),
            IconButton(
              onPressed: () {
                context.read<ArtistsCubit>().clearArtistsSearchResults();
                _controllerTextFieldSearch.text = '';
                _prevText = '';
                widget.cancelSearchCallback();
              },
              icon: const Icon(Icons.close, size: 25),
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(maxWidth: 40),
            ),
          ],
        ),
      ],
    );
  }

  Widget textFieldSearch(BuildContext context) {
    return TextField(
      controller: _controllerTextFieldSearch,
      focusNode: _focusNodeSearch,
      autofocus: false,
      cursorColor: Colors.white,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
      decoration: const InputDecoration(
        hintText: 'Type here to find an artist...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70, fontSize: 17),
      ),
      onChanged: (newText) {
        EasyDebounce.debounce('debouncer', const Duration(milliseconds: 400), () {
          if (newText != _prevText) {
            _prevText = newText;
            context.read<ArtistsCubit>().getArtistsBySearchString(searchString: newText);
          }
        });
      },
      onSubmitted: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTap: () {
        context.read<SearchFieldState>().setDoRefocusTo(true);
      },
    );
  }
}
