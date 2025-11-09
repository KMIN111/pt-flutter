import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// [!!] main_screen.dart에서 '오늘의 힐링' 탭으로 이동하기 위해
// 'healing_screen.dart' 파일을 import 합니다.
import 'healing_screen.dart';

// [!!] 감정추적.rtf 파일의 전문을 기반으로 한 위젯입니다.
// (도넛 차트가 아님)

class EmotionTrackingTab extends StatefulWidget {
  // [!!!] 오류 해결 [!!!]
  // main_screen.dart에서 'const EmotionTrackingTab()'으로 호출하므로
  // 이 생성자는 반드시 'const'여야 합니다.
  const EmotionTrackingTab({Key? key}) : super(key: key);

  @override
  _EmotionTrackingTabState createState() => _EmotionTrackingTabState();
}

class _EmotionTrackingTabState extends State<EmotionTrackingTab> {
  // RTF 파일(DIV-5)의 토글 버튼 상태
  int _selectedToggleIndex = 0; // 0: 일간, 1: 주간, 2: 월간

  @override
  Widget build(BuildContext context) {
    // RTF 파일(DIV-2): background: #F9FAFB;
    const Color backgroundColor = Color(0xFFF9FAFB);

    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        // RTF 파일(DIV-3): padding: 80px 24px 96px;
        // (AppBar가 main_screen.dart에 있으므로 상단 패딩은 16.0으로 조절)
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            // [!] 1. 일간/주간/월간 토글 (RTF: DIV-4, DIV-5)
            _buildTimeToggle(),
            const SizedBox(height: 24.0),

            // [!] 2. 오늘의 상태 / 감정 분포 카드 (RTF: DIV-15)
            _buildStatusAndEmotionCard(),
            const SizedBox(height: 24.0),

            // [!] 3. 막대 그래프 카드 (RTF: DIV-111)
            _buildBarChartCard(),
            const SizedBox(height: 24.0),

            // [!] 4. '오늘의 힐링' 네비게이션 카드
            // (RTF 파일의 DIV-308을 '힐링 탭'으로 가는 버튼으로 수정한 버전)
            _buildHealingNavigationCard(context),
          ],
        ),
      ),
    );
  }

  /// 1. 일간/주간/월간 토글 위젯 (RTF: DIV-4, DIV-5)
  Widget _buildTimeToggle() {
    return Card(
      elevation: 1.0, // box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.05);
      shadowColor: Colors.black.withOpacity(0.05),
      color: Colors.white, // background: #FFFFFF;
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // border-radius: 16px;
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // padding: 16px;
        // RTF (DIV-5)
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6), // background: #F3F4F6;
            borderRadius: BorderRadius.circular(12.0), // border-radius: 12px;
          ),
          child: Row(
            children: [
              _buildToggleItem('일간', 0), // RTF (BUTTON-6)
              _buildToggleItem('주간', 1), // RTF (BUTTON-9)
              _buildToggleItem('월간', 2), // RTF (BUTTON-12)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(String text, int index) {
    final bool isSelected = (_selectedToggleIndex == index);

    // RTF (BUTTON-6, 9, 12)
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedToggleIndex = index;
          });
        },
        child: Container(
          height: 36.0, // height: 36px;
          decoration: BoxDecoration(
            // (BUTTON-6) background: #2563EB;
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0), // border-radius: 8px;
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, // font-weight: 500;
                fontSize: 14.0, // font-size: 14px;
                // (일간-8) color: #FFFFFF;
                // (주간-11) color: #4B5563;
                color: isSelected ? Colors.white : const Color(0xFF4B5563),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 2. 오늘의 상태 / 감정 분포 카드 (RTF: DIV-15)
  Widget _buildStatusAndEmotionCard() {
    return Card(
      elevation: 1.0, // box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.05);
      shadowColor: Colors.black.withOpacity(0.05),
      color: Colors.white, // background: #FFFFFF;
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // border-radius: 16px;
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0), // padding: 24px;
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // H2-16: 오늘의 상태
            Text(
              '오늘의 상태',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600, // font-weight: 600;
                fontSize: 18, // font-size: 18px;
                color: const Color(0xFF1F2937), // color: #1F2937;
              ),
            ),
            const SizedBox(height: 16.0), // gap: 16px; (추정)

            // DIV-19: (flex-wrap: wrap)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // DIV-20: 스트레스
                _buildStatusItem(
                  tag: '보통', // (보통-23)
                  tagColor: const Color(0xFFCA8A04), // color: #CA8A04;
                  tagBgColor: const Color(0xFFFEFCE8), // background: #FEFCE8;
                  label: '스트레스', // (스트레스-26)
                  value: '30', // (30-29)
                  valueColor: const Color(0xFF1F2937), // color: #1F2937;
                ),
                // DIV-30: 건강 점수
                _buildStatusItem(
                  label: '건강 점수', // (건강 점수-36)
                  value: '88', // (88-33)
                  valueColor: const Color(0xFF2563EB), // color: #2563EB;
                ),
                // DIV-37: 수면 시간
                _buildStatusItem(
                  label: '수면 시간', // (수면 시간-43)
                  value: '8h', // (8h-40)
                  valueColor: const Color(0xFF9333EA), // color: #9333EA;
                ),
              ],
            ),
            const SizedBox(height: 24.0), // padding: 0px 0px 24px;

            // H3-45: 오늘의 감정 분포
            Text(
              '오늘의 감정 분포',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, // font-weight: 500;
                fontSize: 14, // font-size: 14px;
                color: const Color(0xFF1F2937), // color: #1F2937;
              ),
            ),
            const SizedBox(height: 12.0), // padding: 12px 0px 0px;

            // 감정 목록 (DIV-48 등)
            _buildEmotionProgress('기쁨', 0.55, const Color(0xFF22C55E), '55%'), // 기쁨-54, 55%-60, DIV-57
            _buildEmotionProgress('슬픔', 0.20, const Color(0xFFEF4444), '20%'), // (예시 - RTF에 있음)
            _buildEmotionProgress('불안', 0.15, const Color(0xFFF59E0B), '15%'), // (예시 - RTF에 있음)
            _buildEmotionProgress('평온', 0.10, const Color(0xFF3B82F6), '10%'), // (예시 - RTF에 있음)
          ],
        ),
      ),
    );
  }

  /// 2-1. '오늘의 상태' 아이템
  Widget _buildStatusItem({
    required String label,
    required String value,
    required Color valueColor,
    String? tag,
    Color? tagColor,
    Color? tagBgColor,
  }) {
    // RTF (DIV-20, 30, 37)
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (tag != null) ...[
            // DIV-21
            Chip(
              label: Text(tag, style: GoogleFonts.roboto(
                fontSize: 14, // font-size: 14px;
                fontWeight: FontWeight.w500, // font-weight: 500;
                color: tagColor, // color: #CA8A04;
              )),
              backgroundColor: tagBgColor, // background: #FEFCE8;
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              shape: StadiumBorder(),
            ),
            SizedBox(height: 4),
          ],
          if (tag == null) ...[
            // DIV-31, DIV-38 (태그가 없을 때 값)
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 24, // font-size: 24px;
                fontWeight: FontWeight.w700, // font-weight: 700;
                color: valueColor, // e.g., color: #2563EB;
              ),
            ),
          ],
          // P-24, P-34, P-41 (라벨)
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 12, // font-size: 12px;
              fontWeight: FontWeight.w400, // font-weight: 400;
              color: const Color(0xFF6B7280), // color: #6B7280;
            ),
          ),
          if (tag != null) ...[
            // DIV-27 (태그가 있을 때 값)
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 18, // font-size: 18px;
                fontWeight: FontWeight.w700, // font-weight: 700;
                color: valueColor, // color: #1F2937;
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 2-2. '감정 분포' 프로그래스 바 (RTF: DIV-48)
  Widget _buildEmotionProgress(String label, double value, Color color, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), // (padding: 12px 0px 0px;)
      child: Row(
        children: [
          // DIV-49 (라벨)
          Container(
            width: 64, // width: 64px;
            child: Text(
              label, // 기쁨-54
              style: GoogleFonts.roboto(
                fontSize: 12, // font-size: 12px;
                fontWeight: FontWeight.w400, // font-weight: 400;
                color: const Color(0xFF4B5563), // color: #4B5563;
              ),
            ),
          ),
          // DIV-55 (프로그래스 바)
          Expanded(
            // DIV-56 (회색 배경)
            child: Container(
              height: 8, // height: 8px;
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB), // background: #E5E7EB;
                borderRadius: BorderRadius.circular(9999), // border-radius: 9999px;
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: Align(
                  alignment: Alignment.centerLeft,
                  // DIV-57 (채워진 바)
                  child: FractionallySizedBox(
                    widthFactor: value, // e.g., 55%
                    child: Container(
                      color: color, // background: #22C55E;
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12), // padding: 0px 12px;
          // SPAN-58 (퍼센트)
          Container(
            width: 32, // width: 32px;
            child: Text(
              percentage, // 55%-60
              style: GoogleFonts.roboto(
                fontSize: 12, // font-size: 12px;
                fontWeight: FontWeight.w400, // font-weight: 400;
                color: const Color(0xFF6B7280), // color: #6B7280;
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. 막대 그래프 카드 (RTF: DIV-111)
  Widget _buildBarChartCard() {
    return Card(
      elevation: 1.0,
      shadowColor: Colors.black.withOpacity(0.05),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주간 감정', // (H3-112)
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 32.0),
            // RTF (DIV-117) - 그래프 시각화 영역
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBar('월', 0.4, Color(0xFFEF4444)), // RTF (DIV-183)
                _buildBar('화', 0.6, Color(0xFFEAB308)), // RTF (DIV-233)
                _buildBar('수', 0.8, Color(0xFF22C55E)), // RTF (DIV-280)
                _buildBar('목', 0.5, Color(0xFFEF4444)), // (예시)
                _buildBar('금', 0.7, Color(0xFFEAB308)), // (예시)
                _buildBar('토', 0.9, Color(0xFF22C55E)), // (예시)
                _buildBar('일', 0.3, Color(0xFFEF4444)), // (예시)
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 3-1. 막대 그래프의 '막대' 헬퍼
  Widget _buildBar(String day, double heightFactor, Color color) {
    return Column(
      children: [
        Container(
          height: 150 * heightFactor, // (임의의 최대 높이 150)
          width: 12, // width: 12px; (DIV-183)
          decoration: BoxDecoration(
            color: color, // background: #EF4444; (DIV-183)
            borderRadius: BorderRadius.circular(9999), // border-radius: 9999px;
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day, // P-306 (예: "월")
          style: GoogleFonts.roboto(
            fontSize: 12, // font-size: 12px;
            color: const Color(0xFF6B7280), // color: #6B7280;
          ),
        )
      ],
    );
  }

  /// 4. '오늘의 힐링' 네비게이션 카드 (RTF: DIV-308 수정)
  Widget _buildHealingNavigationCard(BuildContext context) {
    // RTF (DIV-308)의 스타일을 가져오되, 내용물은 버튼으로 대체
    return Card(
      elevation: 1.0,
      shadowColor: Colors.black.withOpacity(0.05),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // H3-309: 오늘의 힐링 (제목)
            Text(
              '오늘의 힐링',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: const Color(0xFF1F2937),
              ),
            ),
            // '전체 보기' 버튼
            TextButton(
              onPressed: () {
                // [!!] 'healing_screen.dart' 파일로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HealingScreen()),
                );
              },
              child: Row(
                children: [
                  Text(
                    '전체 보기',
                    style: GoogleFonts.roboto(
                      color: const Color(0xFF2563EB), // kColorBtnPrimary
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14.0,
                    color: Color(0xFF2563EB),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}