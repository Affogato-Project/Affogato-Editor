part of affogato.editor;

typedef JSON = Map<String, Object?>;

/// The [LSPClient] provides a standardised interface to send messages to an LSP server
/// and to react to responses received. In order to send notifications, any of the predefined [send]
/// methods, prefixed with `notify`, can be used.
///
/// Since the LSP model identifies request-response pairs using IDs, in order to send requests and asynchronously
/// await responses, use the [sendRequest] method and specify a callback. The [LSPClient] instance will handle
/// ID-ing the requests and responses, as well as converting responses from JSON to native types and subsequently
/// triggering the callbacks.
class LSPClient {
  final StreamController<lsp.ServerResponse> _responseStreamController =
      StreamController();
  late final Stream<lsp.ServerResponse> responseStream =
      _responseStreamController.stream;

  HtmlWebSocketChannel? _socket;
  final Map<String, void Function(JSON)> _requests = {};

  void initClient({
    required String host,
    required int port,
  }) async {
    _socket = HtmlWebSocketChannel.connect("ws://$host:$port");
    _socket!.stream.listen((message) {
      if (_requests.containsKey(message['id'])) {
        _requests[message['id']]!.call(message);
        _requests.remove(message['id']);
      }
    });
  }

  void send(Map<String, dynamic> payload) {
    _socket!.sink.add(jsonEncode(payload));
  }

  void sendRequest(
    Map<String, dynamic> payload,
    void Function(JSON) handler,
  ) {
    send(payload..addAll({'id': _requests[utils.generateId()] = handler}));
  }

  void sendInit({
    required AffogatoVFS vfs,
  }) {
    print(vfs.pathToEntity(vfs.root.entityId));
    return;
    send({
      "jsonrpc": "2.0",
      "method": "initialize",
      "params": {
        "processId": 12345,
        "rootUri": "vfs:///path/to/project",
        "capabilities": {
          "workspace": {
            "applyEdit": true,
            "workspaceEdit": {
              "documentChanges": false,
              "resourceOperations": ["create", "rename", "delete"]
            },
            "symbol": {"dynamicRegistration": false},
            "executeCommand": {"dynamicRegistration": false}
          },
          "textDocument": {
            "synchronization": {
              "dynamicRegistration": true,
              "willSave": true,
              "willSaveWaitUntil": true,
              "didSave": true
            },
            "completion": {
              "dynamicRegistration": true,
              "completionItem": {
                "snippetSupport": true,
                "commitCharactersSupport": true,
                "documentationFormat": ["markdown", "plaintext"]
              }
            },
            "hover": {
              "dynamicRegistration": true,
              "contentFormat": ["markdown", "plaintext"]
            },
            "definition": {"dynamicRegistration": false},
            "references": {"dynamicRegistration": false},
            "rename": {"dynamicRegistration": true, "prepareSupport": true}
          },
          "window": {
            "showMessage": {
              "messageActionItem": {"additionalPropertiesSupport": false}
            },
            "workDoneProgress": false,
          },
          "general": {
            "positionEncodings": ["utf-8"]
          }
        },
        "trace": "off",
        "workspaceFolders": [
          {"uri": "file:///path/to/project", "name": "project"}
        ]
      }
    });
  }

  void notifyTextDocumentDidOpen({
    required String path,
    required AffogatoDocument document,
    required String language,
  }) {
    send({
      "jsonrpc": "2.0",
      "method": "textDocument/didOpen",
      "params": {
        "textDocument": {
          "uri": "vfs://$path",
          "languageId": language,
          "version": document.versionNumber,
          "text": document.content,
        }
      }
    });
  }

  void notifyTextDocumentDidChange({
    required String path,
    required AffogatoDocument document,
    required List<lsp.TextEdit> contentChanges,
  }) {
    send({
      "jsonrpc": "2.0",
      "method": "textDocument/didChange",
      "params": {
        "textDocument": {
          "uri": "vfs://$path",
          "version": document.versionNumber
        },
        "contentChanges": contentChanges.map((c) => c.toJson()),
      }
    });
  }

  void requestTextDocumentCompletion({
    required String path,
    required lsp.Position position,
    required void Function(lsp.CompletionRequestResponse) callback,
  }) {
    sendRequest(
      {
        "jsonrpc": "2.0",
        "method": "textDocument/completion",
        "params": {
          "textDocument": {"uri": "vfs://$path"},
          "position": position.toJson(),
        }
      },
      (payload) {
        callback(lsp.CompletionRequestResponse.fromJson(payload));
      },
    );
  }

  Future<void> closeServer() async {
    await _socket?.sink.close(1001); // going away
  }
}
