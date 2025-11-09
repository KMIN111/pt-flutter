import 'package:flutter/material.dart';
// [!!] 1. profile_tab.dart에 정의된 EmergencyContact 클래스를 import
import 'profile_tab.dart';

// (색상 상수 정의 - MainScreen 등에서 공통 관리해도 됩니다)
const Color kPrimaryBlue = Color(0xFF2563EB);
const Color kEditTextBg = Color(0xFFF3F4F6);
const Color kTextPrimary = Color(0xFF111827);
const Color kTextSecondary = Color(0xFF6B7280);
const Color kTextHint = Color(0xFF9CA3AF);

// [!!] 2. StatelessWidget -> StatefulWidget로 변경
class AddContactBottomSheet extends StatefulWidget {
  // [!!] 3. '수정' 모드를 위해 연락처 정보를 받음 (null이면 '추가' 모드)
  final EmergencyContact? contact;
  // [!!] 4. 저장 버튼을 눌렀을 때 실행될 콜백 함수
  final Function(String name, String phone, String tag) onSave;

  const AddContactBottomSheet({
    Key? key,
    this.contact,
    required this.onSave, // [!!] onSave 콜백을 필수로 받음
  }) : super(key: key);

  @override
  _AddContactBottomSheetState createState() => _AddContactBottomSheetState();
}

class _AddContactBottomSheetState extends State<AddContactBottomSheet> {
  // [!!] 5. TextField를 제어하기 위한 컨트롤러
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _tagController;

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();

    // [!!] 6. '수정' 모드인지 '추가' 모드인지 확인
    _isEditMode = widget.contact != null;

    // [!!] 7. 컨트롤러 초기화. '수정' 모드이면 기존 데이터로 초기화
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
    _tagController = TextEditingController(text: widget.contact?.tag ?? '');
  }

  // [!!] 8. 컨트롤러는 항상 dispose
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // [!!] 9. 키보드가 올라올 때 가려지지 않도록 Padding 추가
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // [!!] 10. 모드에 따라 제목 변경
              _isEditMode ? '안심 연락망 수정' : '안심 연락망 추가',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kTextPrimary,
              ),
            ),
            SizedBox(height: 24),

            // [!!] 11. TextField에 컨트롤러 연결
            _buildTextField(
              controller: _nameController,
              label: '이름',
              hint: '홍길동',
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: '전화번호',
              hint: '010-1234-5678',
              keyboardType: TextInputType.phone, // 전화번호 키패드
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _tagController,
              label: '관계',
              hint: '가족, 친구, 상담사 등',
            ),
            SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildButton(
                    text: '취소',
                    isPrimary: false,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildButton(
                    text: '저장',
                    isPrimary: true,
                    onPressed: () {
                      // [!!] 12. 저장 버튼 클릭 시 onSave 콜백 실행
                      widget.onSave(
                        _nameController.text,
                        _phoneController.text,
                        _tagController.text,
                      );
                      // (팝업 닫기는 profile_tab에서 처리)
                    },
                  ),
                ),
              ],
            ),
            // 시스템 UI(하단 네비게이션 바 등)가 가리는 것을 방지
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  // _buildTextField 헬퍼 (컨트롤러 받도록 수정)
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kTextPrimary,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller, // 컨트롤러 연결
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: kTextHint),
            filled: true,
            fillColor: kEditTextBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  // _buildButton 헬퍼 (최신 스타일로 수정)
  Widget _buildButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? kPrimaryBlue : kEditTextBg,
        foregroundColor: isPrimary ? Colors.white : kTextSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}