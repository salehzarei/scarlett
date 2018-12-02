import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

const double _kFlingVelocity = 2.0;

class BackDrop extends StatefulWidget {
  final String currentCategory;
  final Widget forntLayer;
  final Widget backLayer;
  final Widget forntTitle;
  final Widget backTitle;

  const BackDrop(
      {@required this.currentCategory,
      @required this.forntLayer,
      @required this.backLayer,
      @required this.backTitle,
      @required this.forntTitle})
      : assert(currentCategory != null),
        assert(forntLayer != null),
        assert(backLayer != null),
        assert(backTitle != null),
        assert(forntTitle != null);
  _BackDropState createState() => _BackDropState();
}

class _BackDropState extends State<BackDrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdorpKey = GlobalKey(debugLabel: 'BackDrop');

  AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BackDrop old) {
    super.didUpdateWidget(old);

    if (widget.currentCategory != old.currentCategory) {
      _toggleBackdropLayerVisibility();
    } else if (!_frontLayerVisible) {
      _controller.fling(velocity: _kFlingVelocity);
    }
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  Widget _buildStack(BuildContext contexy, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, layerTop, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);

    return Stack(
      key: _backdorpKey,
      children: <Widget>[
        ExcludeSemantics(
          child: widget.backLayer,
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(child: widget.forntLayer , onTap: _toggleBackdropLayerVisibility,),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      backgroundColor: Colors.white24,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.pink,
        ),
        onPressed: _toggleBackdropLayerVisibility,
      ),
      title: Text(
        widget.currentCategory,
        style: TextStyle(color: Colors.pink),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            semanticLabel: 'جستجو',
            color: Colors.pink,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.tune,
            color: Colors.pink,
            semanticLabel: 'فیلتر',
          ),
          onPressed: () {},
        ),
      ],
    );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: LayoutBuilder(
            builder: _buildStack,
          )),
    );
  }
}

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({
    Key key,
    this.onTap,
    this.child,
  }) : super(key: key);
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 120.0,
      // shape: BeveledRectangleBorder(
      //   borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0)),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Container(
                height: 40.0,
                alignment: AlignmentDirectional.centerStart,
              )),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
