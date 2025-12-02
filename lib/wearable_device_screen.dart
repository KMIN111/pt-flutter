import 'package:flutter/material.dart';
import 'package:health/health.dart' as health;
import 'package:untitled/main_screen.dart'; // Import main_screen.dart to use its color constants

// [!!] 1. 새 RTF 파일에서 추가된 색상
const Color kConnectedGreen = Color(0xFF21C45D); // "연결됨"
const Color kStressHigh = Color(0xFFF59E0B); // 스트레스 '높음' (주황)
const Color kStressNormal = Color(0xFF3B81F5); // 스트레스 '보통' (파랑)
const Color kStressLow = Color(0xFF4ADE80); // 스트레스 '낮음' (밝은 녹색)
const Color kPrimaryGreen = Color(0xFF16A34A);


/// 웨어러블 기기 연동 페이지 (웨어러블 기기_수정.rtf 기반)
class WearableDeviceScreen extends StatefulWidget {
  const WearableDeviceScreen({Key? key}) : super(key: key);

  @override
  _WearableDeviceScreenState createState() => _WearableDeviceScreenState();
}

class _WearableDeviceScreenState extends State<WearableDeviceScreen> {
  health.Health healthFactory = health.Health();
  List<health.HealthDataPoint> _healthDataList = [];
  int _steps = 0;
  double _activeCalories = 0;
  int _moveMinutes = 0;

  // define the types to get
  static final types = [
    health.HealthDataType.STEPS,
    health.HealthDataType.ACTIVE_ENERGY_BURNED,
    health.HealthDataType.HEART_RATE,
    health.HealthDataType.HEART_RATE_VARIABILITY_SDNN,
  ];

  // [!!] 2. 헬스 커넥트 연동 상태 (예시 데이터)
  // (Health Connect 연동 시 이 값들이 실시간으로 업데이트되어야 함)
  bool _isConnected = true;
  bool _isConnecting = false;

  // (예시) 실시간 모니터링 데이터
  int _currentHR = 72;
  int _currentHRV = 35;
  int _currentStress = 45;
  String _currentStressLabel = '보통';
  String _userState = '보통'; // Add user state
  Color _userStateColor = kStressNormal; // Add user state color

  // (예시) 연결된 기기 목록r
  List<Map<String, dynamic>> _connectedDevices = [
    {'name': 'Apple Watch Series 9', 'battery': 78, 'status': '방금 전'},
  ];

  // (예시) 사용 가능한 기기 목록
  List<Map<String, String>> _availableDevices = [
    {'name': 'Galaxy Watch 6', 'brand': 'Samsung'},
    {'name': 'Fitbit Charge 6', 'brand': 'Fitbit'},
    {'name': 'Oura Ring Gen3', 'brand': 'Oura'},
  ];

  // (예시) 스트레스 로그 데이터
  List<Map<String, dynamic>> _stressLog = [
    {'time': '06:00', 'hr': 65, 'hrv': 45, 'stress': 20},
    {'time': '08:00', 'hr': 70, 'hrv': 40, 'stress': 30},
    {'time': '10:00', 'hr': 78, 'hrv': 35, 'stress': 45},
    {'time': '12:00', 'hr': 82, 'hrv': 32, 'stress': 55},
    {'time': '14:00', 'hr': 88, 'hrv': 28, 'stress': 70},
    {'time': '16:00', 'hr': 85, 'hrv': 30, 'stress': 60},
    {'time': '18:00', 'hr': 75, 'hrv': 38, 'stress': 40},
    {'time': '20:00', 'hr': 68, 'hrv': 42, 'stress': 25},
  ];

  @override
  void initState() {
    super.initState();
    fetchActivityData();
  }

  // Analyze user state based on HR and HRV
  void _analyzeUserState(int hr, int hrv) {
    // This is a simple rule-based model.
    // A more sophisticated model could be used for more accuracy.
    if (hrv < 30 && hr > 80) {
      _userState = '스트레스';
      _userStateColor = kStressHigh;
    } else if (hrv > 60 && hr < 65) {
      _userState = '편안함';
      _userStateColor = kStressLow;
    } else {
      _userState = '보통';
      _userStateColor = kStressNormal;
    }
  }

