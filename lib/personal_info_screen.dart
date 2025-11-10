import 'package:flutter/material.dart';

// profile_tab.dart 또는 main.dart에 정의된 색상 상수들을 가져옵니다.
// (일관성을 위해 profile_tab.dart의 상수들을 그대로 사용합니다)
const Color kPageBackground = Color(0xFFF9FAFB);
const Color kCardBackground = Color(0xFFFFFFFF);
const Color kPrimaryBlue = Color(0xFF2563EB);
const Color kTextPrimary = Color(0xFF111827);
const Color kTextSecondary = Color(0xFF6B7280);
const Color kTextHint = Color(0xFF9CA3AF);
const Color kEditTextBg = Color(0xFFF3F4F6);
const Color kColorBtnPrimary = Color(0xFF2563EB);

/// 개인정보 수정 페이지 (개인정보 설정.rtf 기반)
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {

  // (예시) 입력 필드를 위한 컨트롤러
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  // [!!] 1. 비밀번호 변경 로직을 위한 상태 변수 추가
  bool _isChangingPassword = false;

  // [!!] 2. 새 비밀번호 필드를 위한 컨트롤러 추가
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;


  @override
  void initState() {
    super.initState();
    // RTF에 있는 초기값으로 설정
    _nameController = TextEditingController(text: '홍길동');
    _phoneController = TextEditingController(text: '010-1234-5678');

    // [!!] 3. 비밀번호 컨트롤러 초기화
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();

    // [!!] 4. 비밀번호 컨트롤러 dispose
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackground,
      // RTF 'DIV-3' (padding: 80px 24px 96px)를 위해 앱바를 투명하게 띄움
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // 'DIV-147' (AppBar)
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kTextPrimary,
            size: 20, // 'Icon-144'
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '개인정보 수정', // 'SPAN-151'
          style: TextStyle(
            color: kTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600, // font-weight: 600
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // 'height: 1735px'를 반영, 'padding: 80px 24px 96px' 적용
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 96),
        child: Column(
          children: [
            // 'DIV-4' (프로필 이미지 카드)
            _buildProfileImageEditor(),
            SizedBox(height: 24),

            // 'DIV-20' (이름)
            _buildInfoRowWithButton(
              label: '이름', // 'H3-22'
              controller: _nameController, // 'INPUT-25'
              buttonText: '변경', // 'BUTTON-31'
              onPressed: () {
                // TODO: 이름 변경 로직
              },
            ),
            SizedBox(height: 16),

            // 'DIV-35' (이메일 - readonly)
            _buildInfoRowReadOnly(
              label: '이메일', // 'H3-37'
              value: 'example@email.com', // 'INPUT-40'
            ),
            SizedBox(height: 16),

            // 'DIV-51' (전화번호)
            _buildInfoRowWithButton(
              label: '전화번호', // 'H3-53'
              controller: _phoneController, // 'INPUT-56'
              buttonText: '변경', // 'BUTTON-62'
              keyboardType: TextInputType.phone,
              onPressed: () {
                // TODO: 전화번호 변경 로직
              },
            ),
            SizedBox(height: 16),

            // 'DIV-66' (생년월일 - readonly)
            _buildInfoRowReadOnly(
              label: '생년월일', // 'H3-68'
              value: '1990년 01월 01일', // 'INPUT-71'
            ),
            SizedBox(height: 16),

            // [!!] 5. 'DIV-97' (비밀번호) -> _buildPasswordSection으로 변경
            _buildPasswordSection(),

            SizedBox(height: 24),

            // 'DIV-115' (소셜 계정)
            _buildSocialConnectCard(),
          ],
        ),
      ),
    );
  }

  // 'DIV-4' (프로필 이미지 위젯)
  Widget _buildProfileImageEditor() {
    return Column(
      children: [
        // 'DIV-6' (128px 원)
        CircleAvatar(
          radius: 64, // 128px / 2
          backgroundColor: Color(0xFFDBEAFE),
          child: Icon(Icons.person, size: 80, color: kPrimaryBlue),
          // TODO: 실제 이미지 적용
        ),
        SizedBox(height: 16),
        Text(
          '이미지 변경', // 'P-16'
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kPrimaryBlue,
          ),
        ),
      ],
    );
  }

  // 'DIV-20', 'DIV-51' (변경 버튼이 있는 입력 필드)
  Widget _buildInfoRowWithButton({
    required String label,
    required TextEditingController controller,
    required String buttonText,
    required VoidCallback onPressed,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return _buildSettingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), // 'H3'
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField( // 'INPUT'
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: kEditTextBg,
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton( // 'BUTTON'
                onPressed: onPressed,
                child: Text(buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorBtnPrimary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 'DIV-35', 'DIV-66' (읽기 전용 필드)
  Widget _buildInfoRowReadOnly({required String label, required String value}) {
    return _buildSettingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), // 'H3'
          SizedBox(height: 12),
          Container( // 'INPUT' (Disabled)
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kEditTextBg, // background: #F3F4F6
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: kTextSecondary), // 읽기 전용 텍스트
            ),
          ),
        ],
      ),
    );
  }

  // [!!] 6. 비밀번호 섹션 위젯 (수정됨)
  Widget _buildPasswordSection() {
    return _buildSettingCard(
      // [!!] 7. 상태에 따라 다른 위젯을 보여줌
      child: _isChangingPassword
          ? _buildPasswordEditView() // 비밀번호 변경 뷰
          : _buildPasswordReadOnlyView(), // 기본 뷰
    );
  }

  // [!!] 8. 기본 비밀번호 뷰 (기존 _buildPasswordRow)
  Widget _buildPasswordReadOnlyView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('비밀번호', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), // 'H3-99'
            SizedBox(height: 4),
            Text('••••••••', style: TextStyle(fontSize: 16, color: kTextSecondary)), // 'P-105'
          ],
        ),
        OutlinedButton( // 'BUTTON-108'
          onPressed: () {
            // [!!] 9. '변경' 버튼 클릭 시 상태 변경
            setState(() {
              _isChangingPassword = true;
            });
          },
          child: Text('변경'),
          style: OutlinedButton.styleFrom(
            foregroundColor: kPrimaryBlue,
            side: BorderSide(color: kEditTextBg),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  // [!!] 10. 비밀번호 변경 뷰 (새로 추가)
  Widget _buildPasswordEditView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('비밀번호 변경', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 16),
        _buildPasswordTextField(
          controller: _currentPasswordController,
          hintText: '현재 비밀번호',
        ),
        SizedBox(height: 12),
        _buildPasswordTextField(
          controller: _newPasswordController,
          hintText: '새 비밀번호',
        ),
        SizedBox(height: 12),
        _buildPasswordTextField(
          controller: _confirmPasswordController,
          hintText: '새 비밀번호 확인',
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // [!!] 11. '취소' 버튼 클릭 시 상태 변경
                  setState(() {
                    _isChangingPassword = false;
                  });
                  // 컨트롤러 초기화 (선택 사항)
                  _currentPasswordController.clear();
                  _newPasswordController.clear();
                  _confirmPasswordController.clear();
                },
                child: Text('취소'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kTextSecondary,
                  side: BorderSide(color: kEditTextBg),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // [!!] 12. '저장' 버튼 로직
                  // TODO: 비밀번호 유효성 검사
                  // (e.g., _newPasswordController.text == _confirmPasswordController.text)
                  // TODO: (실제 앱) Firebase Auth 또는 API를 호출하여 비밀번호 변경

                  // 로직 완료 후, 상태를 다시 false로 변경
                  setState(() {
                    _isChangingPassword = false;
                  });
                  _currentPasswordController.clear();
                  _newPasswordController.clear();
                  _confirmPasswordController.clear();
                },
                child: Text('저장'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorBtnPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // [!!] 13. 비밀번호 입력 필드 헬퍼 (새로 추가)
  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      obscureText: true, // 비밀번호 숨기기
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16, color: kTextHint),
        filled: true,
        fillColor: kEditTextBg,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // 'DIV-115' (소셜 계정 카드)
  Widget _buildSocialConnectCard() {
    return _buildSettingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('연결된 소셜 계정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), // 'H3-117'
          SizedBox(height: 16),
          // 'DIV-120' (Google)
          _buildSocialRow(
            icon: Icons.ac_unit, // TODO: Google 아이콘으로 교체
            iconColor: Colors.red,
            text: 'Google 계정',
            isConnected: true,
          ),
          Divider(height: 24),
          // 'DIV-128' (Kakao)
          _buildSocialRow(
            icon: Icons.chat_bubble, // TODO: Kakao 아이콘으로 교체
            iconColor: Colors.yellow,
            text: '카카오 계정',
            isConnected: false,
          ),
        ],
      ),
    );
  }

  // 소셜 계정 연결 Row 헬퍼
  Widget _buildSocialRow({
    required IconData icon,
    required Color iconColor,
    required String text,
    required bool isConnected,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: 16, color: kTextPrimary)),
        ),
        Text(
          isConnected ? '연결됨' : '연결하기', // 'P-126', 'P-134'
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isConnected ? kTextSecondary : kPrimaryBlue,
          ),
        ),
      ],
    );
  }

  // 공통 카드 컨테이너
  Widget _buildSettingCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}