import 'package:flutter/material.dart';

/// A customized gridview utility class
class NineChildDelegate extends SliverChildDelegate {
  int secondChildParIndex;
  List<Widget> children;
  Widget secondChild;

  NineChildDelegate( // this.childCount,
      {
    this.children,
    this.secondChild,
    this.secondChildParIndex,
  });

  @override
  Widget build(BuildContext context, int index) {
    if ((children?.length ?? 0) < index + 1) return null;

    return children[index];
  }

  @override
  bool shouldRebuild(SliverChildDelegate oldDelegate) => true;

  @override
  int get estimatedChildCount => children?.length ?? 0;
}
