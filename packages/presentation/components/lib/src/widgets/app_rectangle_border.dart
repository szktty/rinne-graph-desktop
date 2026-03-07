import 'package:fonde_ui/fonde_ui.dart'
    show FondeRectangleBorder, FondeBorderRadiusValues, FondeBorderSide;
import 'package:fonde_ui/src/widgets/widgets/fonde_rectangle_border.dart'
    show fondeRectangleBorderProvider, fondeShapeDecorationProvider,
         fondeBorderRadiusProvider, fondeBorderSideProvider,
         FondeBorderRadius;
export 'package:fonde_ui/fonde_ui.dart'
    show FondeRectangleBorder, FondeBorderRadiusValues, FondeBorderSide;

typedef AppRectangleBorder = FondeRectangleBorder;
typedef AppBorderRadius = FondeBorderRadius;
typedef AppBorderSide = FondeBorderSide;

final appRectangleBorderProvider = fondeRectangleBorderProvider;
final appShapeDecorationProvider = fondeShapeDecorationProvider;
final appBorderRadiusProvider = fondeBorderRadiusProvider;
final appBorderSideProvider = fondeBorderSideProvider;