  Future<void> fetchActivityData() async {
    // request authorization
    bool requested = await healthFactory.requestAuthorization(types);

    if (requested) {
      final now = DateTime.now();
      final yesterday = now.subtract(Duration(days: 1));
      try {
        // fetch health data
        List<health.HealthDataPoint> healthData =
        await healthFactory.getHealthDataFromTypes(types: types, startTime: yesterday, endTime: now);

        // save all the new data points
        _healthDataList.addAll(healthData);

        // filter out duplicates
        _healthDataList = _healthDataList.toSet().toList();

        // update the state with the new data
        setState(() {
          _steps = (_healthDataList.firstWhere(
                  (p) => p.type == health.HealthDataType.STEPS,
              orElse: () => health.HealthDataPoint(
                uuid: '',
                  value: health.NumericHealthValue(numericValue: 0),
                  type: health.HealthDataType.STEPS,
                  unit: health.HealthDataUnit.COUNT,
                  dateFrom: yesterday,
                  dateTo: now,
                  sourcePlatform: health.HealthPlatformType.googleHealthConnect,
                  sourceDeviceId: '',
                  sourceId: '',
                  sourceName: ''))
              .value as health.NumericHealthValue)
              .numericValue
              .round();
          _activeCalories = (_healthDataList.firstWhere(
                  (p) => p.type == health.HealthDataType.ACTIVE_ENERGY_BURNED,
              orElse: () => health.HealthDataPoint(
                  uuid: '',
                  value: health.NumericHealthValue(numericValue: 0),
                  type: health.HealthDataType.ACTIVE_ENERGY_BURNED,
                  unit: health.HealthDataUnit.KILOCALORIE,
                  dateFrom: yesterday,
                  dateTo: now,
                  sourcePlatform: health.HealthPlatformType.googleHealthConnect,
                  sourceDeviceId: '',
                  sourceId: '',
                  sourceName: ''))
              .value as health.NumericHealthValue)
              .numericValue.toDouble();
          _currentHR = (_healthDataList.firstWhere(
                  (p) => p.type == health.HealthDataType.HEART_RATE,
              orElse: () => health.HealthDataPoint(
                  uuid: '',
                  value: health.NumericHealthValue(numericValue: 72),
                  type: health.HealthDataType.HEART_RATE,
                  unit: health.HealthDataUnit.BEATS_PER_MINUTE,
                  dateFrom: yesterday,
                  dateTo: now,
                  sourcePlatform: health.HealthPlatformType.googleHealthConnect,
                  sourceDeviceId: '',
                  sourceId: '',
                  sourceName: ''))
              .value as health.NumericHealthValue)
              .numericValue
              .round();
          _currentHRV = (_healthDataList.firstWhere(
                  (p) => p.type == health.HealthDataType.HEART_RATE_VARIABILITY_SDNN,
              orElse: () => health.HealthDataPoint(
                  uuid: '',
                  value: health.NumericHealthValue(numericValue: 35),
                  type: health.HealthDataType.HEART_RATE_VARIABILITY_SDNN,
                  unit: health.HealthDataUnit.MILLISECOND,
                  dateFrom: yesterday,
                  dateTo: now,
                  sourcePlatform: health.HealthPlatformType.googleHealthConnect,
                  sourceDeviceId: '',
                  sourceId: '',
                  sourceName: ''))
              .value as health.NumericHealthValue)
              .numericValue
              .round();

          // Analyze user state
          _analyzeUserState(_currentHR, _currentHRV);
        });
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }
    } else {
      print("Authorization not granted");
    }
  }


