import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';

class CommentsWidget extends StatefulWidget {
  const CommentsWidget(this.id, {Key? key, required this.type, this.count})
      : super(key: key);

  final String id;

  final int? count;

  final FeedItemType type;

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  late final LoadingBase<CommentItemModel> _lb = LoadingBase(
    getCursorType: () => CursorType.raw,
    request: (_, String? lastId) => InteractAPI.getCommentByTypeAndId(
      type: widget.type,
      id: widget.id,
      lastId: lastId,
    ),
  );

  /// from widget.count but can update
  int count = 0;

  /// whether this popup has dragged to max size
  bool isMaxed = false;

  final draggableScrollableController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    count = widget.count ?? 0;
    draggableScrollableController.addListener(_onDragScroll);
  }

  @override
  void dispose() {
    draggableScrollableController.removeListener(_onDragScroll);
    super.dispose();
  }

  void _onDragScroll() {
    if (isMaxed) {
      return;
    }
    if (draggableScrollableController.size >= 0.85) {
      setState(() {
        isMaxed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.85,
      snapSizes: const [0.5, 0.85],
      snap: true,
      controller: draggableScrollableController,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // To ignore dragscroll when popup is max sized
                  IgnorePointer(
                    child: SizedBox(
                      width: 40,
                      height: 20,
                      child: ListView.builder(
                        controller: isMaxed ? scrollController : null,
                        itemBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          context.l10n.pinTotalCommentCount(count),
                          style: context.textTheme.caption,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Semantics(
                      button: true,
                      label: context.l10n.close,
                      child: const Icon(Icons.close_outlined, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: RefreshListWrapper(
                    // when maxed, ignore drag and respond drop-down refresh
                    controller: isMaxed ? null : scrollController,
                    loadingBase: _lb,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (CommentItemModel model) => _CommentItem(
                      model,
                      key: ValueKey<String>(model.commentId),
                    ),
                    dividerBuilder: (_, __) => const Gap.v(8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CommentItem extends StatelessWidget {
  const _CommentItem(this.item, {Key? key}) : super(key: key);

  final CommentItemModel item;

  Widget _buildInteractions(BuildContext context) {
    return DefaultTextStyle.merge(
      style: context.textTheme.caption,
      child: IconTheme(
        data: IconTheme.of(context).copyWith(
          color: context.textTheme.caption?.color,
          size: 14,
        ),
        child: Row(
          children: <Widget>[
            _buildDigg(context),
            const Gap.h(16.0),
            _buildComment(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDigg(BuildContext context) {
    final int count = item.commentInfo.diggCount;
    return GestureDetector(
      onTap: () {
        showToast(context.l10n.notSupported);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.thumb_up_alt_outlined),
            const Gap.h(4),
            Text(count == 0 ? context.l10n.actionLike : '$count'),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(BuildContext context) {
    final int count = item.commentInfo.replyCount;
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.message_outlined),
            const Gap.h(4),
            Text(count == 0 ? context.l10n.actionReply : '$count'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 42,
          child: item.userInfo.buildCircleAvatar(),
        ),
        const Gap.h(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.userInfo.userName,
                      style: context.textTheme.caption?.copyWith(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap.v(8),
                  Text(
                    item.commentInfo.createTimeString(context),
                    style: context.textTheme.caption,
                  ),
                ],
              ),
              const Gap.v(8),
              ExtendedText(item.commentInfo.commentContent),
              const Gap.v(8),
              _buildInteractions(context),
              const Gap.v(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                  color: context.theme.canvasColor,
                ),
                child: Column(
                  children: [
                    for (final reply in item.replyInfos)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _ReplyItem(reply),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReplyItem extends StatelessWidget {
  const _ReplyItem(this.reply, {Key? key}) : super(key: key);

  final ReplyInfo reply;

  Widget _buildInteractions(BuildContext context) {
    return DefaultTextStyle.merge(
      style: context.textTheme.caption,
      child: IconTheme(
        data: IconTheme.of(context).copyWith(
          color: context.textTheme.caption?.color,
          size: 14,
        ),
        child: Row(
          children: <Widget>[
            _buildDigg(context),
            const Gap.h(16.0),
            _buildComment(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDigg(BuildContext context) {
    final int count = reply.replyInfo.diggCount;
    return GestureDetector(
      onTap: () {
        showToast(context.l10n.notSupported);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.thumb_up_alt_outlined),
            const Gap.h(4),
            Text(count == 0 ? context.l10n.actionLike : '$count'),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.message_outlined),
            const Gap.h(4),
            Text(context.l10n.actionReply),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          child: reply.userInfo.buildCircleAvatar(),
        ),
        const Gap.h(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      reply.userInfo.userName,
                      style: context.textTheme.caption?.copyWith(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap.v(8),
                  Text(
                    reply.replyInfo.createTimeString(context),
                    style: context.textTheme.caption,
                  ),
                ],
              ),
              const Gap.v(8),
              ExtendedText(reply.replyInfo.replyContent),
              const Gap.v(8),
              _buildInteractions(context),
            ],
          ),
        ),
      ],
    );
  }
}
