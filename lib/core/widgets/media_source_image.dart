import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

ImageProvider buildImageProviderFromSource(
  String? source, {
  String fallbackAsset = 'assets/sample 1.jpg',
}) {
  if (source == null || source.trim().isEmpty) {
    return AssetImage(fallbackAsset);
  }

  final trimmed = source.trim();

  if (trimmed.startsWith('data:image/')) {
    try {
      final commaIndex = trimmed.indexOf(',');
      if (commaIndex > 0 && commaIndex < trimmed.length - 1) {
        final bytes = base64Decode(trimmed.substring(commaIndex + 1));
        return MemoryImage(bytes);
      }
    } catch (_) {
      return AssetImage(fallbackAsset);
    }
  }

  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return NetworkImage(trimmed);
  }

  if (File(trimmed).existsSync()) {
    return FileImage(File(trimmed));
  }

  return AssetImage(fallbackAsset);
}

Widget buildMediaPreviewFromSource(
  String? source, {
  String fallbackAsset = 'assets/sample 1.jpg',
  BoxFit fit = BoxFit.cover,
}) {
  if (source == null || source.trim().isEmpty) {
    return Image.asset(fallbackAsset, fit: fit);
  }

  final trimmed = source.trim();

  if (trimmed.startsWith('data:image/')) {
    try {
      final commaIndex = trimmed.indexOf(',');
      if (commaIndex > 0 && commaIndex < trimmed.length - 1) {
        final bytes = base64Decode(trimmed.substring(commaIndex + 1));
        return Image.memory(bytes, fit: fit);
      }
    } catch (_) {
      return Image.asset(fallbackAsset, fit: fit);
    }
  }

  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return Image.network(trimmed, fit: fit);
  }

  if (File(trimmed).existsSync()) {
    return Image.file(File(trimmed), fit: fit);
  }

  return Image.asset(fallbackAsset, fit: fit);
}

Uint8List? mediaBytesFromDataUri(String? source) {
  if (source == null || source.trim().isEmpty) {
    return null;
  }

  final trimmed = source.trim();
  if (!trimmed.startsWith('data:image/')) {
    return null;
  }

  try {
    final commaIndex = trimmed.indexOf(',');
    if (commaIndex > 0 && commaIndex < trimmed.length - 1) {
      return base64Decode(trimmed.substring(commaIndex + 1));
    }
  } catch (_) {
    return null;
  }

  return null;
}
