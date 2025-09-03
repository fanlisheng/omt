import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as ui;

/// 带输入搜索和下拉选择的控件
/// 支持动态过滤、选择回调和中文输入
class SearchableDropdown<T> extends StatefulWidget {
  final GlobalKey<AutoSuggestBoxState> asgbKey;
  final FocusNode focusNode;
  final TextEditingController controller;
  final List<T> items;
  final String placeholder;
  final TextStyle placeholderStyle;
  final WidgetStateProperty<BoxDecoration> decoration;
  final Function(T?)? onSelected;
  final String Function(T) labelSelector; // 新增：自定义 label 生成
  final bool enabled;
  final bool clearButtonEnabled;
  final T? selectedValue; // 新增：当前选中的值

  const SearchableDropdown({
    super.key,
    required this.asgbKey,
    required this.focusNode,
    required this.controller,
    required this.items,
    this.placeholder = "请选择或输入",
    this.placeholderStyle = const TextStyle(fontSize: 12),
    this.decoration = const WidgetStatePropertyAll(BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.transparent,
          width: 2.0,
        ),
      ),
    )),
    this.onSelected,
    required this.labelSelector, // 要求提供 labelSelector
    this.enabled = true,
    this.clearButtonEnabled = false,
    this.selectedValue, // 新增：当前选中的值
  });

  @override
  SearchableDropdownState<T> createState() => SearchableDropdownState<T>();
}

class SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  T? _selectedInstance;
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items; // 初始显示所有选项
    
    // 如果有初始选中值，设置_selectedInstance和controller文本
    if (widget.selectedValue != null) {
      _selectedInstance = widget.selectedValue;
      widget.controller.text = widget.labelSelector(widget.selectedValue!);
    }
    
    _setupFocusListener();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当外部传入的selectedValue发生变化时，更新内部状态
    if (widget.selectedValue != oldWidget.selectedValue) {
      _selectedInstance = widget.selectedValue;
      if (widget.selectedValue != null) {
        widget.controller.text = widget.labelSelector(widget.selectedValue!);
      } else {
        widget.controller.clear();
      }
    }
  }

  void _setupFocusListener() {
    widget.focusNode.addListener(() {
      final asgbState = widget.asgbKey.currentState;
      if (asgbState == null) return;
      if (widget.focusNode.hasFocus) {
        asgbState.showOverlay();
      } else {
        if (asgbState.isOverlayVisible) {
          asgbState.dismissOverlay();
        }
        widget.controller.text = _selectedInstance != null ? widget.labelSelector(_selectedInstance!) : "";
      }
      setState(() {});
    });
  }

  void _onTextChanged() {
    final query = widget.controller.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          return widget.labelSelector(item).toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoSuggestBox<T>(
      key: widget.asgbKey,
      enabled: widget.enabled,
      placeholder: widget.placeholder,
      focusNode: widget.focusNode,
      controller: widget.controller,
      placeholderStyle: widget.placeholderStyle,
      decoration: widget.decoration,
      clearButtonEnabled: widget.clearButtonEnabled,
      onChanged: (text, reason) {
        if (reason == TextChangedReason.cleared) {
          setState(() {
            _selectedInstance = null;
            _filteredItems = widget.items;
          });
          if (widget.onSelected != null) {
            widget.onSelected!(null);
          }
        }
      },
      items: _filteredItems
          .map<AutoSuggestBoxItem<T>>(
            (instance) => AutoSuggestBoxItem<T>(
          value: instance,
          label: widget.labelSelector(instance), // 使用 labelSelector
          onSelected: () {
            setState(() {
              _selectedInstance = instance;
              widget.controller.text = widget.labelSelector(instance);
            });
            widget.focusNode.unfocus();
            if (widget.onSelected != null) {
              widget.onSelected!(instance);
            }
          },
        ),
      )
          .toList(),
      itemBuilder: (BuildContext context, AutoSuggestBoxItem<dynamic> item) {
        return ui.InkWell(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.labelSelector(item.value as T), // 使用 labelSelector
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
            ),
          ),
          onTap: () {
            if (item.onSelected != null) {
              widget.focusNode.unfocus();
              item.onSelected!();
            }
          },
        );
      },
      onSelected: (item) {
        setState(() {
          _selectedInstance = item.value as T;
        });
        if (widget.onSelected != null) {
          widget.onSelected!(item.value as T);
        }
      },
      onOverlayVisibilityChanged: (visible) {
        debugPrint('下拉框可见性: $visible');
        setState(() {});
      },
    );
  }
}
