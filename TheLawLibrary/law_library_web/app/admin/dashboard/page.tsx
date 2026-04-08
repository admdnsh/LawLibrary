'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { getLaws, getCategories, getLawCount } from '@/lib/api';
import { getSession } from '@/lib/auth';
import CategoryBadge from '@/components/CategoryBadge';

interface CategoryStat {
  name: string;
  count: number;
}

interface DashboardData {
  totalLaws: number;
  categoryStats: CategoryStat[];
}

export default function AdminDashboardPage() {
  const router = useRouter();
  const [data, setData] = useState<DashboardData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const session = getSession();
    if (!session) { router.replace('/admin'); return; }
    if (session.isAdmin !== 1) { router.replace('/'); return; }
    loadDashboard();
  }, [router]);

  async function loadDashboard() {
    setLoading(true);
    setError('');
    try {
      const [total, categories] = await Promise.all([
        getLawCount(),
        getCategories(),
      ]);

      // Fetch count per category in parallel
      const counts = await Promise.all(
        categories.map(async (cat) => {
          const laws = await getLaws({ category: cat, page: 1, limit: 999 });
          return { name: cat, count: laws.length };
        })
      );

      const sorted = counts.sort((a, b) => b.count - a.count);
      setData({ totalLaws: total, categoryStats: sorted });
    } catch {
      setError('Failed to load dashboard. Check your connection.');
    } finally {
      setLoading(false);
    }
  }

  const maxCount = data?.categoryStats[0]?.count ?? 1;

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold">Dashboard</h1>
          <p className="text-sm mt-0.5" style={{ color: 'var(--muted)' }}>
            Overview of all law records
          </p>
        </div>
        {!loading && (
          <button
            onClick={loadDashboard}
            className="flex items-center gap-1.5 px-3 py-2 text-sm rounded-xl border transition hover:bg-gray-50 dark:hover:bg-white/5"
            style={{ borderColor: 'var(--border)', color: 'var(--muted)' }}
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4">
              <path fillRule="evenodd" d="M15.312 11.424a5.5 5.5 0 01-9.201 2.466l-.312-.311h2.433a.75.75 0 000-1.5H3.989a.75.75 0 00-.75.75v4.242a.75.75 0 001.5 0v-2.43l.31.31a7 7 0 0011.712-3.138.75.75 0 00-1.449-.39zm1.23-3.723a.75.75 0 00.219-.53V2.929a.75.75 0 00-1.5 0V5.36l-.31-.31A7 7 0 003.239 8.188a.75.75 0 101.448.389A5.5 5.5 0 0113.89 6.11l.311.31h-2.432a.75.75 0 000 1.5h4.243a.75.75 0 00.53-.219z" clipRule="evenodd" />
            </svg>
            Refresh
          </button>
        )}
      </div>

      {loading ? (
        <div className="space-y-4">
          {/* Skeleton stat card */}
          <div className="h-32 rounded-2xl animate-pulse" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }} />
          <div className="h-64 rounded-2xl animate-pulse" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }} />
        </div>
      ) : error ? (
        <div className="flex flex-col items-center justify-center py-16 gap-4 text-center">
          <svg xmlns="http://www.w3.org/2000/svg" className="w-12 h-12 opacity-30" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z" />
          </svg>
          <p className="text-sm" style={{ color: 'var(--muted)' }}>{error}</p>
          <button
            onClick={loadDashboard}
            className="px-4 py-2 bg-blue-900 text-white text-sm rounded-xl hover:bg-blue-800 transition"
          >
            Retry
          </button>
        </div>
      ) : data && (
        <div className="space-y-5">
          {/* Stat cards row */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <StatCard
              label="Total Laws"
              value={data.totalLaws}
              icon={
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
                  <path d="M11.25 4.533A9.707 9.707 0 006 3a9.735 9.735 0 00-3.25.555.75.75 0 00-.5.707v14.25a.75.75 0 001 .707A8.237 8.237 0 016 18.75c1.995 0 3.823.707 5.25 1.886V4.533zM12.75 20.636A8.214 8.214 0 0118 18.75c.966 0 1.89.166 2.75.47a.75.75 0 001-.708V4.262a.75.75 0 00-.5-.707A9.735 9.735 0 0018 3a9.707 9.707 0 00-5.25 1.533v16.103z" />
                </svg>
              }
              color="bg-blue-900"
            />
            <StatCard
              label="Categories"
              value={data.categoryStats.length}
              icon={
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
                  <path fillRule="evenodd" d="M5.25 2.25a3 3 0 00-3 3v4.318a3 3 0 00.879 2.121l9.58 9.581c.92.92 2.39 1.186 3.548.428a18.849 18.849 0 005.441-5.44c.758-1.16.492-2.629-.428-3.548l-9.58-9.581a3 3 0 00-2.121-.879H5.25zM6.375 7.5a1.125 1.125 0 100-2.25 1.125 1.125 0 000 2.25z" clipRule="evenodd" />
                </svg>
              }
              color="bg-indigo-600"
            />
            <StatCard
              label="Most Laws"
              value={data.categoryStats[0]?.count ?? 0}
              sublabel={data.categoryStats[0]?.name}
              icon={
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
                  <path fillRule="evenodd" d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.007 5.404.433c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.433 2.082-5.006z" clipRule="evenodd" />
                </svg>
              }
              color="bg-amber-500"
            />
          </div>

          {/* Laws by category */}
          <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
            <div className="px-5 py-4 border-b" style={{ borderColor: 'var(--border)' }}>
              <h2 className="font-semibold">Laws by Category</h2>
            </div>
            <div className="divide-y" style={{ borderColor: 'var(--border)' }}>
              {data.categoryStats.map((stat) => {
                const pct = Math.round((stat.count / maxCount) * 100);
                return (
                  <div key={stat.name} className="px-5 py-3.5">
                    <div className="flex items-center justify-between mb-2">
                      <CategoryBadge category={stat.name} />
                      <span className="text-sm font-semibold tabular-nums">
                        {stat.count}
                        <span className="text-xs font-normal ml-1" style={{ color: 'var(--muted)' }}>
                          ({Math.round((stat.count / data.totalLaws) * 100)}%)
                        </span>
                      </span>
                    </div>
                    <div className="h-1.5 rounded-full overflow-hidden" style={{ background: 'var(--border)' }}>
                      <div
                        className="h-full rounded-full bg-blue-900 transition-all duration-500"
                        style={{ width: `${pct}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Quick actions */}
          <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
            <div className="px-5 py-4 border-b" style={{ borderColor: 'var(--border)' }}>
              <h2 className="font-semibold">Quick Actions</h2>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 p-4">
              <a
                href="/admin/laws"
                className="flex items-center gap-3 p-4 rounded-xl border transition hover:bg-blue-50 dark:hover:bg-blue-900/20 hover:border-blue-300 dark:hover:border-blue-700"
                style={{ borderColor: 'var(--border)' }}
              >
                <div className="w-9 h-9 rounded-lg bg-blue-900 flex items-center justify-center shrink-0">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4 text-white">
                    <path d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z" />
                  </svg>
                </div>
                <div>
                  <p className="text-sm font-semibold">Add New Law</p>
                  <p className="text-xs" style={{ color: 'var(--muted)' }}>Create a record</p>
                </div>
              </a>
              <a
                href="/admin/laws"
                className="flex items-center gap-3 p-4 rounded-xl border transition hover:bg-blue-50 dark:hover:bg-blue-900/20 hover:border-blue-300 dark:hover:border-blue-700"
                style={{ borderColor: 'var(--border)' }}
              >
                <div className="w-9 h-9 rounded-lg bg-indigo-600 flex items-center justify-center shrink-0">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4 text-white">
                    <path d="M5.433 13.917l1.262-3.155A4 4 0 017.58 9.42l6.92-6.918a2.121 2.121 0 013 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 01-.65-.65z" />
                    <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0010 3H4.75A2.75 2.75 0 002 5.75v9.5A2.75 2.75 0 004.75 18h9.5A2.75 2.75 0 0017 15.25V10a.75.75 0 00-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5z" />
                  </svg>
                </div>
                <div>
                  <p className="text-sm font-semibold">Manage Laws</p>
                  <p className="text-xs" style={{ color: 'var(--muted)' }}>Edit or delete</p>
                </div>
              </a>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function StatCard({
  label,
  value,
  sublabel,
  icon,
  color,
}: {
  label: string;
  value: number;
  sublabel?: string;
  icon: React.ReactNode;
  color: string;
}) {
  return (
    <div className="rounded-2xl p-5 flex items-center justify-between" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
      <div>
        <p className="text-xs font-medium uppercase tracking-wide mb-1" style={{ color: 'var(--muted)' }}>{label}</p>
        <p className="text-3xl font-bold tabular-nums">{value.toLocaleString()}</p>
        {sublabel && <p className="text-xs mt-1 truncate max-w-[120px]" style={{ color: 'var(--muted)' }}>{sublabel}</p>}
      </div>
      <div className={`w-12 h-12 ${color} rounded-xl flex items-center justify-center text-white opacity-90 shrink-0`}>
        {icon}
      </div>
    </div>
  );
}
