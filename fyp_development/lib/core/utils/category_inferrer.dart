// Keyword-based category detection for RSS articles and YouTube videos.

/// Scans [title] and [description] for testing-domain keywords and returns
/// the matching [TestingCategory] name (as a string).
/// Falls back to [defaultCategory] when no keywords match.
String inferCategory(String title, String description, String defaultCategory) {
  final text = '${title.toLowerCase()} ${description.toLowerCase()}';

  if (RegExp(r'\bapi\b|rest.?api|postman|graphql|swagger|openapi|grpc').hasMatch(text)) {
    return 'apiTesting';
  }
  if (RegExp(r'performance|load.?test|jmeter|\bk6\b|gatling|stress.?test|web.?vital|lighthouse').hasMatch(text)) {
    return 'performance';
  }
  if (RegExp(r'security|owasp|penetration|pentest|vulnerabilit|exploit|injection|xss|csrf').hasMatch(text)) {
    return 'security';
  }
  if (RegExp(r'mobile|appium|android.?test|ios.?test|xctest|espresso|\bdetox\b|react.?native.?test').hasMatch(text)) {
    return 'mobileTesting';
  }
  if (RegExp(r'interview|career|istqb|certification|resume|job.?seeker|hiring').hasMatch(text)) {
    return 'interviewPrep';
  }
  if (RegExp(r'\bai\b.{0,10}test|test.{0,10}\bai\b|chatgpt|\bllm\b|machine.?learning|copilot|generative.?ai|ai.?quality').hasMatch(text)) {
    return 'aiTesting';
  }
  if (RegExp(r'accessibility|wcag|screen.?reader|\baria\b|\ba11y\b|color.?contrast').hasMatch(text)) {
    return 'accessibility';
  }

  return defaultCategory;
}
