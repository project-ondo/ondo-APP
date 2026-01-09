import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';
import 'package:ondo/presentation/home/widgets/home_alert_button.dart';

class HomeTopBar extends StatefulWidget {

  const HomeTopBar({super.key});

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> {
  late TextEditingController _searchController;


  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }


  final height = 44.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: height,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.gray20,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(Icons.search, color: AppColors.gray60, size: 14.2,),
                    ),

                    Text("게시물 또는 프로필 검색어를 입력해 주세요", style: AppTextStyles.textMedium(textColor: AppColors.gray60),),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: HomeAlertButton(size: height,),
          ),
        ],
      ),
    );
  }
}
