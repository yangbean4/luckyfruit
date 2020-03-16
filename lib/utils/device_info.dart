import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

class DeviceIofo {
  static Map<String, dynamic> device;
  static Map<String, dynamic> info;

  static getInfo() async {
    if (info != null && info.isNotEmpty) {
      return info;
    } else {
      info = await ininInfo();
      return info;
    }
  }

  static Future<Map<String, dynamic>> initDeviceInfo() async {
    if (device == null || device.isEmpty) {
      DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        device = _readAndroidBuildData(androidInfo);
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        device = _readIosDeviceInfo(iosInfo);
      }
    }
    return device;
  }

  // static Future<PackageInfo> initPakeageInfo() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   return packageInfo;
  // }

  static String getValue({String androidName, String iosName}) =>
      Platform.isAndroid ? device[androidName] : device[iosName];

  static Future<Map<String, dynamic>> ininInfo() async {
    await initDeviceInfo();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Map<String, dynamic> info = {
      "os_type": Platform.isAndroid ? 'android' : 'ios',
      'gaid': getValue(androidName: 'gaid'),
      'aid': getValue(androidName: 'androidId'),
      'mode': device['model'],
      'brand': getValue(androidName: 'brand', iosName: 'utsname.machine'),
      'idfa': device['identifierForVendor'],
      'app_version': packageInfo.version
    };

    return info;
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId
    };
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname': data.utsname.sysname,
      'utsname.nodename': data.utsname.nodename,
      'utsname.release': data.utsname.release,
      'utsname.version': data.utsname.version,
      'utsname.machine': data.utsname.machine,
    };
  }
}
