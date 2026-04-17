import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../utils/plant_presets.dart';
import '../utils/notification_service.dart';
import 'main_plant_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PlantPreset _activePreset = PlantDataBank.presets[0];

  String _liveTemp = '--';
  String _liveHumidity = '--';
  String _liveUv = '--';
  String _liveMoisture = '--';
  
  bool _isOnline = true; 
  bool _hasReceivedInitialData = false; 
  int _lastTimestamp = 0;
  Timer? _connectionTimer;
  int _serverTimeOffset = 0; 

  // --- STATE MACHINE MEMORY ---
  String _lastMoistureState = 'UNKNOWN';
  String _lastUvState = 'UNKNOWN';
  String _lastSystemState = 'UNKNOWN';

  // --- DURATION TRACKING KEYS ---
  String _activeMoistureLogKey = '';
  String _activeUvLogKey = '';
  String _activeSystemLogKey = '';

  List<Map<String, dynamic>> _notifications = [];
  bool get _hasUnread => _notifications.any((n) => n['isRead'] == false);

  String _plantStatusText = 'Analyzing Health...';
  Color _plantStatusColor = Colors.white.withValues(alpha: 0.2);
  Color _plantStatusTextColor = Colors.white;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    NotificationService.initialize(); 
    _activateListeners();
    _startConnectionMonitor();
    
    // Auto-refresh the main UI periodically for durations
    Timer.periodic(const Duration(minutes: 1), (timer) { if (mounted) setState(() {}); });
  }

  @override
  void dispose() {
    _connectionTimer?.cancel();
    super.dispose();
  }

  void _activateListeners() {
    String userUid = FirebaseAuth.instance.currentUser?.uid ?? 'dx65tKcurHSogGtEXBMhW1C4Ymk1';

    _database.child('.info/serverTimeOffset').onValue.listen((event) {
      if (event.snapshot.value != null) _serverTimeOffset = (event.snapshot.value as num).toInt();
    });
    
    _database.child('UsersData/$userUid/activePreset').onValue.listen((event) {
      if (event.snapshot.value != null) {
        String savedPlantName = event.snapshot.value.toString();
        PlantPreset foundPreset = PlantDataBank.presets.firstWhere((preset) => preset.name == savedPlantName, orElse: () => PlantDataBank.presets[0]);
        
        if (mounted && _activePreset.name != foundPreset.name) {
          _hardResetStatesForNewPlant(foundPreset);
        }
      }
    });

    _database.child('UsersData/$userUid/notifications').onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> raw = event.snapshot.value as Map;
        List<Map<String, dynamic>> parsedList = [];
        
        _activeMoistureLogKey = ''; _activeUvLogKey = ''; _activeSystemLogKey = '';

        raw.forEach((key, value) {
          int safeStartTime = value['startTime'] ?? value['time'] ?? 0;
          
          // THE FIX: If the ticket is corrupted/missing time, completely ignore it!
          if (safeStartTime == 0) return; 
          
          parsedList.add({
            'key': key,
            'title': value['title'] ?? 'System Alert',
            'stateId': value['stateId'] ?? 'UNKNOWN',
            'startTime': safeStartTime, 
            'endTime': value['endTime'], 
            'isRead': value['isRead'] ?? false,
            'category': value['category'] ?? 'system', 
          });

          if (value['endTime'] == null) {
            if (value['category'] == 'moisture') _activeMoistureLogKey = key;
            if (value['category'] == 'uv') _activeUvLogKey = key;
            if (value['category'] == 'system') _activeSystemLogKey = key;
          }
        });

        parsedList.sort((a, b) => (b['startTime'] as int).compareTo(a['startTime'] as int));
        if (mounted) setState(() { _notifications = parsedList; });
      } else {
        if (mounted) setState(() { _notifications = []; });
      }
    });

    String devicePath = 'UsersData/$userUid/sensors/FLAURA_001';
    _database.child(devicePath).onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        if (mounted) {
          setState(() {
            _hasReceivedInitialData = true; 
            
            _liveTemp = data['temperature'] != null ? '${(data['temperature'] as num).toStringAsFixed(1)}°C' : '--';
            _liveHumidity = data['humidity'] != null ? '${data['humidity']}%' : '--';
            _liveUv = data['uvIndex']?.toString() ?? '--';
            _lastTimestamp = data['lastTimestamp'] != null ? (data['lastTimestamp'] as num).toInt() : 0;
            
            if (data['moisture'] != null) {
              int currentMoisture = (data['moisture'] as num).toInt();
              _liveMoisture = '$currentMoisture%';
              _updatePlantStatus(currentMoisture, _liveUv); 
            } else {
              _liveMoisture = '--';
            }
            _checkIfOnline();
          });
        }
      }
    });
  }

  void _hardResetStatesForNewPlant(PlantPreset newPreset) {
    int now = DateTime.now().millisecondsSinceEpoch + _serverTimeOffset;
    String userUid = FirebaseAuth.instance.currentUser?.uid ?? 'dx65tKcurHSogGtEXBMhW1C4Ymk1';
    DatabaseReference notifRef = _database.child('UsersData/$userUid/notifications');

    if (_activeMoistureLogKey.isNotEmpty) notifRef.child(_activeMoistureLogKey).update({'endTime': now});
    if (_activeUvLogKey.isNotEmpty) notifRef.child(_activeUvLogKey).update({'endTime': now});

    _activeMoistureLogKey = '';
    _activeUvLogKey = '';
    _lastMoistureState = 'UNKNOWN';
    _lastUvState = 'UNKNOWN';

    setState(() { _activePreset = newPreset; });
    
    int currentMoisture = int.tryParse(_liveMoisture.replaceAll('%', '')) ?? 0;
    _updatePlantStatus(currentMoisture, _liveUv);
  }

  void _changePreset(PlantPreset preset) {
    String userUid = FirebaseAuth.instance.currentUser?.uid ?? 'dx65tKcurHSogGtEXBMhW1C4Ymk1';
    _database.child('UsersData/$userUid/activePreset').set(preset.name);
    _hardResetStatesForNewPlant(preset); 
  }

  void _handleStateTransition({
    required String category, 
    required String newStateId, 
    required String oldStateId, 
    required String activeKey, 
    required String title,
    required Function(String) updateKeyCallback,
  }) {
    if (newStateId == oldStateId) return; 

    int now = DateTime.now().millisecondsSinceEpoch + _serverTimeOffset;
    String userUid = FirebaseAuth.instance.currentUser?.uid ?? 'dx65tKcurHSogGtEXBMhW1C4Ymk1';
    DatabaseReference notifRef = _database.child('UsersData/$userUid/notifications');

    if (activeKey.isNotEmpty) {
      notifRef.child(activeKey).update({'endTime': now});
    }

    String newKey = notifRef.push().key ?? now.toString();
    notifRef.child(newKey).set({
      'title': title,
      'stateId': newStateId,
      'category': category,
      'startTime': now,
      'endTime': null, 
      'isRead': false,
    });
    updateKeyCallback(newKey); 

    if (oldStateId != 'UNKNOWN' && category != 'system') {
      NotificationService.showWarning(id: now % 10000, title: 'Plant Update', body: title);
    }
  }

  void _updatePlantStatus(int currentMoisture, String currentUv) {
    if (!_isOnline || !_hasReceivedInitialData) return;

    // 1. EVALUATE MOISTURE STATE
    int tolerance = (_activePreset.idealMoisture - _activePreset.minMoisture).abs();
    int moistureDiff = currentMoisture - _activePreset.idealMoisture;
    int absDiff = moistureDiff.abs();

    String newMoistureState = 'OPTIMAL';
    String moistureTitle = '💧 Moisture is Optimal ($currentMoisture%)';

    if (absDiff > tolerance / 2 && absDiff <= tolerance) {
      newMoistureState = moistureDiff < 0 ? 'GETTING_DRY' : 'GETTING_WET';
      moistureTitle = moistureDiff < 0 ? '⚠️ Warning: Getting Dry ($currentMoisture%)' : '⚠️ Warning: Getting Wet ($currentMoisture%)';
    } else if (absDiff > tolerance) {
      newMoistureState = moistureDiff < 0 ? 'TOO_DRY' : 'TOO_WET';
      moistureTitle = moistureDiff < 0 ? '🚨 Critical: Bone Dry ($currentMoisture%)' : '🚨 Critical: Drowning ($currentMoisture%)';
    }

    // 2. EVALUATE UV STATE
    final List<String> uvScale = ['low', 'moderate', 'high', 'very high', 'extreme'];
    int idealPos = uvScale.indexOf(_activePreset.lightRequirement.toLowerCase());
    int currentPos = uvScale.indexOf(currentUv.toLowerCase());
    idealPos = idealPos == -1 ? 0 : idealPos; currentPos = currentPos == -1 ? 0 : currentPos;
    
    int uvDiff = currentPos - idealPos;
    String newUvState = 'OPTIMAL';
    String uvTitle = '☀️ Light Level Optimal';
    
    if (uvDiff < 0) {
      newUvState = 'TOO_DARK'; uvTitle = '⚠️ Warning: Too Dark';
    } else if (uvDiff == 1) {
      newUvState = 'TOO_BRIGHT'; uvTitle = '⚠️ Warning: Too Bright';
    } else if (uvDiff >= 2) {
      newUvState = 'EXTREME'; uvTitle = '🚨 Critical: Sunburn Risk';
    }

    // 3. LOG STATES
    _handleStateTransition(category: 'moisture', newStateId: newMoistureState, oldStateId: _lastMoistureState, activeKey: _activeMoistureLogKey, title: moistureTitle, updateKeyCallback: (key) => _activeMoistureLogKey = key);
    _handleStateTransition(category: 'uv', newStateId: newUvState, oldStateId: _lastUvState, activeKey: _activeUvLogKey, title: uvTitle, updateKeyCallback: (key) => _activeUvLogKey = key);

    _lastMoistureState = newMoistureState;
    _lastUvState = newUvState;

    // 4. UI BADGE LOGIC
    String badgeText = '✅ Optimal Health';
    Color badgeColor = Colors.greenAccent.shade700;
    
    if (newMoistureState.contains('TOO') || newUvState == 'EXTREME') {
      badgeText = '🚨 Critical Attention Needed';
      badgeColor = Colors.redAccent;
    } else if (newMoistureState.contains('GETTING') || newUvState != 'OPTIMAL') {
      badgeText = '⚠️ Suboptimal Conditions';
      badgeColor = Colors.orange;
    }

    if (mounted) {
      setState(() { _plantStatusText = badgeText; _plantStatusColor = badgeColor; });
    }
  }

  void _startConnectionMonitor() {
    _connectionTimer = Timer.periodic(const Duration(seconds: 5), (timer) { _checkIfOnline(); });
  }

  void _checkIfOnline() {
    if (!_hasReceivedInitialData) return; 
    
    int now = DateTime.now().millisecondsSinceEpoch + _serverTimeOffset;
    bool isNowOnline = (now - _lastTimestamp) < 15000; 
    
    String newSystemState = isNowOnline ? 'SYSTEM_ON' : 'SYSTEM_OFF';
    String systemTitle = isNowOnline ? '✅ Sensor Connected' : '⚠️ Sensor Offline';

    _handleStateTransition(
      category: 'system', newStateId: newSystemState, oldStateId: _lastSystemState, 
      activeKey: _activeSystemLogKey, title: systemTitle,
      updateKeyCallback: (key) => _activeSystemLogKey = key,
    );

    _lastSystemState = newSystemState;
    if (mounted) setState(() { _isOnline = isNowOnline; });
  }

  // --- SAFE DURATION MATH ---
  String _formatDuration(int startTime, int? endTime) {
    if (startTime <= 0) return 'Unknown'; // Extra safety net
    
    int end = endTime ?? (DateTime.now().millisecondsSinceEpoch + _serverTimeOffset);
    if (end < startTime) end = startTime; // Prevents negative time if server sync drifts
    
    Duration diff = Duration(milliseconds: end - startTime);
    
    if (diff.inDays > 0) return '${diff.inDays}d ${diff.inHours % 24}h';
    if (diff.inHours > 0) return '${diff.inHours}h ${diff.inMinutes % 60}m';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return '< 1m';
  }

  String _formatTime(int timestamp) {
    if (timestamp <= 0) return '--:--';
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    int h = dt.hour;
    int m = dt.minute;
    String ampm = h >= 12 ? 'PM' : 'AM';
    h = h % 12;
    if (h == 0) h = 12; 
    return '$h:${m.toString().padLeft(2, '0')} $ampm';
  }

  Widget _buildNotificationIcon(String category, String stateId) {
    IconData icon; Color color;
    
    if (stateId.contains('TOO') || stateId.contains('EXTREME') || stateId.contains('OFF')) color = Colors.redAccent;
    else if (stateId.contains('GETTING') || stateId.contains('DARK') || stateId.contains('BRIGHT')) color = Colors.orange;
    else color = Colors.greenAccent.shade700;

    if (category == 'moisture') icon = Icons.water_drop;
    else if (category == 'uv') icon = Icons.light_mode;
    else icon = Icons.wifi; 

    return CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color));
  }

  void _openNotificationsSheet() {
    String userUid = FirebaseAuth.instance.currentUser?.uid ?? 'dx65tKcurHSogGtEXBMhW1C4Ymk1';
    for (var n in _notifications) {
      if (n['isRead'] == false) _database.child('UsersData/$userUid/notifications/${n['key']}').update({'isRead': true});
    }

    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75, 
              decoration: const BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('History Log', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textAccent)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh, color: AppColors.mainAccent),
                              onPressed: () {
                                setModalState(() {}); 
                              },
                            ),
                            TextButton(
                              onPressed: () { _database.child('UsersData/$userUid/notifications').remove(); Navigator.pop(context); },
                              child: const Text('Clear All', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _notifications.isEmpty 
                      ? Center(child: Text("No history recorded yet.", style: TextStyle(color: Colors.grey.shade500)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _notifications.length,
                          itemBuilder: (context, index) {
                            final log = _notifications[index];
                            bool isOngoing = log['endTime'] == null;
                            String durationString = _formatDuration(log['startTime'], log['endTime']);
                            String timeString = _formatTime(log['startTime']); 
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightAccent.withValues(alpha: 0.1))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start, 
                                children: [
                                  _buildNotificationIcon(log['category'], log['stateId']),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(log['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        const SizedBox(height: 4),
                                        Text(
                                          isOngoing ? 'Ongoing for $durationString' : 'Lasted $durationString', 
                                          style: TextStyle(
                                            color: isOngoing ? AppColors.mainAccent : Colors.grey.shade600, 
                                            fontWeight: isOngoing ? FontWeight.bold : FontWeight.normal,
                                            fontSize: 13
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    timeString,
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }

  // ==========================================
  // --- UI BUILD METHOD ---
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning,', style: TextStyle(fontSize: 16, color: AppColors.lightAccent)),
                      Text('Ivan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textAccent)),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _openNotificationsSheet,
                        child: Stack(
                          children: [
                            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.lightAccent.withValues(alpha: 0.1))), child: const Icon(Icons.history, color: AppColors.mainAccent)),
                            if (_hasUnread) Positioned(right: 2, top: 2, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: AppColors.background, width: 2)))),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          int passedMoisture = int.tryParse(_liveMoisture.replaceAll('%', '')) ?? 0;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(activePreset: _activePreset, statusText: _plantStatusText, statusColor: _plantStatusColor, currentMoisture: passedMoisture, currentUv: _liveUv)));
                        },
                        child: CircleAvatar(backgroundColor: AppColors.mainAccent.withValues(alpha: 0.1), radius: 24, child: const Icon(Icons.person, color: AppColors.mainAccent)),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: _isOnline ? Colors.green : Colors.red, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text('System Status: ${_isOnline ? 'Online' : 'Offline'}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _isOnline ? Colors.green : Colors.red)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.lightAccent.withValues(alpha: 0.1)), boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: 1)]),
                child: Column(
                  children: [
                    Row(children: [_buildAmbientStat('Temp', _liveTemp, Icons.thermostat, Colors.orange), _buildAmbientStat('Humidity', _liveHumidity, Icons.cloud, Colors.purple)]),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Divider(color: AppColors.lightAccent.withValues(alpha: 0.1), thickness: 1)),
                    Row(children: [_buildAmbientStat('UV Index', _liveUv, Icons.light_mode, Colors.amber), _buildAmbientStat('Moisture', _liveMoisture, Icons.water_drop, Colors.blue)]),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text('Active Preset Target', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.lightAccent)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  int passedMoisture = int.tryParse(_liveMoisture.replaceAll('%', '')) ?? 0;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainPlantScreen(preset: _activePreset, currentMoisture: passedMoisture, currentUv: _liveUv)));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.mainAccent, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: AppColors.mainAccent.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))]),
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset(_activePreset.imagePath, height: 80, width: 80, fit: BoxFit.cover)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_activePreset.name, style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: _plantStatusColor, borderRadius: BorderRadius.circular(20)), child: Text(_plantStatusText, style: TextStyle(color: _plantStatusTextColor, fontSize: 12, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text('Plant Presets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textAccent)),
              const SizedBox(height: 15),
              ...PlantDataBank.presets.map((preset) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _buildPresetTile(preset))).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: AppColors.lightAccent, fontSize: 12)), Text(value, style: const TextStyle(color: AppColors.textAccent, fontSize: 16, fontWeight: FontWeight.bold))]),
        ],
      ),
    );
  }

  Widget _buildPresetTile(PlantPreset preset) {
    return GestureDetector(
      onTap: () => _changePreset(preset), 
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightAccent.withValues(alpha: 0.1))),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(preset.imagePath, width: 48, height: 48, fit: BoxFit.cover)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(preset.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textAccent)), const SizedBox(height: 4), Text('Target: ${preset.idealMoisture}% Moisture', style: const TextStyle(fontSize: 14, color: AppColors.lightAccent, fontWeight: FontWeight.w500))])),
            const Icon(Icons.chevron_right, color: AppColors.mainAccent), 
          ],
        ),
      ),
    );
  }
}