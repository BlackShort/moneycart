import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  BuildContext? _context;

  // Set the context for showing dialogs and snackbars
  void setContext(BuildContext context) {
    _context = context;
  }

  // Method to request all required permissions
  Future<void> requestAllPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.location,
      Permission.microphone,
      Permission.contacts,
      Permission.sms,
      Permission.phone,
      // Add other permissions as needed
    ].request();

    // Handle permission statuses if needed
    statuses.forEach((permission, status) {
      if (status.isDenied) {
        _handlePermissionDenied(permission);
      } else if (status.isPermanentlyDenied) {
        _handlePermissionPermanentlyDenied(permission);
      }
    });
  }

  // Method to check and request a specific permission
  Future<void> checkAndRequestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      // Permission is granted
      return;
    } else if (status.isDenied) {
      // Permission is denied, request it
      final newStatus = await permission.request();
      if (!newStatus.isGranted) {
        _handlePermissionDenied(permission);
      }
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied
      _handlePermissionPermanentlyDenied(permission);
    }
  }

  // Handle permission denied status
  void _handlePermissionDenied(Permission permission) {
    if (_context != null) {
      // Show a snackbar to inform the user
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(content: Text('Permission ${permission.toString()} is denied.')),
      );
    }
  }

  // Handle permission permanently denied status
  void _handlePermissionPermanentlyDenied(Permission permission) {
    if (_context != null) {
      // Show a dialog to guide the user to app settings
      showDialog(
        context: _context!,
        builder: (context) {
          return AlertDialog(
            title: Text('Permission Required'),
            content: Text('Permission ${permission.toString()} is permanently denied. Please enable it in app settings.'),
            actions: [
              TextButton(
                onPressed: () => openAppSettings(),
                child: Text('Open Settings'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }
}
