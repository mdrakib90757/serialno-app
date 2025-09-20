import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:serialno_app/utils/color.dart';

class CustomDropdown<T> extends StatefulWidget {
  final Widget? child;
  final List<T> items;
  final T? value;
  final T? selectedItem;
  final ValueChanged<T> onChanged;
  final String Function(T item) itemAsString;
  final double popupHeight;
  final String? Function(T? value)? validator;
  final String? hinText;

  const CustomDropdown({
    Key? key,
    this.child,
    required this.items,
    this.value,
    required this.onChanged,
    required this.itemAsString,
    this.popupHeight = 200.0,
    this.selectedItem,
    this.validator,
    this.hinText,
  }) : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
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
    _formFieldKey.currentState?.validate();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _formFieldKey.currentContext!.findRenderObject() as RenderBox;
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
                child: Container(color: Colors.transparent),
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
                          visualDensity: VisualDensity(
                            horizontal: 0,
                            vertical: -4,
                          ),
                          title: Text(widget.itemAsString(item)),
                          onTap: () {
                            _formFieldKey.currentState!.didChange(item);
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
      child: FormField<T>(
        key: _formFieldKey,
        initialValue:
            widget.value, // This is the initial value passed to FormField
        validator: widget.validator,
        builder: (FormFieldState<T> state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.value != widget.selectedItem) {
              state.didChange(widget.selectedItem);
            }
          });
          // This rebuilds when state.value changes (e.g., via didChange)
          return GestureDetector(
            onTap: _togglePopup,
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: state.value == null ? widget.hinText : null,
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor().primariColor),
                ),
                suffixIcon: Icon(Icons.arrow_drop_down,),
                errorText: state.errorText,
              ),
              isEmpty: state.value == null,
              child: Text(
                state.value == null ? '' : widget.itemAsString(state.value!),
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          );
        },

        autovalidateMode: AutovalidateMode.disabled,
      ),
    );
  }
}
