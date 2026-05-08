import 'package:flutter/material.dart';

import '../../../../app/app_shell.dart';
import '../../../../core/constants/prefs_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/prefs_manager.dart';
import '../../../../core/theme/app_theme_extensions.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      youtubeUrl: 'https://www.youtube.com/watch?v=EXeTwQWrcwY',
      titleEn: 'Unlimited Movies Experience',
      subtitleEn: 'Get ready to immerse yourself in cinematic stories.',
      titleId: 'Pengalaman Film Tanpa Batas',
      subtitleId: 'Siap menikmati cerita sinematik favoritmu setiap hari.',
    ),
    _OnboardingItem(
      youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      titleEn: 'Watch Trailers and Discover',
      subtitleEn: 'Swipe through highlights and find your next watch fast.',
      titleId: 'Lihat Trailer dan Jelajahi',
      subtitleId: 'Geser highlight film dan temukan tontonan berikutnya dengan cepat.',
    ),
    _OnboardingItem(
      youtubeUrl: 'https://www.youtube.com/watch?v=ysz5S6PUM-U',
      titleEn: 'Build Your Favorites List',
      subtitleEn: 'Save what you love and continue anytime from home.',
      titleId: 'Bangun Daftar Favoritmu',
      subtitleId: 'Simpan film favorit dan lanjutkan kapan saja dari beranda.',
    ),
  ];

  Future<void> _finishOnboarding() async {
    await sl<PrefsManager>().setBool(PrefsKeys.onboardingSeen, true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AppShell()));
  }

  Future<void> _onNextTap() async {
    final isLast = _currentPage == _items.length - 1;
    if (isLast) {
      await _finishOnboarding();
      return;
    }
    await _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isId = localeCode == 'id';
    final isLast = _currentPage == _items.length - 1;
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppCustomColors>()!;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemBuilder: (context, index) => _OnboardingVideoBackground(youtubeUrl: _items[index].youtubeUrl),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    customColors.imageOverlayTop,
                    customColors.imageOverlayTop,
                    customColors.imageOverlayBottom,
                  ],
                  stops: const [0.1, 0.5, 1],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _finishOnboarding,
                      child: Text(isId ? 'Lewati' : 'Skip'),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    isId ? _items[_currentPage].titleId : _items[_currentPage].titleEn,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge?.copyWith(
                      color: customColors.onImageText,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isId ? _items[_currentPage].subtitleId : _items[_currentPage].subtitleEn,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      color: customColors.onImageSubtleText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _items[_currentPage].youtubeUrl,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: customColors.onImageSubtleText,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _items.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? colors.primary : customColors.indicatorInactive,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _onNextTap,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      isLast ? (isId ? 'Mulai' : 'Get Started') : 'Next',
                      style: textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingVideoBackground extends StatefulWidget {
  final String youtubeUrl;

  const _OnboardingVideoBackground({required this.youtubeUrl});

  @override
  State<_OnboardingVideoBackground> createState() => _OnboardingVideoBackgroundState();
}

class _OnboardingVideoBackgroundState extends State<_OnboardingVideoBackground> {
  String get _thumbUrl {
    final id = Uri.tryParse(widget.youtubeUrl)?.queryParameters['v'] ?? '';
    return 'https://img.youtube.com/vi/$id/maxresdefault.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.network(
        _thumbUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerHighest);
        },
      ),
    );
  }
}

class _OnboardingItem {
  final String youtubeUrl;
  final String titleEn;
  final String subtitleEn;
  final String titleId;
  final String subtitleId;

  const _OnboardingItem({
    required this.youtubeUrl,
    required this.titleEn,
    required this.subtitleEn,
    required this.titleId,
    required this.subtitleId,
  });
}
