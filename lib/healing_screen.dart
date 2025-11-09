import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// [!!] main_screen.dart와 일관성을 맞추기 위한 색상 정의
const Color kColorBg = Color(0xFFF9FAFB); // (DIV-2) background: #F9FAFB;
const Color kColorTextTitle = Color(0xFF1F2937);
const Color kColorTextSubtitle = Color(0xFF4B5563);
const Color kColorBtnPrimary = Color(0xFF2563EB);
const Color kColorCardBg = Colors.white;

class HealingScreen extends StatefulWidget {
  const HealingScreen({Key? key}) : super(key: key);

  @override
  _HealingScreenState createState() => _HealingScreenState();
}

class _HealingScreenState extends State<HealingScreen> {
  // RTF (DIV-5)의 토글 버튼 상태
  int _selectedToggleIndex = 0; // 0: 전체, 1: 명상, 2: 수면, 3: ASMR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg, // (DIV-2)
      appBar: AppBar(
        // (이미지의 '뒤로가기' 버튼)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '오늘의 힐링', // (이미지 상단 제목)
          style: GoogleFonts.roboto(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kColorBg, // 배경과 동일하게
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // RTF (DIV-3): padding: 80px 24px 96px;
        // (AppBar 높이 80px을 제외하고 상단 패딩 조절)
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            // [!] 1. 전체/명상/수면 토글 (RTF: DIV-5)
            _buildCategoryToggle(),
            const SizedBox(height: 24.0),

            // [!] 2. 힐링 카드 목록 (RTF: DIV-18, DIV-53 등)
            _buildHealingCard(
              context: context,
              imageUrl: 'https://placehold.co/600x300/E0E7FF/1F2937?text=Thumb1', // (IMG-20)
              title: '5분 명상으로 마음 정리하기', // (SPAN-46)
              description: '스트레스를 줄이고 마음의 평화를 찾는 간단한 명상법을 배워보세요.', // (SPAN-49)
            ),
            const SizedBox(height: 16.0),
            _buildHealingCard(
              context: context,
              imageUrl: 'https://placehold.co/600x300/FEF2F2/B91C1C?text=Thumb2', // (IMG-55)
              title: '숙면을 위한 호흡법', // (SPAN-81)
              description: '편안한 잠자리를 위한 간단한 호흡 가이드', // (SPAN-84)
            ),
            const SizedBox(height: 16.0),
            _buildHealingCard(
              context: context,
              imageUrl: 'https://placehold.co/600x300/F0FDF4/15803D?text=Thumb3', // (IMG-89)
              title: '자연의 소리 ASMR', // (SPAN-115)
              description: '빗소리, 새소리로 마음을 안정시키세요', // (SPAN-118)
            ),
          ],
        ),
      ),
    );
  }

  /// 1. 전체/명상/수면/ASMR 토글 위젯 (RTF: DIV-5)
  Widget _buildCategoryToggle() {
    // (RTF: DIV-5)
    return Container(
      height: 52.0, // (padding: 8px * 2 + height: 36px)
      padding: const EdgeInsets.all(8.0), // padding: 8px;
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // background: #F3F4F6;
        borderRadius: BorderRadius.circular(12.0), // border-radius: 12px;
      ),
      child: Row(
        children: [
          _buildToggleItem('전체', 0), // (BUTTON-6)
          _buildToggleItem('명상', 1), // (BUTTON-9)
          _buildToggleItem('수면', 2), // (BUTTON-12)
          _buildToggleItem('ASMR', 3), // (BUTTON-15)
        ],
      ),
    );
  }

  Widget _buildToggleItem(String text, int index) {
    final bool isSelected = (_selectedToggleIndex == index);

    // (RTF: BUTTON-6, 9, 12, 15)
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedToggleIndex = index;
            // TODO: 탭 선택 시 목록 필터링 로직 추가
          });
        },
        child: Container(
          height: 36.0, // height: 36px;
          decoration: BoxDecoration(
            // (BUTTON-6) background: #2563EB;
            color: isSelected ? kColorBtnPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0), // border-radius: 8px;
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500, // font-weight: 500;
                fontSize: 14.0, // font-size: 14px;
                // (SPAN-8) color: #FFFFFF;
                // (SPAN-11) color: #4B5563;
                color: isSelected ? Colors.white : kColorTextSubtitle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 2. 힐링 카드 위젯 (RTF: DIV-18)
  Widget _buildHealingCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String description,
  }) {
    // (RTF: DIV-18)
    return Card(
      elevation: 2.0, // (디자인 시안의 그림자)
      color: kColorCardBg, // background: #FFFFFF;
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // border-radius: 16px;
      ),
      child: InkWell(
        onTap: () {
          // TODO: 상세 페이지로 이동 또는 영상 재생
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // (RTF: DIV-19) - 이미지 영역
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                  child: Image.network(
                    imageUrl,
                    height: 200, // height: 200px;
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(child: Icon(Icons.video_call_outlined, color: Colors.grey[400], size: 50)),
                    ),
                  ),
                ),
                // (RTF: DIV-22) - 재생 버튼
                Container(
                  padding: const EdgeInsets.all(12), // (DIV-30) padding: 12px;
                  decoration: BoxDecoration(
                    color: Colors.black54, // (DIV-29)
                    shape: BoxShape.circle, // border-radius: 9999px;
                  ),
                  child: const Icon(
                    Icons.play_arrow, // (Icon-33)
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
            // (RTF: DIV-41) - 텍스트 영역
            Padding(
              padding: const EdgeInsets.all(20.0), // padding: 20px;
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // (SPAN-46)
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 16, // font-size: 16px;
                      fontWeight: FontWeight.bold, // font-weight: 700;
                      color: kColorTextTitle, // color: #1F2937;
                    ),
                  ),
                  const SizedBox(height: 8.0), // (DIV-48) padding: 8px 0px 0px;
                  // (SPAN-49)
                  Text(
                    description,
                    style: GoogleFonts.roboto(
                      fontSize: 14, // font-size: 14px;
                      fontWeight: FontWeight.w400, // font-weight: 400;
                      color: kColorTextSubtitle, // color: #4B5563;
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}