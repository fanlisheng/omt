import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayo_package/views/widget/base/_index_widget_base.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FIleViewPage extends StatefulWidget {
  final File? file;
  final String? url;

  const FIleViewPage({Key? key, this.file, this.url}) : super(key: key);

  @override
  _PDFViewPage createState() => _PDFViewPage();
}

class _PDFViewPage extends State<FIleViewPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  File? file;
  String? url;

  @override
  void initState() {
    super.initState();

    setState(() {
      file = widget.file;
      url = widget.url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: body(),
    );
  }

  body() {
    if (null == file && null == url) {
      return Center(
        child: TextView(
          '打开PDF失败',
          fontWeight: FontWeight.bold,
          size: 16,
        ),
      );
    }

    return null != file
        ? SfPdfViewer.file(
            file!,
            key: _pdfViewerKey,
          )
        : SfPdfViewer.network(
            url!,
            key: _pdfViewerKey,
          );
  }
}
