import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vee_zee_coffee/config/routes.dart';
import 'package:provider/provider.dart';
import 'package:vee_zee_coffee/providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _launchFacebook() async {
    final Uri url = Uri.parse('https://www.facebook.com/share/1Gac12WeZ1/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch Facebook');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userType = authProvider.userType;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF8F9FA),
              const Color(0xFFF8F9FA),
              const Color(0xFFF8F9FA),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header with centered coffee icon
            Container(
              height: 220,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A90E2), // Primary blue
                    Color(0xFF5D9CEC), // Light blue
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Coffee Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.coffee,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Brand Name
                  const Text(
                    'Vee Zee Coffee',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Tagline
                  Text(
                    'Brewing Excellence',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),

            // About Us Section
            _buildSection(
              title: 'About Us',
              icon: Icons.info_outline,
              children: [
                _buildInfoCard(
                  title: 'Our Purpose',
                  description:
                      'Creating exceptional coffee experiences while empowering our community through quality service and sustainable practices.',
                  color: const Color(0xFF4A90E2),
                ),
                _buildInfoCard(
                  title: 'Our Mission',
                  description:
                      'Serving the finest coffee while providing outstanding service to customers, meaningful opportunities for employees, and successful partnerships for owners.',
                  color: const Color(0xFF27AE60),
                ),
              ],
            ),

            // Services Section
            _buildSection(
              title: 'What We Offer',
              icon: Icons.card_giftcard,
              children: [
                if (userType == 'customer') ...[
                  _buildServiceItem(
                    '☕ Premium Coffee',
                    'Handcrafted beverages using finest beans',
                    const Color(0xFF4A90E2),
                  ),
                  _buildServiceItem(
                    '🏠 Cozy Atmosphere',
                    'Perfect environment for work & relaxation',
                    const Color(0xFF50E3C2),
                  ),
                  _buildServiceItem(
                    '🚚 Fast Delivery',
                    'Quick and reliable delivery service',
                    const Color(0xFF27AE60),
                  ),
                  _buildServiceItem(
                    '🎯 Loyalty Rewards',
                    'Earn points with every purchase',
                    const Color(0xFF9B59B6),
                  ),
                ] else if (userType == 'employee') ...[
                  _buildServiceItem(
                    '💼 Career Growth',
                    'Professional development opportunities',
                    const Color(0xFF4A90E2),
                  ),
                  _buildServiceItem(
                    '🤝 Team Support',
                    'Collaborative work environment',
                    const Color(0xFF50E3C2),
                  ),
                  _buildServiceItem(
                    '📚 Training',
                    'Continuous learning & skill development',
                    const Color(0xFF9B59B6),
                  ),
                  _buildServiceItem(
                    '⭐ Recognition',
                    'Employee appreciation programs',
                    const Color(0xFFF39C12),
                  ),
                ] else if (userType == 'owner') ...[
                  _buildServiceItem(
                    '📊 Analytics',
                    'Detailed business insights & reports',
                    const Color(0xFF4A90E2),
                  ),
                  _buildServiceItem(
                    '👥 Team Management',
                    'Comprehensive staff management tools',
                    const Color(0xFF50E3C2),
                  ),
                  _buildServiceItem(
                    '📈 Growth Tools',
                    'Resources to expand your business',
                    const Color(0xFF27AE60),
                  ),
                  _buildServiceItem(
                    '🔧 Support',
                    'Dedicated owner support system',
                    const Color(0xFFE74C3C),
                  ),
                ],
              ],
            ),

            // Team Members Section
            _buildSection(
              title: 'Our Team',
              icon: Icons.people_outline,
              children: [_buildTeamGrid()],
            ),

            // Contact & Social Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF4A90E2).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.thumb_up_alt,
                    size: 32,
                    color: Color(0xFF4A90E2),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Connect With Us',
                    style: TextStyle(
                      color: Color(0xFF2C3E50),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Follow for updates and special offers',
                    style: TextStyle(
                      color: const Color(0xFF7F8C8D),
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _launchFacebook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.facebook, size: 20),
                      label: const Text(
                        'Follow on Facebook',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Logout Button
            if (userType != null)
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      authProvider.logout();
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE74C3C),
                      side: const BorderSide(color: Color(0xFFE74C3C)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF4A90E2)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF2C3E50),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              color: const Color(0xFF7F8C8D),
              fontSize: 14,
              fontFamily: 'Inter',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamGrid() {
    final teamMembers = [
      {
        'name': 'Thim Bunhuv',
        'image': 'assets/images/bunhuv.jpg',
        'telegram': 'https://t.me/Vee_Zee_Huv',
      },
      {
        'name': 'Thong Sokchea',
        'image': 'assets/images/sokchea.jpg',
        'telegram': 'https://t.me/CHea_New',
      },
      {
        'name': 'Veng Seyha',
        'image': 'assets/images/seyha.jpg',
        'telegram': 'https://t.me/yourTelegram3',
      },
      {
        'name': 'Pisal Somman',
        'image': 'assets/images/pisal.jpg',
        'telegram': 'https://t.me/Nang_Nezha',
      },
      {
        'name': 'Tieng Udam',
        'image': 'assets/images/udam.jpg',
        'telegram': 'https://t.me/Domtzy123',
      },
      {
        'name': 'You Visal',
        'image': 'assets/images/visal.jpg',
        'telegram': 'https://t.me/yourTelegram6',
      },
    ];

    final colors = [
      const Color(0xFF4A90E2),
      const Color(0xFF50E3C2),
      const Color(0xFF9B59B6),
      const Color(0xFF27AE60),
      const Color(0xFFF39C12),
      const Color(0xFFE74C3C),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemCount: teamMembers.length,
      itemBuilder: (context, index) {
        final member = teamMembers[index];
        final color = colors[index % colors.length];

        return GestureDetector(
          onTap: () {
            _showMemberDialog(
              context,
              member['name']!,
              member['image']!,
              color,
              member['telegram']!,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    member['image']!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  member['name']!,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMemberDialog(
    BuildContext context,
    String memberName,
    String imagePath,
    Color color,
    String telegramLink,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  imagePath,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                memberName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Team Member',
                style: TextStyle(
                  color: const Color(0xFF7F8C8D),
                  fontSize: 13,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Contributing to Vee Zee Coffee\'s mission of serving exceptional coffee experiences to our community.',
                style: const TextStyle(
                  color: Color(0xFF2C3E50),
                  fontSize: 13,
                  fontFamily: 'Inter',
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse(telegramLink);
                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw Exception("Could not launch $telegramLink");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.telegram,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text("Contact on Telegram"),
                ),
              ),
              const SizedBox(height: 8),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(String title, String description, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF7F8C8D),
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    String title,
    IconData icon,
    VoidCallback onTap,
    Color color,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
