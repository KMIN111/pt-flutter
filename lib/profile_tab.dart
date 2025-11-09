import 'package:flutter/material.dart';

import 'add_contact_sheet.dart'; // [!!] 팝업창 위젯 import

// RTF 파일에서 정의된 색상 상수
const Color kPageBackground = Color(0xFFF9FAFB);
const Color kCardBackground = Color(0xFFFFFFFF);
const Color kPrimaryBlue = Color(0xFF2563EB);
const Color kPrimaryGreen = Color(0xFF16A34A);
const Color kPrimaryPurple = Color(0xFF9333EA);
const Color kPrimaryRed = Color(0xFFDC2626);
const Color kDarkRed = Color(0xFFB91C1C);
const Color kDisabledGrey = Color(0xFFE5E7EB);
const Color kTextPrimary = Color(0xFF111827);
const Color kTextSecondary = Color(0xFF6B7280);


// [!!] 1. 연락처 데이터를 관리할 클래스(모델)를 정의합니다.
class EmergencyContact {
  String name;
  String phone;
  String tag;
  // (아이콘/색상 정보도 여기에 추가할 수 있습니다)
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.tag,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}


// [!!] 2. StatelessWidget -> StatefulWidget로 변경
class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

// [!!] 3. State 클래스 생성
class _ProfileTabState extends State<ProfileTab> {

  // [!!] 4. 연락처 목록을 '상태'로 관리합니다.
  final List<EmergencyContact> _contacts = [
    EmergencyContact(
      name: '김엄마',
      phone: '010-1234-5678',
      tag: '가족',
      icon: Icons.family_restroom,
      bgColor: Color(0xFFFEE2E2),
      iconColor: Color(0xFFDC2626),
    ),
    EmergencyContact(
      name: '이친구',
      phone: '010-9876-5432',
      tag: '친구',
      icon: Icons.people,
      bgColor: Color(0xFFD1FAE5),
      iconColor: Color(0xFF16A34A),
    ),
    EmergencyContact(
      name: '박상담',
      phone: '010-1111-2222',
      tag: '상담사',
      icon: Icons.support_agent,
      bgColor: Color(0xFFFEF3C7),
      iconColor: Color(0xFFD97706),
    ),
  ];

