import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'google_places_api.dart';

class PlaceAutocompleteField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final GooglePlacesApi api;
  final void Function(String picked) onPick;
  final String initialText;

  const PlaceAutocompleteField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.api,
    required this.onPick,
    this.initialText = '',
  });

  @override
  State<PlaceAutocompleteField> createState() => _PlaceAutocompleteFieldState();
}

class _PlaceAutocompleteFieldState extends State<PlaceAutocompleteField> {
  late final TextEditingController _c = TextEditingController(text: widget.initialText);
  Timer? _debounce;
  bool _loading = false;
  List<PlacesSuggestion> _items = const [];

  @override
  void dispose() {
    _debounce?.cancel();
    _c.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      setState(() => _loading = true);
      final r = await widget.api.autocomplete(input: v);
      if (!mounted) return;
      setState(() {
        _items = r;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        AppTextField(
          label: widget.label,
          hint: widget.hint,
          controller: _c,
          prefixIcon: Icon(widget.icon),
          suffixIcon: _loading
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(cs.primary)),
                  ),
                )
              : (_c.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _c.clear();
                        setState(() => _items = const []);
                      },
                      icon: const Icon(Icons.close),
                    )),
        ),
        const SizedBox(height: 8),
        if (_items.isNotEmpty)
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: _items.take(6).map((s) {
                return InkWell(
                  onTap: () {
                    widget.onPick(s.description);
                    setState(() {
                      _items = const [];
                      _c.text = s.description;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.place_outlined, color: cs.onSurfaceVariant),
                        const SizedBox(width: 10),
                        Expanded(child: Text(s.description, maxLines: 2, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _c.addListener(() => _onChanged(_c.text));
  }
}
