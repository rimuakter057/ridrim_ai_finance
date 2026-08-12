import 'package:flutter/material.dart';

/// A single signed-in device session, shown on the Active Sessions screen.
class DeviceSession {
  const DeviceSession({
    required this.id,
    required this.deviceName,
    required this.icon,
    required this.location,
    required this.lastActiveLabel,
    this.isCurrent = false,
  });

  final String id;
  final String deviceName;
  final IconData icon;
  final String location;
  final String lastActiveLabel;
  final bool isCurrent;
}

/// Mock signed-in devices for the current account.
const List<DeviceSession> mockDeviceSessions = [
  DeviceSession(
    id: 'device_current',
    deviceName: 'Pixel 9 Pro · Android',
    icon: Icons.phone_android_rounded,
    location: 'Dhaka, Bangladesh',
    lastActiveLabel: 'Active now',
    isCurrent: true,
  ),
  DeviceSession(
    id: 'device_macbook',
    deviceName: 'MacBook Pro · Chrome',
    icon: Icons.laptop_mac_rounded,
    location: 'Dhaka, Bangladesh',
    lastActiveLabel: 'Active 2h ago',
  ),
  DeviceSession(
    id: 'device_ipad',
    deviceName: 'iPad Air · Safari',
    icon: Icons.tablet_mac_rounded,
    location: 'Chattogram, Bangladesh',
    lastActiveLabel: 'Active 3d ago',
  ),
];
