part of affogato.apis;

/// Stores information about the source, including the path to the file and its
/// contents.
class AffogatoDocument {
  String docName;
  String srcContent;
  List<String> contentVersions = [];
  final int maxVersioningLimit;
  final bool readOnly;
  int versionNumber = 1;

  String get hash => "$docName$srcContent".hashCode.toString();

  String get extension => docName.split('.').last;

  AffogatoDocument({
    required this.docName,
    required this.srcContent,
    required this.maxVersioningLimit,
    this.readOnly = false,
  }) {
    contentVersions.add(srcContent);
  }

  String get content => contentVersions.last;

  void addVersion(String content) {
    versionNumber += 1;
    if (contentVersions.length == maxVersioningLimit) {
      contentVersions
        ..removeAt(0)
        ..add(content);
    } else {
      contentVersions.add(content);
    }
  }

  @override
  String toString() =>
      "$docName[${hash.substring(0, 6)}]: '${srcContent.length >= 7 ? '${srcContent.substring(0, 7)}...' : srcContent}'";

  @override
  bool operator ==(Object other) =>
      other is AffogatoDocument && other.hash == hash;

  @override
  int get hashCode => "$docName$srcContent".hashCode;
}
