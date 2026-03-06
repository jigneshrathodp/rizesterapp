import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ApiCacheService {
  static const Duration _defaultCacheDuration = Duration(minutes: 5);
  static const String _cacheDirName = 'api_cache';
  
  static Future<String> get _cacheDir async {
    final directory = await getTemporaryDirectory();
    final cacheDir = Directory('${directory.path}/$_cacheDirName');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir.path;
  }
  
  static Future<String?> _getCachedData(String cacheKey) async {
    try {
      final cacheDir = await _cacheDir;
      final cacheFile = File('$cacheDir/$cacheKey.json');
      
      if (!await cacheFile.exists()) {
        return null;
      }
      
      final cacheData = json.decode(await cacheFile.readAsString());
      final timestamp = cacheData['timestamp'] as int;
      final data = cacheData['data'] as String;
      
      // Check if cache is still valid
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (cacheAge > _defaultCacheDuration.inMilliseconds) {
        await cacheFile.delete();
        return null;
      }
      
      return data;
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> _cacheData(String cacheKey, String data) async {
    try {
      final cacheDir = await _cacheDir;
      final cacheFile = File('$cacheDir/$cacheKey.json');
      
      final cacheData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': data,
      };
      
      await cacheFile.writeAsString(json.encode(cacheData));
    } catch (e) {
      // Ignore cache errors
    }
  }
  
  static Future<void> clearCache() async {
    try {
      final cacheDir = await _cacheDir;
      final cacheDirectory = Directory(cacheDir);
      if (await cacheDirectory.exists()) {
        await cacheDirectory.delete(recursive: true);
      }
    } catch (e) {
      // Ignore cache clear errors
    }
  }
  
  static Future<http.Response> getCachedResponse(
    String url, {
    Map<String, String>? headers,
    Duration? cacheDuration,
    bool forceRefresh = false,
  }) async {
    final cacheKey = url.hashCode.toString();
    
    // Try to get cached data if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await _getCachedData(cacheKey);
      if (cachedData != null) {
        return http.Response(cachedData, 200);
      }
    }
    
    // Make actual API call
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('Request timeout'),
    );
    
    // Cache successful responses
    if (response.statusCode == 200) {
      await _cacheData(cacheKey, response.body);
    }
    
    return response;
  }
  
  static Future<http.Response> postCachedResponse(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool cacheResponse = false,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
      encoding: encoding,
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('Request timeout'),
    );
    
    // Cache successful POST responses if requested
    if (cacheResponse && response.statusCode == 200) {
      final cacheKey = '${url.hashCode}_${body.hashCode}'.toString();
      await _cacheData(cacheKey, response.body);
    }
    
    return response;
  }
}
