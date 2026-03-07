// Delegate to Fonde UI toolbar providers.
import 'package:fonde_ui/fonde_ui_riverpod.dart'
    show
        FondeToolbarStateManager,
        fondeToolbarStateManagerProvider,
        FondeToolbarActions,
        fondeToolbarActionsProvider;

export 'package:fonde_ui/fonde_ui_riverpod.dart'
    show
        FondeToolbarStateManager,
        fondeToolbarStateManagerProvider,
        FondeToolbarActions,
        fondeToolbarActionsProvider;

final toolbarStateManagerProvider = fondeToolbarStateManagerProvider;
typedef ToolbarStateManager = FondeToolbarStateManager;
final toolbarActionsProvider = fondeToolbarActionsProvider;
typedef ToolbarActions = FondeToolbarActions;
