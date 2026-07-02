import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:plantie/models/user/user_model.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/app_colors.dart';
import '../../generated/l10n.dart';
import '../../shared/network/remote/supabase_service.dart';
import '../../shared/network/remote/supabase_auth_service.dart';
import '../UserView/user_profile_screen.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _results = [];
  bool _isSearching = false;
  bool _isOffline = false;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (query.trim().isEmpty) {
        setState(() {
          _results = [];
          _isSearching = false;
          _isOffline = false;
        });
        return;
      }
      setState(() => _isSearching = true);

      final authService = SupabaseAuthService();
      final hasInternet = await authService.isConnectedFast();
      if (!hasInternet) {
        if (mounted) {
          setState(() {
            _isSearching = false;
            _isOffline = true;
          });
        }
        return;
      }

      final users = await supabaseService.searchUsers(query);
      if (mounted) {
        setState(() {
          _results = users;
          _isSearching = false;
          _isOffline = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = S.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(s.searchUsers),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: s.searchUsersHint,
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(context, isDark),
    );
  }

  Widget _buildBody(BuildContext context, bool isDark) {
    final s = S.of(context);

    if (_isOffline) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey[500]),
              const SizedBox(height: 16),
              Text(
                s.noInternet,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                s.checkNetwork,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Retry the current search
                  _onSearchChanged(_searchController.text);
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(s.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? s.searchUsersEmpty
                  : s.noUsersFound,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final user = _results[index];
        final isCurrentUser = user.id == CurrentUser.user.id;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.2),
            backgroundImage: (user.image != null && user.image!.isNotEmpty)
                ? CachedNetworkImageProvider(user.image!)
                : null,
            child: (user.image == null || user.image!.isEmpty)
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          title: Text(user.name),
          subtitle: user.bio != null && user.bio!.isNotEmpty
              ? Text(user.bio!, maxLines: 1, overflow: TextOverflow.ellipsis)
              : null,
          trailing: isCurrentUser
              ? const SizedBox()
              : ElevatedButton(
            onPressed: () {
              navigateTo(
                context,
                UserProfileScreen(
                  userId: user.id,
                  userName: user.name,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 32),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(s.viewProfile, style: const TextStyle(fontSize: 12)),
          ),
          onTap: () {
            navigateTo(
              context,
              UserProfileScreen(
                userId: user.id,
                userName: user.name,
              ),
            );
          },
        );
      },
    );
  }
}