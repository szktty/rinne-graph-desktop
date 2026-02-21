/// Class representing basic stack information (`meta/info.json`)
class StackInfo {
  const StackInfo({
    required this.name,
    required this.createdAt,
    required this.lastModifiedAt,
    required this.version,
    this.description,
    this.author,
    this.thumbnail,
    this.tags = const [],
    this.isSample = false,
    this.sampleTemplateId,
    this.language,
  });

  factory StackInfo.fromJson(Map<String, dynamic> json) {
    // Get creation date (from createdAt or created field)
    final createdAtStr =
        json['createdAt'] as String? ?? json['created'] as String?;
    if (createdAtStr == null) {
      throw ArgumentError(
        'createdAt or created field is required in StackInfo JSON',
      );
    }
    final createdAt = DateTime.parse(createdAtStr);

    // Get last modified date (from lastModifiedAt or modified field, use createdAt if not present)
    final lastModifiedAtStr =
        json['lastModifiedAt'] as String? ??
        json['modified'] as String? ??
        createdAtStr;
    final lastModifiedAt = DateTime.parse(lastModifiedAtStr);

    return StackInfo(
      name: json['name'] as String,
      description: json['description'] as String?,
      author: json['author'] as String?,
      thumbnail: json['thumbnail'] as String?,
      createdAt: createdAt,
      lastModifiedAt: lastModifiedAt,
      version: json['version'] as String,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      isSample: json['isSample'] as bool? ?? false,
      sampleTemplateId: json['sampleTemplateId'] as String?,
      language: json['language'] as String?,
    );
  }
  final String name;
  final String? description;
  final String? author;
  final String? thumbnail;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  final String version;
  final List<String> tags;
  final bool isSample;
  final String? sampleTemplateId;
  final String? language;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (author != null) 'author': author,
      if (thumbnail != null) 'thumbnail': thumbnail,
      'createdAt': createdAt.toIso8601String(),
      'lastModifiedAt': lastModifiedAt.toIso8601String(),
      'version': version,
      'tags': tags,
      if (isSample) 'isSample': isSample,
      if (sampleTemplateId != null) 'sampleTemplateId': sampleTemplateId,
      if (language != null) 'language': language,
    };
  }

  StackInfo copyWith({
    String? name,
    String? description,
    String? author,
    String? thumbnail,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
    String? version,
    List<String>? tags,
    bool? isSample,
    String? sampleTemplateId,
    String? language,
  }) {
    return StackInfo(
      name: name ?? this.name,
      description: description ?? this.description,
      author: author ?? this.author,
      thumbnail: thumbnail ?? this.thumbnail,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      version: version ?? this.version,
      tags: tags ?? this.tags,
      isSample: isSample ?? this.isSample,
      sampleTemplateId: sampleTemplateId ?? this.sampleTemplateId,
      language: language ?? this.language,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StackInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          author == other.author &&
          thumbnail == other.thumbnail &&
          createdAt == other.createdAt &&
          lastModifiedAt == other.lastModifiedAt &&
          version == other.version &&
          isSample == other.isSample &&
          sampleTemplateId == other.sampleTemplateId &&
          language == other.language &&
          // Using ListEquality is more robust, but here we compare simply
          _listEquals(tags, other.tags);

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    description,
    author,
    thumbnail,
    createdAt,
    lastModifiedAt,
    version,
    isSample,
    sampleTemplateId,
    language,
    Object.hashAll(tags), // List hashCode
  );

  // Helper for simple list comparison
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'StackInfo(${toJson()})';
  }
}
