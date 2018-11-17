import 'package:flutter/material.dart';
import '../pages/zoomsacaffold.dart';

class MenuScreen extends StatefulWidget {
  _MenuScreenState createState() => _MenuScreenState();
}

_menuItems(MenuController menucontroller) {
  final titles = ['دسته بندی', 'محصولات من', 'فروش', 'کاربران'];
  final selectedIndex = 0;
  final animationIntervalDuration = 0.5;
  final List<Widget> listitems = [];
  final perListItemDelay =
      menucontroller.state != MenuState.closing ? 0.15 : 0.0;

  for (var i = 0; i < titles.length; ++i) {
    final animationIntervalStart = perListItemDelay * i;
    final animationInterbalEnd =
        animationIntervalStart + animationIntervalDuration;
    listitems.add(
      AnimationMenuListItem(
        menuState: menucontroller.state,
        duration: Duration(milliseconds: 600),
        curve: Interval(animationIntervalStart, animationInterbalEnd,
            curve: Curves.easeOut),
        menuListItem: _MenuItems(
          title: titles[i],
          isSelected: i == selectedIndex,
          onTap: () {
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

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  AnimationController titleAnimationController;

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
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/mainback.jpg'), fit: BoxFit.cover)),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                _creatmenutitle(menuController),
                _menuItems(menuController)
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimationMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuItems menuListItem;
  final MenuState menuState;
  final Duration duration;

  AnimationMenuListItem(
      {this.menuListItem, this.menuState, this.duration, curve})
      : super(duration: duration, curve: curve);

  _AnimationMenuListItemState createState() => _AnimationMenuListItemState();
}

class _AnimationMenuListItemState
    extends AnimatedWidgetBaseState<AnimationMenuListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;

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
