class PixelArtModel {
  final String id;
  final String authorId;
  final String title;
  final String description;
  final Map<String, dynamic> size;
  final List<String> palette;
  final String gridData;
  final DateTime createdAt;
  final DateTime lastModifiedAt;

  PixelArtModel({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.size,
    required this.palette,
    required this.gridData,
    required this.createdAt,
    required this.lastModifiedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorId': authorId,
        'title': title,
        'description': description,
        'size': size,
        'palette': palette,
        'gridData': gridData,
        'createdAt': createdAt.toIso8601String(),
        'lastModifiedAt': lastModifiedAt.toIso8601String(),
      };

  factory PixelArtModel.fromJson(Map<String, dynamic> json) => PixelArtModel(
        id: json['id'],
        authorId: json['authorId'],
        title: json['title'],
        description: json['description'],
        size: Map<String, dynamic>.from(json['size']),
        palette: List<String>.from(json['palette']),
        gridData: json['gridData'],
        createdAt: DateTime.parse(json['createdAt']),
        lastModifiedAt: DateTime.parse(json['lastModifiedAt']),
      );
}