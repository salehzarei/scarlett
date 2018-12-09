import 'package:flutter/material.dart';
import 'package:scarlett/pages/barcode_scanner.dart';
import '../menu/menu_screen.dart';

class ZoomScaffold extends StatefulWidget {
 final Screen contentScreen;
 final  Widget menuScreen;

  ZoomScaffold({this.contentScreen, this.menuScreen});

  _ZoomScaffoldState createState() => _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  MenuController menuController;
  Curve scaleDownCurve = Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = Interval(0.0, 1.0, curve: Curves.easeOut);

  @override
  initState() {
    super.initState();

    menuController = MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  dispose() {
    menuController.dispose();
    super.dispose();
  }

  _contentScreen() {
    return zoomAndSlideContent(
      Container(
        decoration: BoxDecoration(image: widget.contentScreen.background),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.1,
              centerTitle: true,
              title: Text(
                widget.contentScreen.title,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.linked_camera),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => BarcodeScan()));
                  },
                )
              ],
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  menuController.toggle();
                },
              )),
          body: widget.contentScreen.contentBuilder(context),
        ),
      ),
    );
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;

      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;

      case MenuState.opening:
        slidePercent = slideOutCurve.transform(menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(menuController.percentOpen);
        break;

      case MenuState.closing:
        slidePercent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
    }

    final slideAmount = 225.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 10.0 * menuController.percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              blurRadius: 15.0,
              color: Colors.grey,
              offset: Offset(0.0, 5.0),
              spreadRadius: 10.0)
        ]),
        child: ClipRRect(
          child: content,
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.menuScreen,
        _contentScreen(),
      ],
    );
  }
}

class Screen {
  final String title;
  final DecorationImage background;
  final WidgetBuilder contentBuilder;

  Screen({this.title, this.background, this.contentBuilder});
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;

  MenuState state = MenuState.closed;

  MenuController({this.vsync})
      : _animationController = AnimationController(vsync: vsync) {
    _animationController
      ..duration = Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({this.builder});

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {

MenuController menuController;





  @override
  void initState() {
menuController =  getMenuController(context);
menuController.addListener(_onMenuControllerChange);
    super.initState();
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);
    super.dispose();
  }

  getMenuController(BuildContext context) {
    final scaffoldState =
        context.ancestorStateOfType(TypeMatcher<_ZoomScaffoldState>())
            as _ZoomScaffoldState;
    return scaffoldState.menuController;
  }


  _onMenuControllerChange(){

    setState(() {
          
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, getMenuController(context));
  }
}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuController menuController);
