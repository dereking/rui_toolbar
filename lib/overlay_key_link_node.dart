import 'dart:collection';

import 'package:flutter/material.dart';

final class OverlayKeyLinkNode extends LinkedListEntry<OverlayKeyLinkNode> {
  final String key;
  final OverlayEntry overlay;

  OverlayKeyLinkNode(this.key, this.overlay);
}