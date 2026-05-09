import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../app/app_shell.dart';
import '../../../../core/constants/prefs_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/prefs_manager.dart';
import '../../../../core/theme/app_theme_extensions.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final YoutubeExplode _yt = YoutubeExplode();
  final OnboardingCubit _onboardingCubit = OnboardingCubit();
  final ValueNotifier<VideoPlayerController?> _videoController = ValueNotifier<VideoPlayerController?>(null);

  int _loadingToken = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      source: 'https://www.youtube.com/watch?v=nAe82r8C9_4',
      titleEn: 'Unlimited Movies Experience',
      subtitleEn: 'Get ready to immerse yourself in cinematic stories.',
      titleId: 'Pengalaman Film Tanpa Batas',
      subtitleId: 'Siap menikmati cerita sinematik favoritmu setiap hari.',
    ),
    _OnboardingItem(
      source: 'https://www.youtube.com/watch?v=8Lk-9a1WMNM',
      titleEn: 'Watch Trailers and Discover',
      subtitleEn: 'Swipe through highlights and find your next watch fast.',
      titleId: 'Lihat Trailer dan Jelajahi',
      subtitleId: 'Geser highlight film dan temukan tontonan berikutnya dengan cepat.',
    ),
    _OnboardingItem(
      source: 'https://www.youtube.com/watch?v=JXPb0FF1kS4',
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
    final currentPage = _onboardingCubit.state.currentPage;
    final isLast = currentPage == _items.length - 1;
    if (isLast) {
      await _finishOnboarding();
      return;
    }
    await _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadVideoByIndex(0);
    });
  }

  bool _isYouTubeUrl(String source) {
    final uri = Uri.tryParse(source);
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    return host.contains('youtube.com') || host.contains('youtu.be');
  }

  Future<String?> _resolvePlayableUrl(String source) async {
    if (!_isYouTubeUrl(source)) return source;

    final videoId = VideoId.parseVideoId(source);
    if (videoId == null) return null;

    final manifest = await _yt.videos.streamsClient.getManifest(videoId);
    final stream = manifest.muxed.withHighestBitrate();
    return stream.url.toString();
  }

  Future<void> _loadVideoByIndex(int index) async {
    final token = ++_loadingToken;
    final source = _items[index].source;

    try {
      final playableUrl = await _resolvePlayableUrl(source);
      if (!mounted || token != _loadingToken || playableUrl == null) return;

      final nextController = VideoPlayerController.networkUrl(Uri.parse(playableUrl));
      await nextController.initialize();
      await nextController.setLooping(true);
      await nextController.setVolume(0);
      await nextController.play();

      final oldController = _videoController.value;
      _videoController.value = nextController;
      await oldController?.dispose();
    } catch (_) {
      if (!mounted || token != _loadingToken) return;
      await _videoController.value?.dispose();
      _videoController.value = null;
    }
  }

  @override
  void dispose() {
    _loadingToken++;
    _videoController.value?.dispose();
    _videoController.dispose();
    _onboardingCubit.close();
    _yt.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isId = localeCode == 'id';
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppCustomColors>()!;

    return BlocProvider.value(
      value: _onboardingCubit,
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final currentPage = state.currentPage;
          final isLast = currentPage == _items.length - 1;

          return Scaffold(
            backgroundColor: colors.surface,
            body: Stack(
              children: [
                ValueListenableBuilder<VideoPlayerController?>(
                  valueListenable: _videoController,
                  builder: (context, controller, _) => _OnboardingVideoBackground(controller: controller),
                ),
                PageView.builder(
                  controller: _pageController,
                  itemCount: _items.length,
                  onPageChanged: (value) {
                    context.read<OnboardingCubit>().onPageChanged(value);
                    _loadVideoByIndex(value);
                  },
                  itemBuilder: (context, index) => const SizedBox.expand(),
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
                          isId ? _items[currentPage].titleId : _items[currentPage].titleEn,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineLarge?.copyWith(
                            color: customColors.onImageText,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          isId ? _items[currentPage].subtitleId : _items[currentPage].subtitleEn,
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium?.copyWith(
                            color: customColors.onImageSubtleText,
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
                              width: currentPage == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: currentPage == index ? colors.primary : customColors.indicatorInactive,
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
        },
      ),
    );
  }
}

class _OnboardingVideoBackground extends StatelessWidget {
  final VideoPlayerController? controller;

  const _OnboardingVideoBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    final videoController = controller;
    if (videoController == null || !videoController.value.isInitialized) {
      return const ColoredBox(color: Colors.black);
    }

    return IgnorePointer(
      child: ClipRect(
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: videoController.value.size.width,
              height: videoController.value.size.height,
              child: VideoPlayer(videoController),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final String source;
  final String titleEn;
  final String subtitleEn;
  final String titleId;
  final String subtitleId;

  const _OnboardingItem({
    required this.source,
    required this.titleEn,
    required this.subtitleEn,
    required this.titleId,
    required this.subtitleId,
  });
}
