import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import 'package:law_library/models/user.dart';
import 'package:law_library/services/api_service.dart';
import 'package:law_library/utils/encryption.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final ApiService _apiService = ApiService();
  List<User> _users = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final users = await _apiService.getUsers();
      if (mounted) setState(() { _users = users; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = 'Failed to load users. Check your connection.'; _loading = false; });
    }
  }

  int get _adminCount => _users.where((u) => u.role == 'admin').length;

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
    ));
  }

  // ── Create user dialog ──────────────────────────────────────────
  Future<void> _showCreateDialog() async {
    final usernameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    String role = 'officer';
    bool submitting = false;
    bool passwordVisible = false;

    await showDialog(
      context: context,
      barrierDismissible: !submitting,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Create New User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: usernameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'e.g. officer_ali',
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordCtrl,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Min. 6 characters',
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setDialogState(() => passwordVisible = !passwordVisible),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                Text('Role', style: Theme.of(ctx).textTheme.labelMedium),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'officer', label: Text('Officer')),
                    ButtonSegment(value: 'admin', label: Text('Admin')),
                  ],
                  selected: {role},
                  onSelectionChanged: (s) =>
                      setDialogState(() => role = s.first),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: submitting ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: submitting
                  ? null
                  : () async {
                      final username = usernameCtrl.text.trim();
                      final password = passwordCtrl.text;
                      if (username.isEmpty) {
                        _showSnack('Username is required', isError: true);
                        return;
                      }
                      if (password.length < 6) {
                        _showSnack('Password must be at least 6 characters',
                            isError: true);
                        return;
                      }
                      setDialogState(() => submitting = true);
                      try {
                        final hashed = EncryptionUtil.hashPassword(password);
                        final res = await _apiService.createUser(
                            username, hashed, role);
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (res['success'] == true) {
                          _showSnack('User created successfully');
                          _fetchUsers();
                        } else {
                          _showSnack(
                              res['message'] ?? 'Failed to create user',
                              isError: true);
                        }
                      } catch (_) {
                        setDialogState(() => submitting = false);
                        _showSnack('Failed to create user', isError: true);
                      }
                    },
              child: submitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reset password dialog ───────────────────────────────────────
  Future<void> _showResetDialog(User user) async {
    final passwordCtrl = TextEditingController();
    bool submitting = false;
    bool passwordVisible = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set a new password for ${user.username}',
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Theme.of(ctx).colorScheme.secondary,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordCtrl,
                obscureText: !passwordVisible,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  hintText: 'Min. 6 characters',
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () =>
                        setDialogState(() => passwordVisible = !passwordVisible),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: submitting ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: submitting
                  ? null
                  : () async {
                      final password = passwordCtrl.text;
                      if (password.length < 6) {
                        _showSnack('Password must be at least 6 characters',
                            isError: true);
                        return;
                      }
                      setDialogState(() => submitting = true);
                      try {
                        final hashed = EncryptionUtil.hashPassword(password);
                        final res = await _apiService.resetUserPassword(
                            user.username, hashed);
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (res['success'] == true) {
                          _showSnack('Password reset successfully');
                        } else {
                          _showSnack(
                              res['message'] ?? 'Failed to reset password',
                              isError: true);
                        }
                      } catch (_) {
                        setDialogState(() => submitting = false);
                        _showSnack('Failed to reset password', isError: true);
                      }
                    },
              child: submitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Delete confirmation ─────────────────────────────────────────
  Future<void> _showDeleteDialog(User user) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete User'),
            content: Text(
                'Are you sure you want to delete ${user.username}? This cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    try {
      final res = await _apiService.deleteUser(user.username);
      if (res['success'] == true) {
        _showSnack('User deleted');
        _fetchUsers();
      } else {
        _showSnack(res['message'] ?? 'Failed to delete user', isError: true);
      }
    } catch (_) {
      _showSnack('Failed to delete user', isError: true);
    }
  }

  // ── Build ───────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48,
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.6)),
                      const SizedBox(height: 12),
                      Text(_error!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton(
                          onPressed: _fetchUsers, child: const Text('Retry')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchUsers,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          '${_users.length} account${_users.length != 1 ? 's' : ''} · $_adminCount admin${_adminCount != 1 ? 's' : ''}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ).animate().fadeIn(duration: 300.ms),

                      // User list
                      Expanded(
                        child: _users.isEmpty
                            ? Center(
                                child: Text(
                                  'No users found',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
                                itemCount: _users.length,
                                itemBuilder: (context, index) {
                                  final user = _users[index];
                                  final isLastAdmin =
                                      user.role == 'admin' && _adminCount <= 1;
                                  String createdDate = '';
                                  if (user.createdAt != null) {
                                    try {
                                      createdDate = DateFormat('d MMM y').format(
                                          DateTime.parse(user.createdAt!));
                                    } catch (_) {
                                      createdDate = user.createdAt!;
                                    }
                                  }

                                  return Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 12, 8, 12),
                                      child: Row(
                                        children: [
                                          // Avatar
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: user.role == 'admin'
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .surfaceContainerHighest,
                                            child: Icon(
                                              user.role == 'admin'
                                                  ? Icons.shield_outlined
                                                  : Icons.person_outline,
                                              size: 20,
                                              color: user.role == 'admin'
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          // Username + role badge + date
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        user.username,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: user.role ==
                                                                'admin'
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primaryContainer
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .surfaceContainerHighest,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                      ),
                                                      child: Text(
                                                        user.role == 'admin'
                                                            ? 'Admin'
                                                            : 'Officer',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall
                                                            ?.copyWith(
                                                              color: user.role ==
                                                                      'admin'
                                                                  ? Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimaryContainer
                                                                  : Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onSurfaceVariant,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (createdDate.isNotEmpty) ...[
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    createdDate,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall
                                                        ?.copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .secondary,
                                                        ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),

                                          // Reset password button
                                          IconButton(
                                            icon: const Icon(
                                                Icons.lock_reset_outlined,
                                                size: 20),
                                            tooltip: 'Reset Password',
                                            onPressed: () =>
                                                _showResetDialog(user),
                                          ),

                                          // Delete button
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              size: 20,
                                              color: isLastAdmin
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.3)
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                            ),
                                            tooltip: isLastAdmin
                                                ? 'Cannot delete last admin'
                                                : 'Delete',
                                            onPressed: isLastAdmin
                                                ? null
                                                : () =>
                                                    _showDeleteDialog(user),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).animate().fadeIn(
                                        duration: 300.ms,
                                        delay: Duration(
                                            milliseconds: index * 40),
                                      );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Add User'),
        onPressed: _showCreateDialog,
      ),
    );
  }
}
