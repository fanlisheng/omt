import 'package:flutter/material.dart';

// PaginationGridView 负责数据和分页逻辑
class PaginationGridView extends StatefulWidget {
  final Widget? itemWidget;

  const PaginationGridView({super.key, this.itemWidget});

  @override
  _PaginationGridViewState createState() => _PaginationGridViewState();
}

class _PaginationGridViewState extends State<PaginationGridView> {
  final List<String> imageUrls = List.generate(40, (index) => '图片 $index');
  int currentPage = 1;
  final int itemsPerPage = 8;

  // 获取当前页显示的图片
  List<String> get currentPageImages {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (currentPage * itemsPerPage) > imageUrls.length
        ? imageUrls.length
        : currentPage * itemsPerPage;
    return imageUrls.sublist(startIndex, endIndex);
  }

  void _nextPage() {
    if (currentPage < (imageUrls.length / itemsPerPage).ceil()) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (imageUrls.length / itemsPerPage).ceil();

    return Column(
      children: [
        // 图片网格显示
        Expanded(
          child: Container(
              child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 200 / 135),
            itemCount: currentPageImages.length,
            itemBuilder: (context, index) {
              return widget.itemWidget ??
                  ItemWidget(item: currentPageImages[index]);
            },
          )),
        ),
        // 分页控件
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PaginationWidget(
            currentPage: currentPage,
            totalPages: totalPages,
            onPrevious: _previousPage,
            onNext: _nextPage,
          ),
        ),
      ],
    );
  }
}

// ItemWidget 用于展示每一项
class ItemWidget extends StatelessWidget {
  final String item;

  ItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Center(child: Text(item)),
    );
  }
}

// PaginationWidget 负责分页控制
class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  PaginationWidget({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('共 40 条'),
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: currentPage > 1 ? onPrevious : null,
        ),
        Text('$currentPage / $totalPages'),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages ? onNext : null,
        ),
      ],
    );
  }
}