  // [!!] 5. build 메서드 및 모든 헬퍼 메서드를 State로 이동
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
      child: Column(
        children: [
          _buildUserStatsCard(),
          SizedBox(height: 24),
          _buildEmergencyContactsCard(context), // context 전달
          SizedBox(height: 24),
          _NotificationSettingsCard(),
          SizedBox(height: 24),
          _buildAccountCard(),
          SizedBox(height: 24),
          _buildDeleteAccountCard(),
        ],
      ),
    );
  }

  // --- 1. 사용자 스탯 카드 ('DIV-4') ---
  Widget _buildUserStatsCard() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 'DIV-12' (아이콘)
              CircleAvatar(
                radius: 32, // (64px / 2)
                backgroundColor: Color(0xFFDBEAFE),
                child: Icon(Icons.person, size: 30, color: kPrimaryBlue),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '사용자님', // 'H2-10'
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kTextPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Personal Therapy와 함께한 지 30일', // 'P-13'
                    style: TextStyle(fontSize: 14, color: kTextSecondary),
                  ),
                ],
              ),
            ],
          ),
          Divider(height: 32, color: Colors.grey[200]),
          // 'DIV-16' (통계 영역)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('대화 횟수', '127', kPrimaryBlue),
              _buildStatItem('평균 건강점수', '85', kPrimaryGreen),
              _buildStatItem('힐링 콘텐츠', '42', kPrimaryPurple),
            ],
          ),
        ],
      ),
    );
  }

  // --- 2. 안심 연락망 카드 ('DIV-38') ---
  Widget _buildEmergencyContactsCard(BuildContext context) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '안심 연락망', // 'H3-40'
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              // 'BUTTON-43' (추가 버튼)
              InkWell(
                onTap: () {
                  // [!!] 6. '추가' 모드로 팝업 호출 (contact: null)
                  _showAddContactModal(context);
                },
                child: CircleAvatar(
                  radius: 16, // 32px
                  backgroundColor: Color(0xFFDBEAFE), // background: #DBEAFE
                  child: Icon(
                    Icons.add,
                    color: kPrimaryBlue, // icon color: #2563EB
                    size: 20,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Text(
            '위기 상황 감지 시 알림을 받을 연락처를 설정하세요. (최대 3개)', // 'P-46'
            style: TextStyle(fontSize: 14, color: kTextSecondary),
          ),
          SizedBox(height: 20),

          // [!!] 7. 동적으로 연락처 목록 생성
          Column(
            children: _contacts.map((contact) {
              return _buildContactItem(
                contact: contact, // 연락처 객체 전달
                onEdit: () {
                  // [!!] 8. '수정' 모드로 팝업 호출 (contact 객체 전달)
                  _showAddContactModal(context, contact: contact);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // [!!] 9. 팝업 띄우기 함수 수정 (contact 파라미터 추가)
  void _showAddContactModal(BuildContext context, {EmergencyContact? contact}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bContext) {
        // [!!] 10. 팝업 시트에 contact 정보 전달
        return AddContactBottomSheet(
          contact: contact,
          onSave: (String name, String phone, String tag) {
            // [!!] 11. 저장 콜백 로직
            setState(() {
              if (contact == null) {
                // '추가' 모드 (새 연락처 추가 - 아이콘/색상은 임시)
                _contacts.add(
                  EmergencyContact(
                    name: name,
                    phone: phone,
                    tag: tag,
                    icon: Icons.person,
                    bgColor: Color(0xFFE0E7FF),
                    iconColor: Color(0xFF4338CA),
                  ),
                );
              } else {
                // '수정' 모드 (기존 연락처 업데이트)
                contact.name = name;
                contact.phone = phone;
                contact.tag = tag;
              }
            });
            Navigator.pop(context); // 팝업 닫기
          },
        );
      },
    );
  }

  // --- 3. 알림 설정 카드 ('DIV-80') ---
  Widget _NotificationSettingsCard() {
    return StatefulBuilder(
      builder: (context, setState) {
        Map<String, bool> Toggles = {
          '감정 기록 알림': true,
          '위기 감지 알림': true,
          '힐링 콘텐츠 알림': false,
        };

        return _buildCardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '알림 설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              _buildSwitchItem(
                '감정 기록 알림',
                Toggles['감정 기록 알림']!,
                    (value) => setState(() => Toggles['감정 기록 알림'] = value),
              ),
              _buildSwitchItem(
                '위기 감지 알림',
                Toggles['위기 감지 알림']!,
                    (value) => setState(() => Toggles['위기 감지 알림'] = value),
              ),
              _buildSwitchItem(
                '힐링 콘텐츠 알림',
                Toggles['힐링 콘텐츠 알림']!,
                    (value) => setState(() => Toggles['힐링 콘텐츠 알림'] = value),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- 4. 계정 설정 카드 ('DIV-127') ---
  Widget _buildAccountCard() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '계정',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          _buildMenuItem(
            icon: Icons.lock_person,
            iconColor: kPrimaryBlue,
            text: '개인정보 설정',
          ),
          _buildMenuItem(
            icon: Icons.key,
            iconColor: Color(0xFFD97706),
            text: '비밀번호 변경',
          ),
          _buildMenuItem(
            icon: Icons.public,
            iconColor: kPrimaryPurple,
            text: '연결된 소셜 계정',
          ),
        ],
      ),
    );
  }

  // --- 5. 회원 탈퇴 카드 ('DIV-166') ---
  Widget _buildDeleteAccountCard() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: kPrimaryRed, size: 24),
              SizedBox(width: 8),
              Text(
                '회원 탈퇴',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '계정을 삭제하면... 모든 데이터가 영구적으로 삭제...',
            style: TextStyle(fontSize: 14, color: kDarkRed),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryRed, // [!!] primary -> backgroundColor
              foregroundColor: Colors.white, // [!!] onPrimary -> foregroundColor
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {},
            child: Text('생명의전화 1393'),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF3F4F6), // [!!] primary -> backgroundColor
              foregroundColor: kTextSecondary, // [!!] onPrimary -> foregroundColor
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            onPressed: () {},
            child: Text('회원 탈퇴'),
          ),
        ],
      ),
    );
  }

  // --- 헬퍼 위젯들 ---

  // 공통 카드 컨테이너
  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  // 스탯 아이템
  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: kTextSecondary),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // [!!] 12. 연락처 아이템 헬퍼 수정
  Widget _buildContactItem({
    required EmergencyContact contact, // 객체를 통째로 받음
    required VoidCallback onEdit,      // 수정 콜백 함수
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: contact.bgColor,
            child: Icon(contact.icon, color: contact.iconColor, size: 20),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact.name, style: TextStyle(fontWeight: FontWeight.w600)),
              Text('${contact.phone} ${contact.tag}',
                  style: TextStyle(color: kTextSecondary)),
            ],
          ),
          Spacer(),
          // [!!] 13. Icon -> IconButton으로 변경하고 onEdit 연결
          IconButton(
            icon: Icon(Icons.edit, color: kTextSecondary, size: 20),
            onPressed: onEdit, // 수정 콜백 실행
          ),
        ],
      ),
    );
  }

  // 스위치 아이템
  Widget _buildSwitchItem(
      String title,
      bool value,
      Function(bool) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: kPrimaryBlue,
            inactiveTrackColor: kDisabledGrey,
          ),
        ],
      ),
    );
  }

  // 계정 메뉴 아이템
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 16)),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: kTextSecondary),
        ],
      ),
    );
  }
} // [!!] _ProfileTabState 끝