import 'package:flutter/material.dart';

class ImageDisplayPage<T> extends StatefulWidget {
  final int limit;
  final int page;
  final Future<List<T>> Function(int page, int limit) fetchData;
  final Widget Function(BuildContext context, T item) itemWidgetBuilder;
  final VoidCallback? onFetchItems; // 外部传入的触发刷新回调

  ImageDisplayPage({
    required this.fetchData,
    required this.itemWidgetBuilder,
    this.page = 1,
    this.limit = 8,
    this.onFetchItems, // 外部传入刷新回调
  });

  @override
  _ImageDisplayPageState<T> createState() => _ImageDisplayPageState<T>();
}

class _ImageDisplayPageState<T> extends State<ImageDisplayPage<T>> {
  List<T> items = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMoreData = true;

  // 请求数据的方法
  Future<void> fetchItems(int page) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<T> newItems = await widget.fetchData(page, widget.limit);
      setState(() {
        if (page == 1) {
          items = newItems;
        } else {
          items.addAll(newItems);
        }
        isLoading = false;
        hasMoreData = newItems.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void reloadData() {
    setState(() {
      currentPage = 1;
      items.clear();
    });
    fetchItems(currentPage);
  }

  @override
  void initState() {
    super.initState();
    fetchItems(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Item Gallery')),
      body: Column(
        children: [
          Expanded(
            child: isLoading && items.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: items.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return Center(child: CircularProgressIndicator());
                }
                return widget.itemWidgetBuilder(context, items[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!isLoading) {
                      setState(() {
                        currentPage--;
                      });
                      fetchItems(currentPage);
                    }
                  },
                  child: Text('Previous Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!isLoading) {
                      setState(() {
                        currentPage++;
                      });
                      fetchItems(currentPage);
                    }
                  },
                  child: Text('Next Page'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
