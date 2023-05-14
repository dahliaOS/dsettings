import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:dsettings/server.dart';
import 'package:logging/logging.dart';

Future<void> main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log(
      record.message,
      level: record.level.value,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      stackTrace: record.stackTrace,
      error: record.error,
      name: record.loggerName,
    );
  });
  stdout.writeln("Starting DSettings server");
  DSettingsServer.instance.open(arguments.first);
}

class DSettingsServer {
  DSettings? dsettings;
  final DBusClient client = DBusClient.session();
  StreamSubscription<ProcessSignal>? sigint;
  StreamSubscription<ProcessSignal>? sigterm;

  DSettingsServer._();

  static final DSettingsServer instance = DSettingsServer._();

  Future<void> open(String path) async {
    await client.requestName("io.dahlia.DSettings");
    final DSettings dsettings = await DSettings.newInstance(Directory(path));

    await client.registerObject(dsettings);
    await dsettings.registerTables();

    sigint = ProcessSignal.sigint.watch().listen(_closeFromSignal);
    sigterm = ProcessSignal.sigterm.watch().listen(_closeFromSignal);
    stdout.writeln("DSettings started sucessfully. Hit Ctrl+C to close.");
  }

  Future<void> _closeFromSignal(ProcessSignal e) => close();

  Future<void> close() async {
    log("\nClosing server");
    await dsettings?.close();
    await client.releaseName("io.dahlia.DSettings");
    await client.close();
    await sigint?.cancel();
    await sigterm?.cancel();
    exit(0);
  }
}
