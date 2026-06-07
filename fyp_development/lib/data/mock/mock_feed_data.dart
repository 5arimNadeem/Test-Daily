import '../../models/feed_item.dart';

/// Static mock feed data used for MVP v1.
/// Will be replaced with real RSS + YouTube API data in v2.
/// Images use picsum.photos with a seed string for stable placeholders.
class MockFeedData {
  MockFeedData._();

  static List<FeedItem> get items => _raw
      .map(
        (e) => FeedItem(
          id: e['id']!,
          title: e['title']!,
          description: e['description']!,
          imageUrl: e['imageUrl'],
          source: e['source']!,
          category: e['category']!,
          date: DateTime.parse(e['date']!),
          content: e['content']!,
          externalUrl: e['externalUrl'],
        ),
      )
      .toList();

  static const List<Map<String, String>> _raw = [
    // ── Automation ────────────────────────────────────────────────────────
    {
      'id': 'feed_001',
      'title': 'Getting Started with Selenium WebDriver in 2025',
      'description':
          'A complete beginner\'s guide to setting up Selenium 4 with Python. '
              'Learn how to write your first automated test in under 30 minutes.',
      'imageUrl': 'https://picsum.photos/seed/selenium2025/400/220',
      'source': 'Test Automation University',
      'category': 'automation',
      'date': '2025-03-10',
      'content':
          'Selenium WebDriver remains the most widely used browser automation framework '
              'in the world. In this guide, we\'ll walk through installing Selenium 4, '
              'configuring ChromeDriver, and writing your first Page Object Model (POM) test. '
              '\n\nPrerequisites: Python 3.8+, pip, Chrome browser.\n\n'
              'Step 1: Install Selenium\n```\npip install selenium\n```\n\n'
              'Step 2: Download ChromeDriver matching your Chrome version from chromedriver.chromium.org\n\n'
              'Step 3: Write your first test:\n```python\nfrom selenium import webdriver\n'
              'driver = webdriver.Chrome()\ndriver.get("https://example.com")\nprint(driver.title)\ndriver.quit()\n```\n\n'
              'The Page Object Model separates test logic from page interaction, making your '
              'suite far more maintainable as it grows.',
      'externalUrl': 'https://testautomationu.applitools.com/selenium-webdriver-tutorial/',
    },
    {
      'id': 'feed_002',
      'title': 'Playwright vs Cypress: Which Should You Choose in 2025?',
      'description':
          'An in-depth comparison of the two most popular modern test automation '
              'frameworks — speed, ecosystem, parallelism, and developer experience.',
      'imageUrl': 'https://picsum.photos/seed/playwrightcypress/400/220',
      'source': 'QA Blog Weekly',
      'category': 'automation',
      'date': '2025-03-05',
      'content':
          'Playwright (Microsoft) and Cypress (Cypress.io) are both excellent choices '
              'for end-to-end testing of web applications, but they have very different '
              'philosophies.\n\nPlaywright strengths: multi-browser (Chromium, Firefox, WebKit), '
              'multi-language (JS, Python, C#, Java), faster parallel execution.\n\n'
              'Cypress strengths: developer experience, built-in assertions, '
              'time-travel debugging, large community.\n\n'
              'Verdict: For a new project with multi-browser requirements → Playwright. '
              'For a React/Vue SPA with JS teams already on board → Cypress.',
      'externalUrl': 'https://playwright.dev/docs/intro',
    },

    // ── API Testing ───────────────────────────────────────────────────────
    {
      'id': 'feed_003',
      'title': 'REST API Testing with Postman — Tips & Tricks for 2025',
      'description':
          'Discover 10 power-user features in Postman that most QA engineers '
              'don\'t know about: pre-request scripts, dynamic variables, visualizations.',
      'imageUrl': 'https://picsum.photos/seed/postmantips/400/220',
      'source': 'Ministry of Testing',
      'category': 'apiTesting',
      'date': '2025-03-08',
      'content':
          'Postman is much more than a GUI for sending HTTP requests. Here are 10 features '
              'that will transform your API testing workflow:\n\n'
              '1. Pre-request Scripts — run JavaScript before each request to generate '
              'auth tokens dynamically.\n'
              '2. Test Scripts — assert response bodies, status codes, and headers '
              'with chai-style assertions.\n'
              '3. Collection Runner — run an entire collection against multiple environments.\n'
              '4. Newman — Postman\'s CLI runner, perfect for CI/CD pipelines.\n'
              r'5. Dynamic Variables — use {{$randomEmail}} to generate unique test data.' '\n'
              '6. Environments — switch between dev/staging/prod with a single click.\n'
              '7. Mock Servers — stub APIs before the backend is ready.\n'
              '8. API Documentation — auto-generate docs from your collection.\n'
              '9. Monitors — schedule API health checks on a cron schedule.\n'
              '10. Visualizer — render custom HTML/JS dashboards from response data.',
      'externalUrl': 'https://learning.postman.com/docs/introduction/overview/',
    },
    {
      'id': 'feed_004',
      'title': 'Contract Testing with Pact: Stop Breaking Microservices APIs',
      'description':
          'Learn how consumer-driven contract testing with Pact prevents '
              'integration failures between microservices in production.',
      'imageUrl': 'https://picsum.photos/seed/pactcontract/400/220',
      'source': 'ThoughtWorks Insights',
      'category': 'apiTesting',
      'date': '2025-02-20',
      'content':
          'In a microservices architecture, integration tests are slow and brittle. '
              'Contract testing is a faster alternative: the consumer defines what it expects '
              'from the provider, and the provider verifies it can meet those expectations '
              '— without any services needing to run together.\n\n'
              'Pact is the most popular contract testing tool. It generates a "pact file" '
              'from consumer tests, which the provider then verifies independently.\n\n'
              'Key benefits: fast (runs in unit test time), reliable, catches breaking '
              'changes before they reach production.',
      'externalUrl': 'https://docs.pact.io/',
    },

    // ── Performance ───────────────────────────────────────────────────────
    {
      'id': 'feed_005',
      'title': 'JMeter Load Testing: From Zero to Hero',
      'description':
          'Master Apache JMeter for performance and load testing. '
              'Set up thread groups, samplers, and generate meaningful reports.',
      'imageUrl': 'https://picsum.photos/seed/jmeterperf/400/220',
      'source': 'BlazeMeter Blog',
      'category': 'performance',
      'date': '2025-02-28',
      'content':
          'Apache JMeter is the go-to open-source tool for load testing web applications. '
              'This guide covers:\n\n'
              '- Installing JMeter and understanding the GUI\n'
              '- Creating a Thread Group (virtual users, ramp-up, duration)\n'
              '- Adding HTTP Request Samplers\n'
              '- Using CSV Data Sets for parameterised requests\n'
              '- Assertions (Response Assertion, JSON Path Assertion)\n'
              '- Listening and reporting (Aggregate Report, Response Times Over Time)\n'
              '- Running JMeter in non-GUI mode for CI: jmeter -n -t plan.jmx -l results.jtl\n\n'
              'Pro tip: Never run heavy load tests from the JMeter GUI — it skews results. '
              'Always use non-GUI mode.',
      'externalUrl': 'https://jmeter.apache.org/usermanual/get-started.html',
    },
    {
      'id': 'feed_006',
      'title': 'Core Web Vitals: What QA Engineers Need to Know',
      'description':
          'Google\'s Core Web Vitals are now a ranking factor. '
              'Learn how to measure LCP, FID, and CLS in your test suite.',
      'imageUrl': 'https://picsum.photos/seed/webvitals/400/220',
      'source': 'Google Web Fundamentals',
      'category': 'performance',
      'date': '2025-01-15',
      'content':
          'Core Web Vitals are a set of performance metrics that Google uses to evaluate '
              'user experience. As a QA engineer, you need to integrate them into your '
              'performance test suite:\n\n'
              '- LCP (Largest Contentful Paint): Should be < 2.5s. Measures load speed.\n'
              '- FID (First Input Delay): Should be < 100ms. Measures interactivity.\n'
              '- CLS (Cumulative Layout Shift): Should be < 0.1. Measures visual stability.\n\n'
              'Tools: Lighthouse (CLI + Chrome DevTools), WebPageTest, SpeedCurve.\n\n'
              'Automate Lighthouse in CI with: `npx lighthouse https://example.com --output json`',
      'externalUrl': 'https://web.dev/vitals/',
    },

    // ── Security ──────────────────────────────────────────────────────────
    {
      'id': 'feed_007',
      'title': 'OWASP Top 10 2025 — A QA Engineer\'s Perspective',
      'description':
          'The OWASP Top 10 is your security testing checklist. '
              'Learn how to test for each vulnerability class as a QA professional.',
      'imageUrl': 'https://picsum.photos/seed/owaspsec/400/220',
      'source': 'OWASP Foundation',
      'category': 'security',
      'date': '2025-03-01',
      'content':
          'The OWASP Top 10 lists the most critical web application security risks. '
              'Here\'s how to test for each as a QA engineer:\n\n'
              '1. Broken Access Control — test with different user roles; try accessing '
              'admin endpoints as a regular user.\n'
              '2. Cryptographic Failures — check that sensitive data is encrypted at rest '
              'and in transit (HTTPS enforced).\n'
              '3. Injection — test input fields with SQL/NoSQL/command injection payloads '
              '(use OWASP\'s cheat sheets).\n'
              '4. Insecure Design — review threat models and security user stories.\n'
              '5. Security Misconfiguration — check default credentials, error messages '
              'that leak stack traces, directory listing.\n'
              'Tools: OWASP ZAP, Burp Suite Community, SQLMap.',
      'externalUrl': 'https://owasp.org/www-project-top-ten/',
    },
    {
      'id': 'feed_008',
      'title': 'Security Testing with OWASP ZAP — A Practical Guide',
      'description':
          'OWASP ZAP is a free, open-source penetration testing tool. '
              'Learn how to integrate it into your CI/CD pipeline.',
      'imageUrl': 'https://picsum.photos/seed/owaspzap/400/220',
      'source': 'OWASP ZAP Blog',
      'category': 'security',
      'date': '2025-02-10',
      'content':
          'OWASP ZAP (Zed Attack Proxy) is the world\'s most widely used free '
              'web security testing tool. Here\'s how to use it:\n\n'
              'Automated Scan: Run `docker run -t owasp/zap2docker-stable zap-baseline.py '
              '-t https://your-app.com` for a quick baseline scan.\n\n'
              'GitHub Actions Integration: Use the ZAP Scan action to fail your CI build '
              'when high-severity issues are found.\n\n'
              'Spider + Active Scan: Let ZAP crawl your app, then run an active scan '
              'to test for injection, XSS, and more.\n\n'
              'False positives: Always review findings manually before raising bugs.',
      'externalUrl': 'https://www.zaproxy.org/getting-started/',
    },

    // ── Mobile Testing ────────────────────────────────────────────────────
    {
      'id': 'feed_009',
      'title': 'Appium 2.0 — The Mobile Testing Revolution',
      'description':
          'Appium 2.0 brings a plugin architecture, improved performance, '
              'and better cross-platform support for iOS and Android automation.',
      'imageUrl': 'https://picsum.photos/seed/appium2mobile/400/220',
      'source': 'Appium Community',
      'category': 'mobileTesting',
      'date': '2025-03-12',
      'content':
          'Appium 2.0 is a complete rewrite of the popular mobile automation framework. '
              'Key changes:\n\n'
              '- Plugin architecture: install only the drivers you need '
              '(UIAutomator2, XCUITest, Espresso).\n'
              '- Appium Inspector: redesigned GUI for element inspection.\n'
              '- Better support for React Native and Flutter apps.\n'
              '- Improved W3C WebDriver compliance.\n\n'
              'Getting started:\n```\nnpm install -g appium@next\nappium driver install uiautomator2\nappium driver install xcuitest\n```\n\n'
              'Flutter testing: Use the flutter driver plugin for better element finding '
              'in Flutter apps without relying on accessibility IDs.',
      'externalUrl': 'https://appium.io/docs/en/2.0/',
    },
    {
      'id': 'feed_010',
      'title': '10 Things to Test in Every Mobile App Release',
      'description':
          'A practical mobile testing checklist covering installation, '
              'network conditions, interruptions, accessibility, and more.',
      'imageUrl': 'https://picsum.photos/seed/mobilechecklist/400/220',
      'source': 'SauceLabs Blog',
      'category': 'mobileTesting',
      'date': '2025-01-28',
      'content':
          'Every mobile release should include these checks:\n\n'
              '1. Fresh install and upgrade install\n'
              '2. All supported OS versions (Android 11-14, iOS 16-18)\n'
              '3. Different screen sizes (phones, tablets, foldables)\n'
              '4. Network conditions (WiFi, 4G, 3G, airplane mode)\n'
              '5. Battery saver and low storage scenarios\n'
              '6. Interruptions (phone call, notification, app switch)\n'
              '7. Accessibility (TalkBack on Android, VoiceOver on iOS)\n'
              '8. Deep links and push notification actions\n'
              '9. App state restoration after background kill\n'
              '10. Memory leaks (use Android Profiler / Instruments)',
      'externalUrl': 'https://saucelabs.com/blog/mobile-testing-checklist',
    },

    // ── Interview Prep ────────────────────────────────────────────────────
    {
      'id': 'feed_011',
      'title': 'Top 50 QA Interview Questions for 2025',
      'description':
          'The most commonly asked software testing interview questions, '
              'with model answers for junior to senior QA engineer roles.',
      'imageUrl': 'https://picsum.photos/seed/qainterview50/400/220',
      'source': 'Testing Interviews Hub',
      'category': 'interviewPrep',
      'date': '2025-03-14',
      'content':
          'Here are the top questions you\'ll face in QA interviews:\n\n'
              '1. What is the difference between verification and validation?\n'
              'Verification = "Are we building the product right?" (reviews, inspections)\n'
              'Validation = "Are we building the right product?" (testing against requirements)\n\n'
              '2. Explain the software testing life cycle (STLC).\n'
              'STLC phases: Requirement Analysis → Test Planning → Test Case Design → '
              'Environment Setup → Test Execution → Test Closure\n\n'
              '3. What is regression testing?\n'
              'Re-executing tests after code changes to ensure existing functionality '
              'hasn\'t broken. Can be manual or automated.\n\n'
              '4. What\'s the difference between smoke and sanity testing?\n'
              'Smoke: broad, shallow — verifies build is stable enough to test.\n'
              'Sanity: narrow, deep — verifies a specific bug fix or feature works.\n\n'
              '5. What is a test pyramid?\n'
              'Unit (many, fast, cheap) → Integration (fewer) → E2E (few, slow, expensive)',
      'externalUrl': 'https://www.guru99.com/software-testing-interview-questions.html',
    },
    {
      'id': 'feed_012',
      'title': 'ISTQB Foundation Level — Complete Study Guide 2025',
      'description':
          'Everything you need to pass the ISTQB CTFL exam: syllabus overview, '
              'key terms, sample questions, and study timeline.',
      'imageUrl': 'https://picsum.photos/seed/istqbstudy/400/220',
      'source': 'ISTQB Certification Hub',
      'category': 'interviewPrep',
      'date': '2025-02-18',
      'content':
          'ISTQB CTFL (Certified Tester Foundation Level) is the most recognised '
              'software testing certification globally. Here\'s your study plan:\n\n'
              'Exam format: 40 questions, 60 minutes, 65% to pass.\n\n'
              'Key chapters to master:\n'
              '1. Fundamentals of Testing (testing principles, psychology of testing)\n'
              '2. Testing Throughout the Software Development Lifecycle\n'
              '3. Static Testing (reviews, static analysis)\n'
              '4. Test Analysis and Design (black-box, white-box techniques)\n'
              '5. Managing the Test Activities (test planning, estimation, metrics)\n'
              '6. Test Tools\n\n'
              'Recommended resources: ISTQB Glossary (free), TMap Next book, '
              'Guru99 ISTQB mock tests.',
      'externalUrl': 'https://www.istqb.org/certifications/certified-tester-foundation-level',
    },

    // ── AI Testing ────────────────────────────────────────────────────────
    {
      'id': 'feed_013',
      'title': 'Testing AI Models: Prompting and Validation Strategies',
      'description':
          'How do you test a system whose output is non-deterministic? '
              'Explore prompt engineering for QA and AI output validation techniques.',
      'imageUrl': 'https://picsum.photos/seed/aitesting2025/400/220',
      'source': 'AI QA Digest',
      'category': 'aiTesting',
      'date': '2025-03-09',
      'content':
          'Testing AI/LLM-based systems presents unique challenges. Here\'s how to approach it:\n\n'
              '1. Define expected output ranges, not exact values. Use "similarity scores" '
              '(cosine similarity, ROUGE, BLEU) to measure response quality.\n\n'
              '2. Test with boundary prompts: empty input, very long input, adversarial prompts '
              '(prompt injection, jailbreaks).\n\n'
              '3. Test for hallucinations: provide the model with known facts and verify '
              'it doesn\'t contradict them.\n\n'
              '4. Regression testing with a golden dataset: a curated set of prompt→expected_output '
              'pairs that you run against every model version.\n\n'
              '5. Latency and cost testing: LLM calls are expensive and slow. '
              'Set P95 latency budgets and monitor token consumption.\n\n'
              'Tools: LangSmith, Promptfoo, DeepEval, Ragas.',
      'externalUrl': 'https://www.deepeval.com/',
    },

    // ── Accessibility ─────────────────────────────────────────────────────
    {
      'id': 'feed_014',
      'title': 'WCAG 2.2 Accessibility Testing Checklist for QA Teams',
      'description':
          'WCAG 2.2 is now the standard. Learn the new success criteria '
              'and how to integrate accessibility testing into your sprint.',
      'imageUrl': 'https://picsum.photos/seed/wcag22qa/400/220',
      'source': 'A11Y Project',
      'category': 'accessibility',
      'date': '2025-02-25',
      'content':
          'WCAG 2.2 added 9 new success criteria over 2.1. Here\'s what QA teams need to know:\n\n'
              'New in 2.2:\n'
              '- 2.4.11 Focus Not Obscured: focused elements must be visible.\n'
              '- 2.5.7 Dragging Movements: provide an alternative to drag-and-drop.\n'
              '- 2.5.8 Target Size (Minimum): interactive targets must be at least 24x24px.\n'
              '- 3.2.6 Consistent Help: help links must appear in the same location.\n'
              '- 3.3.7 Redundant Entry: don\'t ask users to re-enter information.\n\n'
              'Tools: axe DevTools (browser extension), NVDA + Firefox (screen reader), '
              'Colour Contrast Analyser, WAVE.\n\n'
              'Quick win: Add axe to your Playwright/Cypress tests with `@axe-core/playwright`.',
      'externalUrl': 'https://www.w3.org/TR/WCAG22/',
    },
    {
      'id': 'feed_015',
      'title': 'The Shift-Left Testing Manifesto — Why Test Earlier',
      'description':
          'Shift-left isn\'t just a buzzword. Learn how moving testing '
              'earlier in the SDLC reduces bugs, cost, and delivery time.',
      'imageUrl': 'https://picsum.photos/seed/shiftlefttest/400/220',
      'source': 'Agile Testing Alliance',
      'category': 'automation',
      'date': '2025-03-03',
      'content':
          'The "shift-left" movement advocates for testing earlier and more often in the '
              'software development lifecycle. The core insight: the cost of fixing a bug '
              'increases exponentially the later it is found.\n\n'
              'Practical shift-left actions:\n'
              '1. Three Amigos: Developer + QA + BA review requirements together before '
              'a single line of code is written.\n'
              '2. BDD: Write Gherkin scenarios before implementation. '
              'Tools: Cucumber, SpecFlow, Behave.\n'
              '3. TDD: Write unit tests before the code. Red → Green → Refactor.\n'
              '4. Static analysis in the IDE: Catch bugs before they\'re even run.\n'
              '5. PR-level automation: Run unit + integration tests on every pull request.\n\n'
              'Result: fewer bugs in production, faster releases, happier developers.',
      'externalUrl': 'https://www.agilealliance.org/glossary/shift-left-testing/',
    },
  ];
}
