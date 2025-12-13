import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:untitled/main_screen.dart'; // Import main_screen.dart for kPrimaryGreen (REMOVED)

// --- Color Definitions (Same as before) ---
const Color kColorBgStart = Color(0xFFEFF6FF);
const Color kColorBgEnd = Color(0xFFFAF5FF);
const Color kColorTextTitle = Color(0xFF1F2937);
const Color kColorTextSubtitle = Color(0xFF4B5563);
const Color kColorTextLabel = Color(0xFF374151);
const Color kColorTextHint = Color(0xFF9CA3AF);
const Color kColorTextLink = Color(0xFF2563EB);
const Color kColorBtnPrimary = Color(0xFF2563EB);
const Color kColorEditTextBg = Color(0xFFF3F4F6);
const Color kColorError = Color(0xFFEF4444);
// ---
const Color kColorHelpCardBg = Color(0xFFF3F4FF);
const Color kColorIconBg = Color(0xFFE0E7FF);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false; // Add loading state
  String? _successMessage; // Add success message state

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _validateAndSend() async {
    setState(() {
      _emailError = null;
      _successMessage = null; // Clear previous success message
      _isLoading = true;
    });

    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _emailError = "유효한 이메일을 입력해주세요";
        _isLoading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _successMessage = "재설정 링크를 이메일로 보냈습니다.";
      });
      // Optionally navigate back after showing success
      // if (mounted) {
      //   Navigator.pop(context);
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() => _emailError = '등록되지 않은 이메일입니다.');
      } else if (e.code == 'invalid-email') {
        setState(() => _emailError = '유효하지 않은 이메일 형식입니다.');
      } else {
        setState(() => _emailError = '비밀번호 재설정 실패: ${e.message}');
      }
    } catch (e) {
      setState(() => _emailError = '알 수 없는 오류가 발생했습니다: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // ▼▼▼ MODIFIED PART (AppBar) ▼▼▼
      // AppBar는 '뒤로 가기' 버튼 때문에 유지하되,
      // 스타일을 LoginScreen과 통일합니다.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kColorTextTitle),
          onPressed: _isLoading ? null : () => Navigator.pop(context), // Disable back button when loading
        ),

        // 1. LoginScreen과 동일한 폰트 및 크기로 변경
        title: Text(
          'Personal Therapy',
          style: GoogleFonts.pacifico( // 👈 폰트 pacifico로 통일
            color: kColorTextTitle,
            fontSize: 20, // 👈 폰트 크기 20으로 통일
          ),
        ),

        // 2. LoginScreen과 동일하게 왼쪽 정렬
        centerTitle: false, // 👈 왼쪽 정렬로 통일
        titleSpacing: 0, // 👈 '뒤로' 버튼과 간격 조정
      ),
      // ▲▲▲ MODIFIED PART ▲▲▲

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kColorBgStart, kColorBgEnd],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: kToolbarHeight + 100.0), // AppBar 높이만큼 여백

                // (나머지 콘텐츠는 이미지 디자인과 동일)
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: kColorIconBg,
                  child: Icon(
                    Icons.lock_outline,
                    color: kColorBtnPrimary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  '비밀번호 찾기',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kColorTextTitle,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '등록된 이메일로 재설정 링크를 보내드릴게요',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: kColorTextSubtitle,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32.0),
                _buildFormCard(),
                const SizedBox(height: 24.0),
                _buildHelpCard(),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- (Widget Builders... no change) ---

  Widget _buildFormCard() {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: '이메일',
              hint: '등록된 이메일을 입력하세요',
              controller: _emailController,
              errorText: _emailError,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _validateAndSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorBtnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 24.0,
                width: 24.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
              )
                  : Text(
                '재설정 링크 보내기',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_successMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _successMessage!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Colors.green, // Use a green color for success messages
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: kColorTextLabel,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: _inputDecoration(
            hintText: hint,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText,
              style: GoogleFonts.roboto(
                color: kColorError,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.roboto(color: kColorTextHint, fontSize: 14),
      filled: true,
      fillColor: kColorEditTextBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildHelpCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: kColorHelpCardBg,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, color: kColorBtnPrimary, size: 20),
              const SizedBox(width: 8.0),
              Text(
                '도움이 필요하신가요?',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kColorTextTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildHelpBulletPoint('이메일이 도착하지 않으면 스팸함을 확인해주세요'),
          const SizedBox(height: 8.0),
          _buildHelpBulletPoint('링크는 24시간 동안 유효합니다'),
          const SizedBox(height: 8.0),
          _buildHelpBulletPoint('문제가 지속되면 고객센터로 문의해주세요'),
          const SizedBox(height: 16.0),
          TextButton(
            onPressed: () {
              // TODO: 고객센터 링크/페이지로 이동
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '고객센터 문의하기',
              style: GoogleFonts.roboto(
                color: kColorTextLabel,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: GoogleFonts.roboto(
            color: kColorTextSubtitle,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              color: kColorTextSubtitle,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}