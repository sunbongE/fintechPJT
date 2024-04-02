import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import '../../models/CustomDivider.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../repository/api/ApiMyPage.dart';
import 'GroupSpendItem.dart';

class GroupSpendList extends StatefulWidget {
  final int groupId;

  const GroupSpendList({
    required this.groupId,
    super.key,
  });

  @override
  State<GroupSpendList> createState() => _GroupSpendListState();
}

class _GroupSpendListState extends State<GroupSpendList> {
  static const _pageSize = 10;
  String option = 'all';
  final PagingController<int, Map<String, dynamic>> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      Map<String, dynamic> queryParameters = {
        'page': pageKey,
        'size': _pageSize,
        'option': option,
      };
      Response res = await getGroupSpend(widget.groupId, queryParameters);
      if (res.data != null) {
        List<Map<String, dynamic>> newData = List<Map<String, dynamic>>.from(res.data).cast<Map<String, dynamic>>();

        // transactionTime을 기준으로 내림차순 정렬
        newData.sort((a, b) => b["transactionTime"].compareTo(a["transactionTime"]));

        final isLastPage = newData.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newData);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newData, nextPageKey);
        }
      } else {
        _pagingController.appendLastPage([]);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  String formatDate(String date) {
    return "${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(6, 8)}";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, Map<String, dynamic>>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
            itemBuilder: (context, item, index) => InkWell(
              onTap: () {
                buttonSlideAnimation(
                  context,
                  GroupSpendItem(groupId: widget.groupId, paymentId: item['transactionId']),
                );
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              formatDate(item['transactionDate'].toString()),
                              style: TextStyle(fontSize: 13.sp),
                            ),
                            SizedBox(width: 25.w),
                            Text(
                              item['transactionSummary'],
                              style: TextStyle(fontSize: 20.sp),
                            ),
                          ],
                        ),
                        item['transactionType'] == "1"
                            ? Text(
                                '${NumberFormat('#,###').format(int.parse(item['transactionBalance'].toString()))}원',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: TEXT_COLOR,
                                ),
                              )
                            : Text(
                                '-${NumberFormat('#,###').format(int.parse(item['transactionBalance'].toString()))}원',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: RECEIPT_TEXT_COLOR,
                                ),
                              ),
                      ],
                    ),
                  ),
                  CustomDivider(),
                ],
              ),
            ),
            firstPageErrorIndicatorBuilder: (context) => Center(
              child: Text('다시 시도해 주세요'),
            ),
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: Text('결제내역이 없습니다'),
            ),
          ),
        ),
      ),
    );
  }
}
