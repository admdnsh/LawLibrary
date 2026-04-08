'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Image from 'next/image';
import { login } from '@/lib/api';
import { hashPassword, saveSession, isLoggedIn } from '@/lib/auth';

export default function AdminLoginPage() {
  const router = useRouter();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  useEffect(() => {
    if (isLoggedIn()) {
      const session = JSON.parse(localStorage.getItem('law_library_admin') || '{}');
      router.replace(session?.isAdmin === 1 ? '/admin/dashboard' : '/');
    }
  }, [router]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const hashed = await hashPassword(password);
      const result = await login(username, hashed);
      if (result.success && result.user) {
        saveSession(result.user);
        router.push(result.user.isAdmin === 1 ? '/admin/dashboard' : '/');
      } else {
        setError(result.message || 'Invalid credentials');
      }
    } catch {
      setError('Connection error. Please try again.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <div className="w-full max-w-sm">
        {/* Logo */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 rounded-full bg-blue-900 flex items-center justify-center mx-auto mb-4 overflow-hidden shadow-lg ring-4 ring-blue-900/20">
            <Image src="/logo.png" alt="RBPF Logo" width={52} height={52} className="object-contain" />
          </div>
          <h1 className="text-2xl font-bold">Sign In</h1>
          <p className="text-sm mt-1" style={{ color: 'var(--muted)' }}>Law Library · Royal Brunei Police Force</p>
        </div>

        {/* Form */}
        <div
          className="rounded-2xl p-6 shadow-md"
          style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}
        >
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-1.5">Username</label>
              <input
                type="text"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                required
                autoComplete="username"
                className="w-full px-3 py-2.5 rounded-lg border text-sm outline-none focus:ring-2 focus:ring-blue-500 transition"
                style={{
                  background: 'var(--background)',
                  borderColor: 'var(--border)',
                  color: 'var(--foreground)',
                }}
                placeholder="Enter username"
              />
            </div>

            <div>
              <label className="block text-sm font-medium mb-1.5">Password</label>
              <div className="relative">
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  autoComplete="current-password"
                  className="w-full px-3 py-2.5 pr-10 rounded-lg border text-sm outline-none focus:ring-2 focus:ring-blue-500 transition"
                  style={{
                    background: 'var(--background)',
                    borderColor: 'var(--border)',
                    color: 'var(--foreground)',
                  }}
                  placeholder="Enter password"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword((v) => !v)}
                  className="absolute right-3 top-1/2 -translate-y-1/2"
                  style={{ color: 'var(--muted)' }}
                >
                  {showPassword ? (
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-4 h-4">
                      <path d="M3.53 2.47a.75.75 0 00-1.06 1.06l18 18a.75.75 0 101.06-1.06l-18-18zM22.676 12.553a11.249 11.249 0 01-2.631 4.31l-3.099-3.099a5.25 5.25 0 00-6.71-6.71L7.759 4.577A11.217 11.217 0 0112 3.75c4.5 0 8.399 2.57 10.426 6.36.056.1.083.208.083.31.001.107-.026.216-.083.32a.75.75 0 000 .062z" />
                      <path d="M15.75 12c0 .18-.013.357-.037.53l-4.244-4.243A3.75 3.75 0 0115.75 12zM12.53 15.713l-4.243-4.244a3.75 3.75 0 004.243 4.243z" />
                      <path d="M6.75 12c0-.619.107-1.213.304-1.764l-3.1-3.1a11.25 11.25 0 00-2.63 4.31.75.75 0 00.083.634 11.25 11.25 0 0010.43 6.42c1.586 0 3.098-.319 4.467-.893l-2.595-2.594A3.75 3.75 0 016.75 12z" />
                    </svg>
                  ) : (
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-4 h-4">
                      <path d="M12 15a3 3 0 100-6 3 3 0 000 6z" />
                      <path fillRule="evenodd" d="M1.323 11.447C2.811 6.976 7.028 3.75 12.001 3.75c4.97 0 9.185 3.223 10.675 7.69.12.362.12.752 0 1.113-1.487 4.471-5.705 7.697-10.677 7.697-4.97 0-9.186-3.223-10.675-7.69a1.762 1.762 0 010-1.113zM17.25 12a5.25 5.25 0 11-10.5 0 5.25 5.25 0 0110.5 0z" clipRule="evenodd" />
                    </svg>
                  )}
                </button>
              </div>
            </div>

            {error && (
              <div className="px-3 py-2 rounded-lg bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
                {error}
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full py-2.5 bg-blue-900 text-white rounded-lg text-sm font-semibold hover:bg-blue-800 transition disabled:opacity-60 flex items-center justify-center gap-2"
            >
              {loading && (
                <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
              )}
              {loading ? 'Signing in...' : 'Sign In'}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