  // [!!] 3. Health Connect 연동을 위한 헬퍼 함수 (확장 지점)
  Future<void> _connectToHealthConnect(String deviceName) async {
    if (_isConnecting) return;

    setState(() {
      _isConnecting = true;
    });

    // --- Health Connect 연동 로직 (TODO) ---
    // (기존 로직은 동일)
    try {
      // HealthFactory 초기화
      // HealthFactory health = HealthFactory();

      // ... 권한 요청 (types 정의) ...
      // bool requested = await health.requestAuthorization(types);
      bool requested = await Future.delayed(Duration(seconds: 2), () => true); // (임시) 2초 로딩

      if (requested) {
        // [!!] 4. 연동 성공 시 UI 업데이트 (예시)
        setState(() {
          _isConnected = true;
          _availableDevices.removeWhere((device) => device['name'] == deviceName);
          _connectedDevices.add({
            'name': deviceName,
            'battery': 100, // (임시)
            'status': '방금 전'
          });
        });
      } else {
        // 권한 거부 시
      }
    } catch (e) {
      // 에러 처리
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
    // --- 연동 로직 끝 ---
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBgStart,
      // [!!] 5. 새 RTF 디자인은 extendBodyBehindAppBar: false가 더 적합
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: kColorBgStart,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kColorTextTitle,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '웨어러블 연동', // [!!] 6. RTF에 맞게 타이틀 변경
          style: TextStyle(
            color: kColorTextTitle,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // [!!] 7. RTF에 맞게 padding 변경 (상단 80px 제거)
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // [!!] 8. 새로운 UI 위젯들 호출
            _buildRealtimeMonitoringCard(),
            SizedBox(height: 24),
            _buildActivityCard(),
            SizedBox(height: 24),
            _buildConnectedDevicesCard(),
            SizedBox(height: 24),
            _buildAvailableDevicesCard(),
            SizedBox(height: 24),
            _buildStressLogCard(),
            SizedBox(height: 24),
            _buildHealthConnectInfoCard(),
          ],
        ),
      ),
    );
  }

  // --- [!!] 9. 새 RTF 기반 헬퍼 위젯들 ---

  /// '실시간 모니터링' 카드
  Widget _buildRealtimeMonitoringCard() {
    return _buildSettingCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                    '실시간 모니터링',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kColorTextTitle
                    )
                ),
                Spacer(),
                Icon(Icons.circle, color: kConnectedGreen, size: 12),
                SizedBox(width: 6),
                Text(
                  _isConnected ? '연결됨' : '연결 끊김',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kConnectedGreen
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.favorite, _currentHR, 'BPM', '심박수', kColorError),
                _buildStatItem(Icons.waves, _currentHRV, 'ms', '심박변이도', kColorBtnPrimary),
                _buildStatItem(Icons.sentiment_very_satisfied, 0, _userState, '신체 상태', _userStateColor),
              ],
            ),
          ],
        )
    );
  }

  /// 실시간 모니터링용 스탯 아이템 (심박수, HRV 등)
  Widget _buildStatItem(IconData icon, int value, String unitOrLabel, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        SizedBox(height: 8),
        if (label != '신체 상태') // Show value only if it's not '신체 상태'
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$value',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kColorTextTitle
                ),
              ),
              SizedBox(width: 4),
              Text(
                unitOrLabel,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: kColorTextSubtitle
                ),
              ),
            ],
          )
        else
          Text( // Just show the state for '신체 상태'
            unitOrLabel,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color
            ),
          ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: kColorTextSubtitle),
        ),
      ],
    );
  }

  /// '연결된 기기' 카드
  Widget _buildConnectedDevicesCard() {
    return _buildSettingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '연결된 기기',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kColorTextTitle
                  )
              ),
              OutlinedButton.icon(
                onPressed: () { /* TODO: 기기 검색 로직 */ },
                icon: Icon(Icons.search, size: 16),
                label: Text('기기 검색'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kColorTextTitle,
                  side: BorderSide(color: kColorEditTextBg),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // 연결된 기기 목록
          _connectedDevices.isEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text('현재 연동된 기기가 없습니다.', style: TextStyle(color: kColorTextSubtitle)),
            ),
          )
              : Column(
            children: _connectedDevices.map((device) =>
                _buildConnectedDeviceRow(
                  name: device['name'],
                  battery: device['battery'],
                  status: device['status'],
                )
            ).toList(),
          ),
        ],
      ),
    );
  }

  /// 연결된 기기 Row 헬퍼
  Widget _buildConnectedDeviceRow({required String name, required int battery, required String status}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(Icons.watch, size: 32, color: kColorBtnPrimary), // (임시 아이콘)
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: kColorTextTitle)
                ),
                SizedBox(height: 4),
                Text(
                    '$battery%・$status',
                    style: TextStyle(fontSize: 14, color: kColorTextSubtitle)
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: kColorTextSubtitle),
        ],
      ),
    );
  }

  /// '사용 가능한 기기' 카드
  Widget _buildAvailableDevicesCard() {
    return _buildSettingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '사용 가능한 기기',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kColorTextTitle
              )
          ),
          SizedBox(height: 16),
          // 사용 가능한 기기 목록
          Column(
            children: _availableDevices.map((device) =>
                _buildAvailableDeviceRow(
                  name: device['name']!,
                  brand: device['brand']!,
                  onConnect: () => _connectToHealthConnect(device['name']!),
                )
            ).toList(),
          ),
        ],
      ),
    );
  }

  /// 사용 가능한 기기 Row 헬퍼
  Widget _buildAvailableDeviceRow({required String name, required String brand, required VoidCallback onConnect}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.watch_outlined, size: 32, color: kColorTextSubtitle), // (임시 아이콘)
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: kColorTextTitle)
                ),
                SizedBox(height: 4),
                Text(
                    brand,
                    style: TextStyle(fontSize: 14, color: kColorTextSubtitle)
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onConnect,
            child: Text('연결'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorEditTextBg,
              foregroundColor: kColorBtnPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  /// '오늘의 스트레스 변화' 카드
  Widget _buildStressLogCard() {
    return _buildSettingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '오늘의 스트레스 변화',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kColorTextTitle
              )
          ),
          SizedBox(height: 16),
          // 스트레스 로그 목록
          Column(
            children: _stressLog.map((log) =>
                _buildStressLogRow(
                  time: log['time'],
                  hr: log['hr'],
                  hrv: log['hrv'],
                  stress: log['stress'],
                )
            ).toList(),
          ),
          Divider(height: 32),
          // 스트레스 요약
          _buildStressSummaryRow(
            avgStress: 43, // (예시)
            maxStress: 70, // (예시)
            avgHr: 76,     // (예시)
          ),
        ],
      ),
    );
  }

  /// 스트레스 로그 Row 헬퍼
  Widget _buildStressLogRow({required String time, required int hr, required int hrv, required int stress}) {
    Color stressColor;
    if (stress >= 65) stressColor = kColorError;
    else if (stress >= 40) stressColor = kStressHigh;
    else if (stress >= 25) stressColor = kStressNormal;
    else stressColor = kStressLow;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
              time,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kColorTextTitle)
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
                '심박수 $hr・HRV $hrv',
                style: TextStyle(fontSize: 14, color: kColorTextSubtitle)
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: stressColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
                '$stress',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: stressColor)
            ),
          ),
        ],
      ),
    );
  }

  /// 스트레스 요약 Row 헬퍼
  Widget _buildStressSummaryRow({required int avgStress, required int maxStress, required int avgHr}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text('평균 스트레스', style: TextStyle(fontSize: 12, color: kColorTextSubtitle)),
            SizedBox(height: 4),
            Text(
              '$avgStress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kColorTextTitle),
            ),
          ],
        ),
        Column(
          children: [
            Text('최고 스트레스', style: TextStyle(fontSize: 12, color: kColorTextSubtitle)),
            SizedBox(height: 4),
            Text(
              '$maxStress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kColorTextTitle),
            ),
          ],
        ),
        Column(
          children: [
            Text('평균 심박수', style: TextStyle(fontSize: 12, color: kColorTextSubtitle)),
            SizedBox(height: 4),
            Text(
              '$avgHr',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kColorTextTitle),
            ),
          ],
        ),
      ],
    );
  }

  /// 'Health Connect 연동 정보' 카드
  Widget _buildHealthConnectInfoCard() {
    return _buildSettingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Health Connect 연동 정보',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kColorTextTitle
              )
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.monitor_heart,
            title: '실시간 생체 데이터',
            subtitle: '심박수, 심박변이도를 통해 스트레스 지수를 자동 계산합니다.',
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.hourglass_top,
            title: '시간별 추적',
            subtitle: '2시간 간격으로 자동 측정되어 하루 종일 모니터링됩니다.',
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.shield_outlined,
            title: '개인정보 보호',
            subtitle: '모든 건강 데이터는 기기에서 안전하게 처리됩니다.',
          ),
        ],
      ),
    );
  }

  /// 연동 정보 Row 헬퍼
  Widget _buildInfoRow({required IconData icon, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kColorBtnPrimary, size: 24),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: kColorTextTitle)
              ),
              SizedBox(height: 4),
              Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: kColorTextSubtitle)
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 공통 카드 컨테이너
  Widget _buildSettingCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kColorCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  /// '오늘의 활동' 카드
  Widget _buildActivityCard() {
    return _buildSettingCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '오늘의 활동',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kColorTextTitle
                )
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.directions_walk, _steps, '걸음', '걸음 수', kPrimaryGreen),
                _buildStatItem(Icons.local_fire_department, _activeCalories.round(), 'kcal', '소모 칼로리', kColorError),
                _buildStatItem(Icons.timer, _moveMinutes, '분', '움직인 시간', kColorBtnPrimary),
              ],
            ),
          ],
        )
    );
  }
}