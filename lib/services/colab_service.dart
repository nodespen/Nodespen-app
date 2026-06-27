import 'dart:async';
import '../core/document/document.dart';

enum ColabState { disconnected, connecting, connected, error }

class ColabPeer {
  final String id;
  final String name;
  final bool isLocal;

  ColabPeer({required this.id, required this.name, this.isLocal = false});
}

class ColabService {
  ColabState _state = ColabState.disconnected;
  final List<ColabPeer> _peers = [];
  String? _sessionId;
  String? _userName;

  ColabState get state => _state;
  List<ColabPeer> get peers => List.unmodifiable(_peers);
  String? get sessionId => _sessionId;

  final StreamController<NodespenDocument> _documentStream = StreamController.broadcast();
  Stream<NodespenDocument> get documentStream => _documentStream.stream;

  Future<bool> connect(String sessionId, {String? userName}) async {
    _state = ColabState.connecting;
    _sessionId = sessionId;
    _userName = userName ?? 'Usuario ${DateTime.now().millisecond}';
    await Future.delayed(const Duration(milliseconds: 500));
    _state = ColabState.connected;
    _peers.add(ColabPeer(id: 'local', name: _userName!, isLocal: true));
    _peers.add(ColabPeer(id: 'remote-1', name: 'Colaborador'));
    return true;
  }

  void disconnect() {
    _state = ColabState.disconnected;
    _peers.clear();
    _sessionId = null;
  }

  void sendDocument(NodespenDocument document) {
    _documentStream.add(document);
  }

  void dispose() {
    _documentStream.close();
  }
}
