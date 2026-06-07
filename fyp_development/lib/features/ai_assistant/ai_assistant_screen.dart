import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ai_providers.dart';
import '../../providers/app_providers.dart';
import '../shared/api_key_dialog.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_bar.dart';

/// The AI Assistant screen — a ChatGPT-style chat interface.
///
/// Features:
/// - Full chat history in current session
/// - Typing indicator while waiting for AI response
/// - API key setup dialog on first use
/// - Clear chat button
/// - Edit API keys from AppBar
class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Check for API keys on first load
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkApiKeys());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkApiKeys() async {
    final storage = ref.read(secureStorageProvider);
    final hasKey = await storage.hasAnyKey();
    if (!hasKey && mounted) {
      _showApiKeyDialog();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(aiLoadingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // Auto-scroll when messages change
    ref.listen(chatMessagesProvider, (_, __) => _scrollToBottom());
    ref.listen(aiLoadingProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.smart_toy_outlined,
                size: 18,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Assistant',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Testing mentor · DeepSeek + Groq',
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear chat',
              onPressed: () {
                ref.read(chatMessagesProvider.notifier).clearChat();
              },
            ),
          IconButton(
            icon: const Icon(Icons.key_outlined),
            tooltip: 'API Keys',
            onPressed: _showApiKeyDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Chat Messages ──────────────────────────────────────────────
          Expanded(
            child: messages.isEmpty
                ? _WelcomeView(onSuggestionTap: _sendSuggestion)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length && isLoading) {
                        return ChatBubble.typing();
                      }
                      return ChatBubble(message: messages[index]);
                    },
                  ),
          ),

          // ── Input Bar ──────────────────────────────────────────────────
          ChatInputBar(
            isLoading: isLoading,
            onSend: (text) {
              ref.read(chatMessagesProvider.notifier).sendMessage(text);
            },
          ),
        ],
      ),
    );
  }

  void _sendSuggestion(String text) {
    ref.read(chatMessagesProvider.notifier).sendMessage(text);
  }

  void _showApiKeyDialog() {
    showApiKeyDialog(context, ref.read(secureStorageProvider));
  }
}

// ─── Welcome View ──────────────────────────────────────────────────────────

class _WelcomeView extends StatelessWidget {
  final ValueChanged<String> onSuggestionTap;

  const _WelcomeView({required this.onSuggestionTap});

  static const _suggestions = [
    'What is the difference between smoke and sanity testing?',
    'How do I start learning test automation in 2025?',
    'Give me a roadmap to become a senior QA engineer.',
    'What are the most important ISTQB concepts?',
    'How do I test a REST API with Postman?',
    'What tools should I learn for mobile testing?',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // ── Hero ──────────────────────────────────────────────────────────
        Center(
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: 36,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your Testing Mentor',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ask me anything about software testing — concepts, tools, '
                'roadmaps, certifications, and interview prep.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        Text(
          'Try asking:',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),

        const SizedBox(height: 12),

        // ── Suggestion Pills ───────────────────────────────────────────────
        ..._suggestions.map(
          (suggestion) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onSuggestionTap(suggestion),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Key dialog is now in lib/features/shared/api_key_dialog.dart
