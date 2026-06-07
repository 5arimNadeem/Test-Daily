// Feed source configuration for Test Daily.
//
// HOW TO ADD A NEW RSS FEED:
//   Add a new RssFeedSource entry to kRssFeeds below.
//
// HOW TO ADD A NEW YOUTUBE CHANNEL:
//   1. Go to the channel on YouTube.
//   2. Click "More" → "Share" → "Copy channel ID"  (or check the URL path).
//   3. Add a YoutubeChannelConfig entry to kYoutubeChannels below.

/// A configured RSS feed source.
class RssFeedSource {
  final String url;
  final String sourceName;
  final String defaultCategory;

  const RssFeedSource({
    required this.url,
    required this.sourceName,
    required this.defaultCategory,
  });
}

/// A configured YouTube channel.
class YoutubeChannelConfig {
  final String channelId;
  final String channelName;
  final String defaultCategory;

  const YoutubeChannelConfig({
    required this.channelId,
    required this.channelName,
    required this.defaultCategory,
  });
}

/// Active RSS feeds — add new entries here to pull in more blogs.
const List<RssFeedSource> kRssFeeds = [
  RssFeedSource(
    url: 'https://www.lambdatest.com/blog/feed/',
    sourceName: 'LambdaTest Blog',
    defaultCategory: 'automation',
  ),
  RssFeedSource(
    url: 'https://www.ministryoftesting.com/feed',
    sourceName: 'Ministry of Testing',
    defaultCategory: 'automation',
  ),
  RssFeedSource(
    url: 'https://www.softwaretestinghelp.com/feed/',
    sourceName: 'Software Testing Help',
    defaultCategory: 'automation',
  ),
  RssFeedSource(
    url: 'https://saucelabs.com/blog/feed',
    sourceName: 'Sauce Labs Blog',
    defaultCategory: 'automation',
  ),
];

/// Active YouTube channels — add new entries here to pull in more channels.
///
/// IMPORTANT: Verify channel IDs are current before release.
/// To find a channel ID: visit the channel page → View Source → search for "channelId".
const List<YoutubeChannelConfig> kYoutubeChannels = [
  YoutubeChannelConfig(
    channelId: 'UCTt7pyY-o0eltq14glaG5dg',
    channelName: 'Automation Step by Step',
    defaultCategory: 'automation',
  ),
  YoutubeChannelConfig(
    channelId: 'UCXJKOPxx4O1f63nnfsoiEug',
    channelName: 'Naveen AutomationLabs',
    defaultCategory: 'automation',
  ),
  YoutubeChannelConfig(
    channelId: 'UCgx5SDcUQWCQ_1CNneQzCRw',
    channelName: 'Rahul Shetty Academy',
    defaultCategory: 'automation',
  ),
  YoutubeChannelConfig(
    channelId: 'UCCymWVaTozpEng_ep0mdUyw',
    channelName: 'LambdaTest',
    defaultCategory: 'automation',
  ),
];
