import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/preferences_provider.dart';
import '../../../utils/themes.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final PreferencesProvider preferencesProvider;

  static AppState get _initialState => AppState(lightTheme, false);

  AppBloc({required this.preferencesProvider}) : super(_initialState);

  Future<AppState> _initState() async {
    final isDarkMode = await preferencesProvider.isDarkTheme();
    final initialState = AppState(isDarkMode ? darkTheme : lightTheme, isDarkMode);
    return initialState;
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    final currentState = state;
    if (event is InitStateEvent) {
      yield await _initState();
    }
    if (currentState is AppState) {
      if (event is SwitchThemeEvent) {
        final theme;
        if (currentState.theme == lightTheme) {
          theme = darkTheme;
        } else {
          theme = lightTheme;
        }
        final isDarkMode = theme == darkTheme;
        preferencesProvider.saveTheme(isDarkMode);
        yield AppState(theme, isDarkMode);
      }
    }
  }
}