'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import type { User, UserRole } from '@/types';
import { getUsers, createUser, deleteUser, resetUserPassword } from '@/lib/api';
import { getSession, hashPassword } from '@/lib/auth';

type Modal =
  | { type: 'create' }
  | { type: 'delete'; user: User }
  | { type: 'reset'; user: User }
  | null;

export default function AdminUsersPage() {
  const router = useRouter();
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [modal, setModal] = useState<Modal>(null);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);

  // Create form state
  const [newUsername, setNewUsername] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [newRole, setNewRole] = useState<UserRole>('officer');

  // Reset password state
  const [resetPassword, setResetPassword] = useState('');

  const [submitting, setSubmitting] = useState(false);

  // Auth guard — admin only
  useEffect(() => {
    const session = getSession();
    if (!session) { router.replace('/admin'); return; }
    if (session.isAdmin !== 1) { router.replace('/'); return; }
  }, [router]);

  useEffect(() => {
    fetchUsers();
  }, []);

  async function fetchUsers() {
    setLoading(true);
    try {
      const data = await getUsers();
      setUsers(data);
    } catch {
      showToast('error', 'Failed to load users');
    } finally {
      setLoading(false);
    }
  }

  function showToast(type: 'success' | 'error', msg: string) {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3500);
  }

  function closeModal() {
    setModal(null);
    setNewUsername('');
    setNewPassword('');
    setNewRole('officer');
    setResetPassword('');
  }

  async function handleCreate(e: React.FormEvent) {
    e.preventDefault();
    if (!newUsername.trim() || !newPassword) return;
    setSubmitting(true);
    try {
      const hashed = await hashPassword(newPassword);
      const res = await createUser(newUsername.trim(), hashed, newRole);
      if (res.success) {
        showToast('success', 'User created successfully');
        closeModal();
        fetchUsers();
      } else {
        showToast('error', res.message);
      }
    } catch {
      showToast('error', 'Failed to create user');
    } finally {
      setSubmitting(false);
    }
  }

  async function handleDelete() {
    if (modal?.type !== 'delete') return;
    setSubmitting(true);
    try {
      const res = await deleteUser(modal.user.Username);
      if (res.success) {
        showToast('success', 'User deleted');
        closeModal();
        fetchUsers();
      } else {
        showToast('error', res.message);
      }
    } catch {
      showToast('error', 'Failed to delete user');
    } finally {
      setSubmitting(false);
    }
  }

  async function handleResetPassword(e: React.FormEvent) {
    e.preventDefault();
    if (modal?.type !== 'reset' || !resetPassword) return;
    setSubmitting(true);
    try {
      const hashed = await hashPassword(resetPassword);
      const res = await resetUserPassword(modal.user.Username, hashed);
      if (res.success) {
        showToast('success', 'Password reset successfully');
        closeModal();
      } else {
        showToast('error', res.message);
      }
    } catch {
      showToast('error', 'Failed to reset password');
    } finally {
      setSubmitting(false);
    }
  }

  const adminCount = users.filter(u => u.Role === 'admin').length;

  return (
    <div className="p-6 max-w-4xl mx-auto">
      {/* Toast */}
      {toast && (
        <div className={`fixed top-5 right-5 z-50 px-4 py-3 rounded-lg shadow-lg text-sm font-medium text-white transition-all ${
          toast.type === 'success' ? 'bg-green-600' : 'bg-red-600'
        }`}>
          {toast.msg}
        </div>
      )}

      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold">Manage Users</h1>
          <p className="text-sm mt-0.5" style={{ color: 'var(--muted)' }}>
            {users.length} account{users.length !== 1 ? 's' : ''} · {adminCount} admin{adminCount !== 1 ? 's' : ''}
          </p>
        </div>
        <button
          onClick={() => setModal({ type: 'create' })}
          className="flex items-center gap-2 px-4 py-2 bg-blue-900 text-white text-sm font-medium rounded-lg hover:bg-blue-800 transition-colors"
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4">
            <path d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z" />
          </svg>
          New User
        </button>
      </div>

      {/* Table */}
      <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
        {loading ? (
          <div className="p-12 text-center text-sm" style={{ color: 'var(--muted)' }}>Loading users…</div>
        ) : users.length === 0 ? (
          <div className="p-12 text-center text-sm" style={{ color: 'var(--muted)' }}>No users found</div>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b text-xs uppercase tracking-wider" style={{ borderColor: 'var(--border)', color: 'var(--muted)' }}>
                <th className="px-4 py-3 text-left">Username</th>
                <th className="px-4 py-3 text-left">Role</th>
                <th className="px-4 py-3 text-left">Created</th>
                <th className="px-4 py-3 text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              {users.map((user) => (
                <tr key={user.Username} className="border-b last:border-b-0 transition-colors hover:bg-black/5 dark:hover:bg-white/5" style={{ borderColor: 'var(--border)' }}>
                  <td className="px-4 py-3 font-medium">{user.Username}</td>
                  <td className="px-4 py-3">
                    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                      user.Role === 'admin'
                        ? 'bg-blue-100 text-blue-800 dark:bg-blue-900/40 dark:text-blue-300'
                        : 'bg-gray-100 text-gray-700 dark:bg-white/10 dark:text-gray-300'
                    }`}>
                      {user.Role === 'admin' ? 'Admin' : 'Officer'}
                    </span>
                  </td>
                  <td className="px-4 py-3" style={{ color: 'var(--muted)' }}>
                    {new Date(user.CreatedAt).toLocaleDateString()}
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex items-center justify-end gap-2">
                      <button
                        onClick={() => { setModal({ type: 'reset', user }); }}
                        className="px-3 py-1.5 text-xs font-medium rounded-lg border transition-colors hover:bg-black/5 dark:hover:bg-white/10"
                        style={{ borderColor: 'var(--border)', color: 'var(--muted)' }}
                      >
                        Reset Password
                      </button>
                      <button
                        onClick={() => setModal({ type: 'delete', user })}
                        disabled={user.Role === 'admin' && adminCount <= 1}
                        className="px-3 py-1.5 text-xs font-medium rounded-lg border border-red-200 dark:border-red-800 text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors disabled:opacity-40 disabled:cursor-not-allowed"
                      >
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* Create User Modal */}
      {modal?.type === 'create' && (
        <div className="fixed inset-0 z-40 flex items-center justify-center p-4 bg-black/50">
          <div className="w-full max-w-md rounded-2xl shadow-xl p-6" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
            <h2 className="text-lg font-bold mb-4">Create New User</h2>
            <form onSubmit={handleCreate} className="space-y-4">
              <div>
                <label className="block text-xs font-medium mb-1.5" style={{ color: 'var(--muted)' }}>Username</label>
                <input
                  type="text"
                  value={newUsername}
                  onChange={e => setNewUsername(e.target.value)}
                  required
                  autoFocus
                  className="w-full px-3 py-2 rounded-lg text-sm border outline-none focus:ring-2 focus:ring-blue-500"
                  style={{ background: 'var(--bg)', borderColor: 'var(--border)' }}
                  placeholder="e.g. officer_ali"
                />
              </div>
              <div>
                <label className="block text-xs font-medium mb-1.5" style={{ color: 'var(--muted)' }}>Password</label>
                <input
                  type="password"
                  value={newPassword}
                  onChange={e => setNewPassword(e.target.value)}
                  required
                  minLength={6}
                  className="w-full px-3 py-2 rounded-lg text-sm border outline-none focus:ring-2 focus:ring-blue-500"
                  style={{ background: 'var(--bg)', borderColor: 'var(--border)' }}
                  placeholder="Min. 6 characters"
                />
              </div>
              <div>
                <label className="block text-xs font-medium mb-1.5" style={{ color: 'var(--muted)' }}>Role</label>
                <div className="flex gap-2">
                  {(['officer', 'admin'] as UserRole[]).map(r => (
                    <button
                      key={r}
                      type="button"
                      onClick={() => setNewRole(r)}
                      className={`flex-1 py-2 rounded-lg text-sm font-medium transition-colors border ${
                        newRole === r
                          ? 'bg-blue-900 text-white border-blue-900'
                          : 'border-current hover:bg-black/5 dark:hover:bg-white/10'
                      }`}
                      style={newRole === r ? {} : { color: 'var(--muted)', borderColor: 'var(--border)' }}
                    >
                      {r === 'admin' ? 'Admin' : 'Officer'}
                    </button>
                  ))}
                </div>
              </div>
              <div className="flex gap-2 pt-2">
                <button
                  type="button"
                  onClick={closeModal}
                  className="flex-1 py-2 rounded-lg text-sm font-medium border transition-colors hover:bg-black/5 dark:hover:bg-white/10"
                  style={{ borderColor: 'var(--border)', color: 'var(--muted)' }}
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={submitting}
                  className="flex-1 py-2 rounded-lg text-sm font-medium bg-blue-900 text-white hover:bg-blue-800 transition-colors disabled:opacity-60"
                >
                  {submitting ? 'Creating…' : 'Create User'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Reset Password Modal */}
      {modal?.type === 'reset' && (
        <div className="fixed inset-0 z-40 flex items-center justify-center p-4 bg-black/50">
          <div className="w-full max-w-md rounded-2xl shadow-xl p-6" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
            <h2 className="text-lg font-bold mb-1">Reset Password</h2>
            <p className="text-sm mb-4" style={{ color: 'var(--muted)' }}>
              Set a new password for <strong>{modal.user.Username}</strong>
            </p>
            <form onSubmit={handleResetPassword} className="space-y-4">
              <div>
                <label className="block text-xs font-medium mb-1.5" style={{ color: 'var(--muted)' }}>New Password</label>
                <input
                  type="password"
                  value={resetPassword}
                  onChange={e => setResetPassword(e.target.value)}
                  required
                  minLength={6}
                  autoFocus
                  className="w-full px-3 py-2 rounded-lg text-sm border outline-none focus:ring-2 focus:ring-blue-500"
                  style={{ background: 'var(--bg)', borderColor: 'var(--border)' }}
                  placeholder="Min. 6 characters"
                />
              </div>
              <div className="flex gap-2 pt-2">
                <button
                  type="button"
                  onClick={closeModal}
                  className="flex-1 py-2 rounded-lg text-sm font-medium border transition-colors hover:bg-black/5 dark:hover:bg-white/10"
                  style={{ borderColor: 'var(--border)', color: 'var(--muted)' }}
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={submitting}
                  className="flex-1 py-2 rounded-lg text-sm font-medium bg-blue-900 text-white hover:bg-blue-800 transition-colors disabled:opacity-60"
                >
                  {submitting ? 'Saving…' : 'Reset Password'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Delete Confirm Modal */}
      {modal?.type === 'delete' && (
        <div className="fixed inset-0 z-40 flex items-center justify-center p-4 bg-black/50">
          <div className="w-full max-w-sm rounded-2xl shadow-xl p-6" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
            <h2 className="text-lg font-bold mb-1">Delete User</h2>
            <p className="text-sm mb-6" style={{ color: 'var(--muted)' }}>
              Are you sure you want to delete <strong>{modal.user.Username}</strong>? This cannot be undone.
            </p>
            <div className="flex gap-2">
              <button
                onClick={closeModal}
                className="flex-1 py-2 rounded-lg text-sm font-medium border transition-colors hover:bg-black/5 dark:hover:bg-white/10"
                style={{ borderColor: 'var(--border)', color: 'var(--muted)' }}
              >
                Cancel
              </button>
              <button
                onClick={handleDelete}
                disabled={submitting}
                className="flex-1 py-2 rounded-lg text-sm font-medium bg-red-600 text-white hover:bg-red-700 transition-colors disabled:opacity-60"
              >
                {submitting ? 'Deleting…' : 'Delete'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
