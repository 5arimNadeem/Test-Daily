import 'package:flutter/material.dart';
import '../../data/services/secure_storage_service.dart';

/// Shows the API key configuration dialog.
/// Can be called from any screen — Home setup view, AI assistant AppBar, etc.
void showApiKeyDialog(
  BuildContext context,
  SecureStorageService storage, {
  VoidCallback? onSaved,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => ApiKeyDialog(storage: storage, onSaved: onSaved),
  );
}

/// Standalone dialog widget for configuring DeepSeek, Groq, and YouTube API keys.
class ApiKeyDialog extends StatefulWidget {
  final SecureStorageService storage;
  final VoidCallback? onSaved;

  const ApiKeyDialog({super.key, required this.storage, this.onSaved});

  @override
  State<ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends State<ApiKeyDialog> {
  final _deepSeekController = TextEditingController();
  final _groqController = TextEditingController();
  final _youtubeController = TextEditingController();
  bool _isSaving = false;
  bool _showDeepSeek = false;
  bool _showGroq = false;
  bool _showYoutube = false;

  @override
  void initState() {
    super.initState();
    _loadExistingKeys();
  }

  Future<void> _loadExistingKeys() async {
    final dsKey = await widget.storage.getDeepSeekKey();
    final groqKey = await widget.storage.getGroqKey();
    final ytKey = await widget.storage.getYoutubeKey();
    if (mounted) {
      _deepSeekController.text = dsKey ?? '';
      _groqController.text = groqKey ?? '';
      _youtubeController.text = ytKey ?? '';
    }
  }

  @override
  void dispose() {
    _deepSeekController.dispose();
    _groqController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      if (_deepSeekController.text.trim().isNotEmpty) {
        await widget.storage.saveDeepSeekKey(_deepSeekController.text.trim());
      }
      if (_groqController.text.trim().isNotEmpty) {
        await widget.storage.saveGroqKey(_groqController.text.trim());
      }
      if (_youtubeController.text.trim().isNotEmpty) {
        await widget.storage.saveYoutubeKey(_youtubeController.text.trim());
      }
      if (mounted) {
        Navigator.of(context).pop();
        widget.onSaved?.call();
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.key_outlined),
          SizedBox(width: 8),
          Text('Configure API Keys'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'YouTube key: shows videos on Home.\n'
              'DeepSeek / Groq key: powers AI Assistant (both free).',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 20),

            // ── YouTube Data API ──────────────────────────────────────────
            Text('YouTube API Key *',
                style: Theme.of(context).textTheme.labelMedium),
            Text(
              'console.cloud.google.com  →  YouTube Data API v3',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _youtubeController,
              obscureText: !_showYoutube,
              decoration: InputDecoration(
                hintText: 'AIza...',
                suffixIcon: IconButton(
                  icon: Icon(
                      _showYoutube ? Icons.visibility_off : Icons.visibility),
                  onPressed: () =>
                      setState(() => _showYoutube = !_showYoutube),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── DeepSeek ──────────────────────────────────────────────────
            Text('DeepSeek API Key',
                style: Theme.of(context).textTheme.labelMedium),
            Text(
              'platform.deepseek.com  (free tier)',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _deepSeekController,
              obscureText: !_showDeepSeek,
              decoration: InputDecoration(
                hintText: 'sk-...',
                suffixIcon: IconButton(
                  icon: Icon(_showDeepSeek
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _showDeepSeek = !_showDeepSeek),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Groq ──────────────────────────────────────────────────────
            Text('Groq API Key',
                style: Theme.of(context).textTheme.labelMedium),
            Text(
              'console.groq.com  (free tier)',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _groqController,
              obscureText: !_showGroq,
              decoration: InputDecoration(
                hintText: 'gsk_...',
                suffixIcon: IconButton(
                  icon: Icon(
                      _showGroq ? Icons.visibility_off : Icons.visibility),
                  onPressed: () =>
                      setState(() => _showGroq = !_showGroq),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Text(
              'Keys are stored securely on-device and never shared.',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Skip'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save Keys'),
        ),
      ],
    );
  }
}
