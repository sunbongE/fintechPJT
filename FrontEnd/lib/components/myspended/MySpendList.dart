import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../const/colors/Colors.dart';
import '../../models/CustomDivider.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../repository/api/ApiMySpend.dart';
import 'MySpendItem.dart';

class MySpendList extends StatefulWidget {
  const MySpendList({Key? key}) : super(key: key);

  @override
  State<MySpendList> createState() => _MySpendListState();
}

class _MySpendListState extends State<MySpendList> {
  // 페이지에 보여질 개수
  static const _pageSize = 10;

  // 무한스크롤 페이지네이션 시작(첫 페이지: 0)
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
      };
      Response res = await getMyAccount(queryParameters);
      if (res.data != null) {
        List<Map<String, dynamic>> newData = List<Map<String, dynamic>>.from(res.data).cast<Map<String, dynamic>>();

        newData.sort((a, b) => b["transactionUniqueNo"].compareTo(a["transactionUniqueNo"]));

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
                  MySpendItem(spend: item),
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
                              item['transactionDate'],
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
                            ? Column(
                                children: [
                                  Text(
                                    '${NumberFormat('#,###').format(int.parse(item['transactionBalance'].toString()))}원',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: TEXT_COLOR,
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat('#,###').format(int.parse(item['transactionAfterBalance'].toString()))}원',
                                    style: TextStyle(
                                      color: RECEIPT_TEXT_COLOR,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    '-${NumberFormat('#,###').format(int.parse(item['transactionBalance'].toString()))}원',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: RECEIPT_TEXT_COLOR,
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat('#,###').format(int.parse(item['transactionAfterBalance'].toString()))}원',
                                    style: TextStyle(
                                      color: RECEIPT_TEXT_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  CustomDivider(),
                ],
              ),
            ),
            firstPageErrorIndicatorBuilder: (context) => Center(
              child: Text('결제내역이 없습니다\n다른 계좌를 선택하세요'),
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
