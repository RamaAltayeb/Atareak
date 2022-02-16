import 'package:flutter/material.dart';

const _horizontalPadding = 32.0;
const _carouselItemMargin = 8.0;

class AnimationSlider extends StatefulWidget {
  final List<Widget> children;
  final Function(int index) onPageChanged;
  const AnimationSlider({this.children, this.onPageChanged});
  @override
  _AnimationSliderState createState() => _AnimationSliderState();
}

class _AnimationSliderState extends State<AnimationSlider>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int _currentPage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;
    const padding = (_horizontalPadding * 2) - (_carouselItemMargin * 2);
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: (width - padding) / width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PageView(
        onPageChanged: (index) {
          setState(() => _currentPage = index);
          widget.onPageChanged(index);
        },
        controller: _pageController,
        children: <Widget>[
          for (int i = 0; i < widget.children.length; i++) buildItem(i),
        ],
      ),
    );
  }

  Widget buildItem(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        return Center(
          child: Transform(
            transform: Matrix4.diagonal3Values(1, 1, 1),
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.all(8),
              child: widget.children.elementAt(index),
            ),
          ),
        );
      },
    );
  }
}
