import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import '../exceptions.dart';

enum ActionType {
  START,
  ADD,
  DELETE,
  EDIT,
  SEARCH,
  LIST,
  STATS,
  VIEW_LOGS,
  REPORT,
  EXIT,
  ERROR,
}

class LoggerService {
  final String logFilePath;
  ReceivePort? _mainReceivePort;
  SendPort? _sendPort;
  Isolate? _isolate;

  LoggerService({required this.logFilePath});

  Future<void> init() async {
    _mainReceivePort = ReceivePort();
    _isolate = await Isolate.spawn(_logIsolateEntry, _mainReceivePort!.sendPort);
    _sendPort = await _mainReceivePort!.first as SendPort;
  }

  void close() {
    _mainReceivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _mainReceivePort = null;
  }

  void log(ActionType action, String message) {
    final now = DateTime.now();
    final formatted = '${_formatDate(now)} [${action.name}] $message';
    try {
      _sendPort?.send(formatted);
    } catch (e) {
      stderr.writeln('Ошибка отправки в изолят лога: $e');
    }
  }

  Future<void> flush() async {
    final receivePort = ReceivePort();
    _sendPort?.send(receivePort.sendPort);
    await receivePort.first;
    receivePort.close();
  }

  Future<List<String>> getLastLines(int n) async {
    final file = File(logFilePath);
    if (!await file.exists()) return [];
    try {
      final lines = await file
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .toList();
      if (lines.length <= n) return lines;
      return lines.sublist(lines.length - n);
    } catch (e) {
      throw LogFileException('Ошибка чтения лог-файла: $e');
    }
  }

  String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$y-$mo-$d $h:$mi:$s';
  }
}

void _logIsolateEntry(SendPort mainSendPort) {
  final receivePort = ReceivePort();
  mainSendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message is String) {
      _writeLogEntry(message);
      mainSendPort.send('OK');
    } else if (message is SendPort) {
      message.send('FLUSHED');
    }
  });
}

void _writeLogEntry(String entry) {
  try {
    final file = File('logs.txt');
    file.writeAsStringSync(entry + '\n', mode: FileMode.append);
  } catch (e) {
    stderr.writeln('Ошибка записи лога: $e');
  }
}
