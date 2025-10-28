import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/pixel_art_model.dart';

class PixelArtService {
  Future<void> savePixelArt(PixelArtModel art) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${art.id}.json');
    await file.writeAsString(jsonEncode(art.toJson()));
  }

  Future<PixelArtModel?> loadPixelArt(String id) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$id.json');
    if (!file.existsSync()) return null;

    final content = await file.readAsString();
    final data = jsonDecode(content);
    return PixelArtModel.fromJson(data);
  }
}