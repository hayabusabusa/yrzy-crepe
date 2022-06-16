import 'package:flutter/material.dart';

/// ページネーション用の `ListView`.
class CRPPaginationListView extends StatefulWidget {
  /// ページネーションで追加読み込みを行うスクロール領域の閾値.
  /// 
  /// デフォルトは `40.0` で設定.
  final double threshold;
  final ScrollController scrollController;
  final int itemCount;
  final VoidCallback onReachBottom;
  final Widget Function(BuildContext, int) itemBuilder;

  const CRPPaginationListView({ 
    Key? key,
    this.threshold = 40.0,
    required this.scrollController,
    required this.itemCount,
    required this.onReachBottom,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  State<CRPPaginationListView> createState() => _CRPPaginationListViewState();
}

class _CRPPaginationListViewState extends State<CRPPaginationListView> {

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_listener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: widget.scrollController,
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: widget.itemCount,
        itemBuilder: widget.itemBuilder,
      ),
    );
  }

  /// スクロールのイベント発生時に処理を行うリスナー.
  void _listener() {
    final maxScrollExtent = widget.scrollController.position.maxScrollExtent;
    final position = widget.scrollController.position.pixels;

    // `スクロール領域 - 現在のスクロール位置` で残りのスクロール可能領域を計算する.
    // 慣性スクロール分を無視するため 0 <= 残りのスクロール領域 <= 閾値 になったら次のページを取得する.
    final diff = maxScrollExtent - position;
    final isReachBottom = 0 <= diff && diff <= widget.threshold;
    
    if (isReachBottom) {
      widget.onReachBottom();
    }
  }
}