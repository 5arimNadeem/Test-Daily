// App-wide constants used throughout Test Daily

/// The system prompt injected into every AI conversation.
/// Restricts the AI to software testing topics only.
const String kAiSystemPrompt =
    'You are an expert software testing mentor and career guide. '
    'You help QA engineers, software testers, and students with: '
    'testing concepts, tools (Selenium, Appium, Postman, JMeter, etc.), '
    'test automation frameworks, testing roadmaps, certifications (ISTQB, etc.), '
    'interview preparation, and industry best practices. '
    'If a question is unrelated to software testing or QA, '
    'politely decline and redirect the user to testing topics.';

/// Maximum number of previous chat messages sent to the AI API
/// to keep token usage reasonable.
const int kMaxChatHistoryForApi = 10;

/// Minimum splash screen display time in milliseconds.
const int kSplashDurationMs = 2500;

/// Default Dio connection timeout.
const int kConnectTimeoutSeconds = 15;

/// Default Dio receive timeout (AI responses can be slow).
const int kReceiveTimeoutSeconds = 30;

/// Secure storage keys for API credentials.
const String kDeepSeekKeyStorageKey = 'deepseek_api_key';
const String kGroqKeyStorageKey = 'groq_api_key';
const String kYoutubeKeyStorageKey = 'youtube_api_key';

/// Feed fetch limits — adjust to balance freshness vs. quota usage.
const int kYoutubeMaxResultsPerChannel = 5;
const int kRssMaxItemsPerFeed = 10;

/// App name displayed in the UI.
const String kAppName = 'Test Daily';

/// App tagline.
const String kAppTagline = 'Your daily companion for QA excellence';
