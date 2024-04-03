import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/entities/Expense.dart';
import 'package:front/repository/api/ApiMyPage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../models/CustomDivider.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../screen/MoneyRequest.dart';
import '../split/SplitRequestDetail.dart';
import 'GroupNoCal.dart';

class GroupCalCheck extends StatefulWidget {
  final int groupId;

  const GroupCalCheck({
    required this.groupId,
    super.key,
  });

  @override
  State<GroupCalCheck> createState() => _GroupCalCheckState();
}

class _GroupCalCheckState extends State<GroupCalCheck> {
  bool isOption = false;
  bool hasData = false;
  static const _pageSize = 10;
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

  void changeOption() {
    setState(() {
      isOption = !isOption;
      _pagingController.refresh();
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      Map<String, dynamic> queryParameters = {
        'page': pageKey,
        'size': _pageSize,
        'option': isOption ? 'all' : 'my',
      };
      Response res = await getGroupSpend(widget.groupId, queryParameters);
      if (res.data != null) {
        List<Map<String, dynamic>> newData = List<Map<String, dynamic>>.from(res.data).cast<Map<String, dynamic>>();
        final isLastPage = newData.length < _pageSize;
        print("isLastPage: ${isLastPage}");
        if (isLastPage) {
          _pagingController.appendLastPage(newData);
        } else {
          final nextPageKey = pageKey + 1;
          print("nextPageKey: ${nextPageKey}");
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
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 350.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0.h),
              Divider(
                height: 10.h,
              ),
              SizedBox(height: 15.0.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '정산 요청 내역',
                  style: TextStyle(
                    fontSize: min(22.sp, 22.sp),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 14.0.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print(1);
                        changeOption();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: BUTTON_COLOR.withOpacity(0.8),
                        surfaceTintColor: BUTTON_COLOR.withOpacity(0.6),
                        foregroundColor: Colors.white,
                        minimumSize: Size(40.w, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        isOption ? '해야할 정산' : '모든 정산',
                        style: TextStyle(
                          fontSize: min(16.sp, 21.sp),
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => buttonSlideAnimation(context, MoneyRequest(groupId: widget.groupId)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BUTTON_COLOR.withOpacity(0.8),
                        surfaceTintColor: BUTTON_COLOR.withOpacity(0.6),
                        foregroundColor: Colors.white,
                        minimumSize: Size(40.w, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        '정산 추가',
                        style: TextStyle(
                          fontSize: min(16.sp, 21.sp),
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => _pagingController.refresh(),
            ),
            child: PagedListView<int, Map<String, dynamic>>(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                itemBuilder: (context, item, index) => InkWell(
                  onTap: () {
                    Expense expense = Expense.fromJson(item);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SplitRequestDetail(
                                  expense: expense,
                                  onSuccess: (bool newState) {
                                    setState(() {
                                      //스클릿 리퀘스트 디테일 바뀌었을 때 콜백 함수
                                    });
                                  },
                                  groupId: widget.groupId,
                                )));
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
                                Container(
                                  constraints: BoxConstraints(maxWidth: 120.w),
                                  child: Text(
                                    item['transactionSummary'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '-${NumberFormat('#,###').format(int.parse(item['transactionBalance'].toString()))}원',
                                  style: TextStyle(
                                    fontSize: 15.sp,
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
                firstPageErrorIndicatorBuilder: (context) => Center(child: GroupNoCal(groupId: widget.groupId ?? 0)),
                noItemsFoundIndicatorBuilder: (context) => Center(
                  child: GroupNoCal(groupId: widget.groupId ?? 0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
