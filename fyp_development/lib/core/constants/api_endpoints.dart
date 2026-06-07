// API endpoint constants for AI providers

/// DeepSeek API — OpenAI-compatible, free tier available
const String kDeepSeekBaseUrl = 'https://api.deepseek.com';
const String kDeepSeekChatPath = '/chat/completions';
const String kDeepSeekModel = 'deepseek-chat';

/// Groq API — OpenAI-compatible, very fast free tier
const String kGroqBaseUrl = 'https://api.groq.com';
const String kGroqChatPath = '/openai/v1/chat/completions';
const String kGroqModel = 'llama-3.1-8b-instant';

/// Common request config for both APIs
const double kAiTemperature = 0.7;
const int kAiMaxTokens = 1024;

/// YouTube Data API v3
const String kYoutubeBaseUrl = 'https://www.googleapis.com/youtube/v3';
const String kYoutubeSearchPath = '/search';
