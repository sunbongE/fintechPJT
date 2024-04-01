import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/repository/api/ApiMyPage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../models/CustomDivider.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../screen/MoneyRequest.dart';
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
        'option': isOption ? 'my' : 'all',
      };
      print("queryParameters: ${queryParameters}");
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '정산 요청 내역',
                  style: TextStyle(
                    fontSize: min(26.sp, 26.sp),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        print(1);
                        changeOption();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BUTTON_COLOR,
                        minimumSize: Size(40.w, 30.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        '내가 포함된 정산',
                        style: TextStyle(
                          fontSize: min(15.sp, 15.sp),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () => buttonSlideAnimation(
                          context,
                          MoneyRequest(
                            groupId: widget.groupId,
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BUTTON_COLOR,
                        minimumSize: Size(40.w, 30.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        '정산 추가',
                        style: TextStyle(
                          fontSize: min(15.sp, 15.sp),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView<int, Map<String, dynamic>>(
            shrinkWrap: true,
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
              itemBuilder: (context, item, index) => InkWell(
                onTap: () {
                  print("전승혜 메롱");
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
                          Column(
                            children: [
                              Text(
                                '-${NumberFormat('#,###').format(int.parse(item['transactionBalance'].toString()))}원',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
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
      ],
    );
  }
}
