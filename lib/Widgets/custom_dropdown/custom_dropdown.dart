import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final Widget child;
  final List<T> items;
  final T? value;
  final ValueChanged<T> onChanged;
  final String Function(T item) itemAsString;
  final double popupHeight;

  const CustomDropdown({
    Key? key,
    required this.child,
    required this.items,
    this.value,
    required this.onChanged,
    required this.itemAsString,
    this.popupHeight = 200.0,
  }) : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool get _isPopupOpen => _overlayEntry != null;

  void _togglePopup() {
    if (_isPopupOpen) {
      _closePopup();
    } else {
      _openPopup();
    }
  }

  void _openPopup() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    var screenHeight = MediaQuery.of(context).size.height;

    var fieldBottomY = offset.dy + size.height;

    bool hasSpaceBelow =
        (screenHeight - fieldBottomY) > (widget.popupHeight + 10);

    var yOffset = hasSpaceBelow
        ? size.height + 5.0
        : -(widget.popupHeight + 5.0);

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _closePopup,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),

            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, yOffset),
                child: Material(
                  color: Colors.white,

                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(8.0),

                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: widget.popupHeight),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return ListTile(
                          title: Text(widget.itemAsString(item)),
                          onTap: () {
                            widget.onChanged(item);
                            _closePopup();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(onTap: _togglePopup, child: widget.child),
    );
  }
}
