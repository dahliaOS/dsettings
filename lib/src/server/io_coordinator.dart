import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:async/async.dart';

class IOCoordinator {
  final Isolate isolate;
  final ReceivePort receivePort;
  final SendPort sendPort;
  final _BlockingStreamListener _eventListener;

  IOCoordinator._(
    this.isolate,
    this.receivePort,
    this.sendPort,
    this._eventListener,
  );

  static Future<IOCoordinator> create() async {
    final ReceivePort receivePort = ReceivePort();
    final Isolate isolate =
        await Isolate.spawn(_isolateMain, receivePort.sendPort);

    final _BlockingStreamListener eventListener =
        _BlockingStreamListener(receivePort);
    final SendPort port = await eventListener.nextEvent as SendPort;

    return IOCoordinator._(isolate, receivePort, port, eventListener);
  }

  Future<void> open(File file) {
    sendPort.send(_IOIsolateOpenMessage(data: file.path));
    return _eventListener.nextEvent;
  }

  Future<void> delete() {
    sendPort.send(const _IOIsolateDeleteMessage());
    return _eventListener.nextEvent;
  }

  void close() {
    sendPort.send(const _IOIsolateCloseMessage());
  }

  void write(String contents) {
    sendPort.send(_IOIsolateRequestWriteMessage(data: contents));
  }
}

void _isolateMain(SendPort sendPort) {
  final ReceivePort port = ReceivePort();
  sendPort.send(port.sendPort);

  _IOIsolateCoordinator? coordinator;

  port.listen(
    (message) async {
      if (message is! _IOIsolateMessage) return;

      switch (message) {
        case _IOIsolateOpenMessage(:final data):
          if (coordinator != null) return;
          coordinator = _IOIsolateCoordinator(File(data));
          sendPort.send(null); // We finished setting up the file, go on
        case _IOIsolateCloseMessage():
          coordinator?.close();
          coordinator = null;
        case _IOIsolateRequestWriteMessage(:final data):
          coordinator?.requestWrite(data);
        case _IOIsolateDeleteMessage():
          await coordinator?.delete();
          sendPort.send(null);
      }
    },
    onDone: () {
      coordinator?.close();
      coordinator = null;
    },
  );
}

class _IOIsolateCoordinator {
  final File file;
  late final RandomAccessFile raf;
  CancelableOperation? _lastRequest;
  Completer? _writeCompleter;
  late String _lastWrittenContents;
  Timer? _lastWriteFromSelfTimer;
  bool _lastWriteFromSelf = false;
  Timer? _restoreContentsDebounceTimer;

  late final StreamSubscription subscription;

  _IOIsolateCoordinator(this.file) {
    final String contents = file.readAsStringSync();
    raf = file.openSync(mode: FileMode.writeOnly);
    raf.lockSync();
    raf.writeStringSync(contents);
    _lastWrittenContents = contents;
    final Stream<FileSystemEvent> events = file.watch(
      events: FileSystemEvent.modify,
    );
    subscription = events.listen(_onFileEvent);
  }

  Future<void> delete() async {
    await close();
    await file.delete();
  }

  Future<void> close() async {
    _lastRequest?.cancel();
    _lastWriteFromSelfTimer?.cancel();
    _restoreContentsDebounceTimer?.cancel();
    subscription.cancel();
    raf.unlockSync();
    raf.closeSync();
  }

  void _onFileEvent(FileSystemEvent event) {
    if (_lastWriteFromSelf) return;

    _restoreContentsDebounceTimer?.cancel();
    _restoreContentsDebounceTimer =
        Timer(const Duration(milliseconds: 200), _restoreFileContents);
  }

  Future<void> _restoreFileContents() async {
    final String contents = await file.readAsString();

    if (contents == _lastWrittenContents) return;

    requestWrite(_lastWrittenContents, false);
  }

  String read() {
    return file.readAsStringSync();
    //utf8.decode(raf.readSync(raf.lengthSync()));
  }

  Future<void> requestWrite(
    String contents, [
    bool replaceLastWrittenContents = true,
  ]) async {
    if (_writeCompleter != null) {
      _lastRequest?.cancel();
      _lastRequest = CancelableOperation.fromFuture(
        _waitForLastWrite(contents, replaceLastWrittenContents),
      );
      return;
    }

    await _write(contents);
    _writeCompleter = null;
  }

  Future<void> _waitForLastWrite(
    String contents, [
    bool replaceLastWrittenContents = true,
  ]) async {
    await _writeCompleter?.future;
    return requestWrite(contents);
  }

  Future<void> _write(
    String contents, [
    bool replaceLastWrittenContents = true,
  ]) async {
    _writeCompleter = Completer();
    final List<int> utf8Encoded = utf8.encode(contents);
    raf.setPositionSync(0);
    raf.truncateSync(utf8Encoded.length);
    raf.writeFromSync(utf8Encoded);
    raf.flushSync();

    if (replaceLastWrittenContents) _lastWrittenContents = contents;
    _lastWriteFromSelf = true;

    _lastWriteFromSelfTimer?.cancel();
    _lastWriteFromSelfTimer = Timer(
      const Duration(milliseconds: 100),
      () => _lastWriteFromSelf = false,
    );

    _writeCompleter!.complete();
  }
}

sealed class _IOIsolateMessage<T> {
  final T data;

  const _IOIsolateMessage({required this.data});
}

class _IOIsolateOpenMessage extends _IOIsolateMessage<String> {
  const _IOIsolateOpenMessage({required super.data});
}

class _IOIsolateCloseMessage extends _IOIsolateMessage<void> {
  const _IOIsolateCloseMessage() : super(data: null);
}

class _IOIsolateRequestWriteMessage extends _IOIsolateMessage<String> {
  const _IOIsolateRequestWriteMessage({required super.data});
}

class _IOIsolateDeleteMessage extends _IOIsolateMessage<void> {
  const _IOIsolateDeleteMessage() : super(data: null);
}

class _BlockingStreamListener<T> {
  final Stream<T> stream;
  late final StreamSubscription<T> _subscription;
  Completer<T> _completer = Completer<T>();

  _BlockingStreamListener(this.stream) {
    _subscription = stream.listen(_eventListener);
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<T> get nextEvent => _completer.future;

  void _eventListener(T event) {
    _completer.complete(event);
    _completer = Completer<T>();
  }
}
