// Delegate to Fonde UI search providers.
import 'package:fonde_ui/fonde_ui_riverpod.dart'
    show
        fondeSearchQueryProvider,
        fondeSearchFieldManagerProvider,
        FondeSearchQuery,
        FondeSearchFieldManager;

export 'package:fonde_ui/fonde_ui_riverpod.dart'
    show
        fondeSearchQueryProvider,
        fondeSearchFieldManagerProvider,
        FondeSearchQuery,
        FondeSearchFieldManager;

final searchQueryProvider = fondeSearchQueryProvider;
final searchFieldManagerProvider = fondeSearchFieldManagerProvider;
typedef SearchQuery = FondeSearchQuery;
typedef SearchFieldManager = FondeSearchFieldManager;
