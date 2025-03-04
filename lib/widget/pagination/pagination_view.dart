import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';


class PaginationGridView<T> extends StatefulWidget {
  final Future<(List<T>, int)> Function(int page, int itemsPerPage) fetchData;
  final Widget Function(BuildContext context,int index ,T item) itemWidgetBuilder;

  const PaginationGridView({
    super.key,
    required this.fetchData,
    required this.itemWidgetBuilder,
  });

  @override
  PaginationGridViewState<T> createState() => PaginationGridViewState<T>();
}

class PaginationGridViewState<T> extends State<PaginationGridView<T>>
    with AutomaticKeepAliveClientMixin {
  static const int _itemsPerPage = 8;
  int _currentPage = 1;
  final List<T> _items = [];
  bool _isLoading = false;
  int _totalItems = 0; // 动态存储总数

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadData({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    if (refresh) {
      _currentPage = 1;
      _items.clear();
    }

    try {
      int startIndex = (_currentPage - 1) * _itemsPerPage;
      if (startIndex >= _totalItems && _totalItems > 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已到达最后一页')),
          );
        }
      } else if (startIndex >= _items.length || refresh) {
        final (data, total) = await widget.fetchData(_currentPage, _itemsPerPage);
        if (mounted) {
          setState(() {
            if (refresh) _items.clear(); // 刷新时清空
            _items.addAll(data);
            _totalItems = total; // 更新总数
          });
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<T> getItems(){
    return _items;
  }

  int getCurrentPage(){
    return _currentPage;
  }

  void _nextPage() {
    int nextStartIndex = _currentPage * _itemsPerPage;
    if (nextStartIndex >= _totalItems && _totalItems > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已到达最后一页')),
      );
    } else {
      setState(() {
        _currentPage++;
      });
      loadData();
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  List<T> _getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, _totalItems);
    if (startIndex >= _items.length || startIndex >= _totalItems) return [];
    return _items.sublist(startIndex, endIndex.clamp(0, _items.length));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentItems = _getCurrentPageItems();
    final totalPages = (_totalItems / _itemsPerPage).ceil();

    return Column(
      children: [
        Expanded(
          child: currentItems.isEmpty && !_isLoading
              ? const Center(child: Text('暂无数据'))
              : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 200 / 135,
            ),
            itemCount: currentItems.length,
            itemBuilder: (context, index) =>
                widget.itemWidgetBuilder(context, index, currentItems[index]),
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PaginationWidget(
            currentPage: _currentPage,
            totalPages: totalPages,
            totalItems: _totalItems,
            onPrevious: _previousPage,
            onNext: _nextPage,
          ),
        ),
      ],
    );
  }
}

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PaginationWidget({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('共 $totalItems 条'),
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentPage > 1 ? onPrevious : null,
        ),
        Text('$currentPage / $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages ? onNext : null,
        ),
      ],
    );
  }
}