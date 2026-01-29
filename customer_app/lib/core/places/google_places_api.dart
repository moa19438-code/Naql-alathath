import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesSuggestion {
  final String placeId;
  final String description;

  const PlacesSuggestion({required this.placeId, required this.description});
}

class GooglePlacesApi {
  final String apiKey;

  const GooglePlacesApi({required this.apiKey});

  Future<List<PlacesSuggestion>> autocomplete({
    required String input,
    String language = 'ar',
    String components = 'country:sa',
  }) async {
    if (input.trim().isEmpty) return const [];

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': input,
        'key': apiKey,
        'language': language,
        'components': components,
      },
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) return const [];

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final status = json['status']?.toString();

    if (status != 'OK' && status != 'ZERO_RESULTS') return const [];

    final preds = (json['predictions'] as List? ?? const []);
    return preds
        .map((e) => PlacesSuggestion(
              placeId: e['place_id']?.toString() ?? '',
              description: e['description']?.toString() ?? '',
            ))
        .where((s) => s.placeId.isNotEmpty && s.description.isNotEmpty)
        .toList();
  }
}
