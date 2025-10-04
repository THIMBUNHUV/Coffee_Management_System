import 'package:flutter/material.dart';
import 'package:vee_zee_coffee/config/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToLogin();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _colorAnimation =
        ColorTween(
          begin: const Color(0xFF4A90E2).withOpacity(0.7),
          end: const Color(0xFF4A90E2),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );

    _controller.forward();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF8F9FA),
              const Color(0xFFE3F2FD),
              const Color(0xFFBBDEFB),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Coffee cup with steam animation
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none, // Important: Allow steam to overflow
                    children: [
                      // Coffee icon container
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF4A90E2),
                                const Color(0xFF5D9CEC),
                                const Color(0xFF6EA8FF),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4A90E2).withOpacity(0.4),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.coffee,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Steam animation - positioned above the coffee icon
                      if (_controller.status == AnimationStatus.completed)
                        Positioned(
                          top: -60, // Moved higher to avoid overlap
                          child: _SteamAnimation(controller: _controller),
                        ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // Brand name with slide and fade animation
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Vee Zee',
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4A90E2),
                          fontFamily: 'Poppins',
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              blurRadius: 15,
                              color: const Color(0xFF4A90E2).withOpacity(0.3),
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Coffee',
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4A90E2),
                          fontFamily: 'Poppins',
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              blurRadius: 15,
                              color: const Color(0xFF4A90E2).withOpacity(0.3),
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tagline
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Brewing Excellence',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF7F8C8D),
                        fontFamily: 'Inter',
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 120,
                      child: LinearProgressIndicator(
                        backgroundColor: const Color(0xFFE3F2FD),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFF4A90E2),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Loading text
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Preparing your coffee experience...',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF7F8C8D),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SteamAnimation extends StatefulWidget {
  final AnimationController controller;

  const _SteamAnimation({required this.controller});

  @override
  State<_SteamAnimation> createState() => _SteamAnimationState();
}

class _SteamAnimationState extends State<_SteamAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _steamController;
  late Animation<double> _steamOpacity;
  late Animation<double> _steamHeight;

  @override
  void initState() {
    super.initState();
    _steamController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _steamOpacity = Tween<double>(begin: 0.2, end: 0.7).animate(
      CurvedAnimation(parent: _steamController, curve: Curves.easeInOutCubic),
    );

    _steamHeight = Tween<double>(begin: 25, end: 50).animate(
      CurvedAnimation(parent: _steamController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _steamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _steamController,
      builder: (context, child) {
        return Opacity(
          opacity: _steamOpacity.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSteamLine(0.0),
              const SizedBox(width: 6),
              _buildSteamLine(0.2),
              const SizedBox(width: 6),
              _buildSteamLine(0.4),
              const SizedBox(width: 6),
              _buildSteamLine(0.6),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSteamLine(double delay) {
    return AnimatedBuilder(
      animation: _steamController,
      builder: (context, child) {
        final adjustedValue = (_steamController.value + delay) % 1.0;
        final height = _steamHeight.value * (0.5 + adjustedValue * 0.5);
        final opacity = 0.8 * adjustedValue;

        return Container(
          width: 6, // Reduced width for better appearance
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(opacity),
                Colors.white.withOpacity(opacity * 0.5),
                Colors.white.withOpacity(opacity * 0.1),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(3), // Adjusted border radius
          ),
        );
      },
    );
  }
}
