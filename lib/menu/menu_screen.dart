import 'package:flutter/material.dart';
import '../menu/zoomsacaffold.dart';

final menuScreenKey = GlobalKey(debugLabel: 'MenuScreen');

class MenuScreen extends StatefulWidget {
  final Menu menu;
  final String selectedItemId;

  final Function(String) onMenuItemSelected;

  MenuScreen({this.menu, this.selectedItemId, this.onMenuItemSelected})
      : super(key: menuScreenKey);

  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  _menuItems(MenuController menucontroller) {
    final animationIntervalDuration = 0.5;
    final List<Widget> listitems = [];
    final perListItemDelay =
        menucontroller.state != MenuState.closing ? 0.15 : 0.0;

    for (var i = 0; i < widget.menu.items.length; ++i) {
      final animationIntervalStart = perListItemDelay * i;
      final animationInterbalEnd =
          animationIntervalStart + animationIntervalDuration;
      final isSelected = widget.menu.items[i].id == widget.selectedItemId;
      listitems.add(
        AnimationMenuListItem(
          isselected: isSelected,
          menuState: menucontroller.state,
          duration: Duration(milliseconds: 600),
          curve: Interval(animationIntervalStart, animationInterbalEnd,
              curve: Curves.easeOut),
          menuListItem: _MenuItems(
            title: widget.menu.items[i].title,
            isSelected: isSelected,
            onTap: () {
              widget.onMenuItemSelected(widget.menu.items[i].id);
              menucontroller.close();
            },
          ),
        ),
      );
    }

    return Transform(
      transform: Matrix4.translationValues(0.0, 235.0, 0.0),
      child: Column(
        children: listitems,
      ),
    );
  }

  AnimationController titleAnimationController;
  double selectorYTop = 250.0;
  double selectorYBottom = 300.0;

  selectedRenderBox(RenderBox newRenderBox) async {
    final newYTop = newRenderBox.localToGlobal(const Offset(0.0, 0.0)).dy;
    final newYBottom = newYTop + newRenderBox.size.height;
    if (newYTop != selectorYTop) {
      // setState(() {
      //   selectorYTop = newYTop;
      //   selectorYBottom = newYBottom;
      // }

      // );

      selectorYTop = newYTop;
      selectorYBottom = newYBottom;
    }
  }

  @override
  void initState() {
    titleAnimationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  _creatmenutitle(MenuController menuController) {
    switch (menuController.state) {
      case MenuState.open:
      case MenuState.opening:
        titleAnimationController.forward();
        break;
      case MenuState.closed:
      case MenuState.closing:
        titleAnimationController.reverse();
        break;
    }

    return AnimatedBuilder(
      animation: titleAnimationController,
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxWidth: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            "منو",
            style: TextStyle(color: Colors.grey, fontSize: 220.0),
          ),
        ),
      ),
      builder: (BuildContext context, Widget child) {
        return Transform(
          child: child,
          transform: Matrix4.translationValues(
              250.0 * (1.0 - titleAnimationController.value) - 100.0, 0.0, 0.0),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ZoomScaffoldMenuController(
      builder: (BuildContext context, MenuController menuController) {
        var actualSelectorYTop = selectorYTop;
        var actualSelectorYBottom = selectorYBottom;
        var seletorOpacity = 1.0;

        if (menuController.state == MenuState.closed ||
            menuController.state == MenuState.closing) {
          final RenderBox menuScreenRenderBox =
              context.findRenderObject() as RenderBox;
          if (menuScreenRenderBox != null) {
            final menuScreenHeight = menuScreenRenderBox.size.height;
            actualSelectorYBottom = menuScreenHeight;
            actualSelectorYTop = menuScreenHeight - 50.0;
            seletorOpacity = 0.0;
          } else {
            actualSelectorYBottom = 0.0;
            actualSelectorYTop = 0.0;
            seletorOpacity = 0.0;
          }
        }
        return Container(
          
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/mainback.jpg'), fit: BoxFit.cover)),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                _creatmenutitle(menuController),
                _menuItems(menuController),
                ItemSelector(
                    actualSelectorYTop, actualSelectorYBottom, seletorOpacity),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ItemSelector extends ImplicitlyAnimatedWidget {
  final double topY;
  final double bottomY;
  final double opacity;

  ItemSelector(this.topY, this.bottomY, this.opacity)
      : super(duration: Duration(milliseconds: 250));

  _ItemSelectorState createState() => _ItemSelectorState();
}

class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {
  Tween<double> _topY;
  Tween<double> _bottomY;
  Tween<double> _opacity;

  @override
  void forEachTween(visitor) {
    _topY = visitor(
        _topY, widget.topY, (dynamic value) => Tween<double>(begin: value));
    _bottomY = visitor(_bottomY, widget.bottomY,
        (dynamic value) => Tween<double>(begin: value));
    _opacity = visitor(_opacity, widget.opacity,
        (dynamic value) => Tween<double>(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topY.evaluate(animation),
      child: Opacity(
        opacity: _opacity.evaluate(animation),
        child: Container(
          width: 5.0,
          height: _bottomY.evaluate(animation) - _topY.evaluate(animation),
          color: Colors.red,
        ),
      ),
    );
  }
}

class AnimationMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuItems menuListItem;
  final MenuState menuState;
  final Duration duration;
  final bool isselected;

  AnimationMenuListItem(
      {this.menuListItem,
      this.menuState,
      this.duration,
      this.isselected,
      curve})
      : super(duration: duration, curve: curve);

  _AnimationMenuListItemState createState() => _AnimationMenuListItemState();
}

class _AnimationMenuListItemState
    extends AnimatedWidgetBaseState<AnimationMenuListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;

  updateSelectedRenderBox() {
    final renderBox = context.findRenderObject() as RenderBox;
    if (renderBox != null && widget.isselected) {
      (menuScreenKey.currentState as _MenuScreenState)
          .selectedRenderBox(renderBox);
    }
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    var slide, opacity;

    switch (widget.menuState) {
      case MenuState.closed:
      case MenuState.closing:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;
      case MenuState.open:
      case MenuState.opening:
        slide = openSlidePosition;
        opacity = 1.0;
        break;
    }
    _translation = visitor(
      _translation,
      slide,
      (dynamic value) => Tween<double>(begin: value),
    );

    _opacity = visitor(
        _opacity, opacity, (dynamic value) => Tween<double>(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    updateSelectedRenderBox();
    return Opacity(
      opacity: _opacity.evaluate(animation),
      child: Transform(
        transform: Matrix4.translationValues(
            0.0, _translation.evaluate(animation), 0.0),
        child: widget.menuListItem,
      ),
    );
  }
}

class _MenuItems extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function() onTap;

  _MenuItems({this.title, this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.pinkAccent,
      onTap: isSelected ? null : onTap,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: Text(
            title,
            style: TextStyle(
                color: isSelected ? Colors.pink.shade700 : Colors.grey.shade700,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class Menu {
  final List<MenuItem> items;

  Menu({this.items});
}

class MenuItem {
  final String id;
  final String title;

  MenuItem({this.id, this.title});
}
