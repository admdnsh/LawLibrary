'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import type { Law } from '@/types';
import { getLaws, getCategories, createLaw, updateLaw, deleteLaw } from '@/lib/api';
import { getSession } from '@/lib/auth';
import CategoryBadge from '@/components/CategoryBadge';
import LawFormModal from '@/components/LawFormModal';
import DeleteConfirmModal from '@/components/DeleteConfirmModal';

const LIMIT = 20;

export default function AdminLawsPage() {
  const router = useRouter();
  const [laws, setLaws] = useState<Law[]>([]);
  const [categories, setCategories] = useState<string[]>([]);
  const [search, setSearch] = useState('');
  const [searchInput, setSearchInput] = useState('');
  const [category, setCategory] = useState('');
  const [page, setPage] = useState(1);
  const [hasMore, setHasMore] = useState(true);
  const [loading, setLoading] = useState(true);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);

  // Modals
  const [showForm, setShowForm] = useState(false);
  const [editLaw, setEditLaw] = useState<Law | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<Law | null>(null);

  // Auth guard
  useEffect(() => {
    if (!getSession()) router.replace('/admin');
  }, [router]);

  useEffect(() => {
    getCategories().then(setCategories).catch(() => {});
  }, []);

  const fetchLaws = useCallback(async (s: string, cat: string, p: number) => {
    setLoading(true);
    try {
      const data = await getLaws({ search: s, category: cat, page: p, limit: LIMIT });
      setLaws(data);
      setHasMore(data.length === LIMIT);
    } catch {
      setLaws([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchLaws(search, category, page);
  }, [search, category, page, fetchLaws]);

  function showToast(type: 'success' | 'error', msg: string) {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3500);
  }

  function handleSearch(e: React.FormEvent) {
    e.preventDefault();
    setPage(1);
    setSearch(searchInput);
  }

  async function handleSave(law: Law, originalChapter?: string) {
    try {
      let res;
      if (originalChapter) {
        res = await updateLaw({ ...law, Original_Chapter: originalChapter });
      } else {
        res = await createLaw(law);
      }
      if (!res.success) throw new Error(res.message);
      showToast('success', res.message);
      setShowForm(false);
      setEditLaw(null);
      fetchLaws(search, category, page);
      // Refresh categories in case a new one was added
      getCategories().then(setCategories).catch(() => {});
    } catch (err) {
      throw err;
    }
  }

  async function handleDelete() {
    if (!deleteTarget) return;
    try {
      const res = await deleteLaw(deleteTarget.Chapter);
      if (!res.success) throw new Error(res.message);
      showToast('success', 'Law deleted successfully');
      setDeleteTarget(null);
      fetchLaws(search, category, page);
    } catch (err) {
      showToast('error', err instanceof Error ? err.message : 'Failed to delete');
      setDeleteTarget(null);
    }
  }

  return (
    <div className="flex flex-col h-screen overflow-hidden">
      {/* Top bar */}
      <div
        className="flex items-center justify-between px-6 py-4 border-b shrink-0"
        style={{ background: 'var(--card-bg)', borderColor: 'var(--border)' }}
      >
        <div>
          <h1 className="text-xl font-bold">Manage Laws</h1>
          <p className="text-xs mt-0.5" style={{ color: 'var(--muted)' }}>
            Create, edit, and delete law records
          </p>
        </div>
        <button
          onClick={() => { setEditLaw(null); setShowForm(true); }}
          className="flex items-center gap-2 px-4 py-2 bg-blue-900 text-white text-sm font-semibold rounded-xl hover:bg-blue-800 transition"
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-4 h-4">
            <path fillRule="evenodd" d="M12 3.75a.75.75 0 01.75.75v6.75h6.75a.75.75 0 010 1.5h-6.75v6.75a.75.75 0 01-1.5 0v-6.75H4.5a.75.75 0 010-1.5h6.75V4.5a.75.75 0 01.75-.75z" clipRule="evenodd" />
          </svg>
          Add Law
        </button>
      </div>

      {/* Filters */}
      <div
        className="flex items-center gap-3 px-6 py-3 border-b shrink-0 flex-wrap"
        style={{ background: 'var(--card-bg)', borderColor: 'var(--border)' }}
      >
        <form onSubmit={handleSearch} className="flex gap-2 flex-1 min-w-[200px]">
          <div className="relative flex-1">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4"
              style={{ color: 'var(--muted)' }}
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            <input
              type="text"
              placeholder="Search laws..."
              value={searchInput}
              onChange={(e) => setSearchInput(e.target.value)}
              className="w-full pl-9 pr-3 py-2 text-sm rounded-lg border outline-none focus:ring-2 focus:ring-blue-500 transition"
              style={{ background: 'var(--background)', borderColor: 'var(--border)', color: 'var(--foreground)' }}
            />
          </div>
          <button
            type="submit"
            className="px-3 py-2 bg-blue-900 text-white text-sm rounded-lg hover:bg-blue-800 transition shrink-0"
          >
            Search
          </button>
        </form>

        <select
          value={category}
          onChange={(e) => { setCategory(e.target.value); setPage(1); }}
          className="px-3 py-2 text-sm rounded-lg border outline-none"
          style={{ background: 'var(--background)', borderColor: 'var(--border)', color: 'var(--foreground)' }}
        >
          <option value="">All Categories</option>
          {categories.map((c) => <option key={c} value={c}>{c}</option>)}
        </select>

        {(search || category) && (
          <button
            onClick={() => { setSearch(''); setSearchInput(''); setCategory(''); setPage(1); }}
            className="text-sm text-blue-600 dark:text-blue-400 hover:underline"
          >
            Clear
          </button>
        )}
      </div>

      {/* Table */}
      <div className="flex-1 overflow-auto">
        {loading ? (
          <div className="flex items-center justify-center h-48">
            <div className="w-8 h-8 border-2 border-blue-900 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : laws.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-48 gap-4">
            <div
              className="w-14 h-14 rounded-2xl flex items-center justify-center"
              style={{ background: 'var(--background)', border: '1px solid var(--border)' }}
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="w-7 h-7 opacity-20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 002.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 00-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 00.75-.75 2.25 2.25 0 00-.1-.664m-5.8 0A2.251 2.251 0 0113.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V19.5a2.25 2.25 0 002.25 2.25h.75" />
              </svg>
            </div>
            <div className="text-center">
              <p className="text-sm font-semibold mb-1">No laws found</p>
              <button
                onClick={() => { setShowForm(true); setEditLaw(null); }}
                className="text-xs text-blue-600 dark:text-blue-400 hover:underline"
              >
                Add the first law
              </button>
            </div>
          </div>
        ) : (
          <table className="w-full text-sm border-collapse">
            <thead>
              <tr style={{ background: 'var(--background)', borderBottom: '1px solid var(--border)' }}>
                <th className="text-left px-4 py-3 text-xs font-semibold uppercase tracking-wide" style={{ color: 'var(--muted)', width: '100px' }}>
                  Chapter
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold uppercase tracking-wide" style={{ color: 'var(--muted)', width: '130px' }}>
                  Category
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold uppercase tracking-wide" style={{ color: 'var(--muted)' }}>
                  Title
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold uppercase tracking-wide" style={{ color: 'var(--muted)', width: '160px' }}>
                  Compound Fine
                </th>
                <th className="px-4 py-3 text-xs font-semibold uppercase tracking-wide text-right" style={{ color: 'var(--muted)', width: '120px' }}>
                  Actions
                </th>
              </tr>
            </thead>
            <tbody>
              {laws.map((law, i) => (
                <tr
                  key={law.Chapter}
                  style={{
                    borderBottom: '1px solid var(--border)',
                    background: i % 2 === 0 ? 'var(--card-bg)' : 'var(--background)',
                  }}
                  className="hover:bg-blue-50 dark:hover:bg-blue-900/10 transition-colors"
                >
                  <td className="px-4 py-3.5 font-mono text-xs text-blue-900 dark:text-blue-400 font-semibold whitespace-nowrap tracking-wide">
                    {law.Chapter}
                  </td>
                  <td className="px-4 py-3.5">
                    <CategoryBadge category={law.Category} />
                  </td>
                  <td className="px-4 py-3.5 max-w-xs">
                    <p className="line-clamp-2 leading-snug text-sm">{law.Title}</p>
                  </td>
                  <td className="px-4 py-3.5 text-emerald-600 dark:text-emerald-400 font-semibold text-sm whitespace-nowrap">
                    {law.Compound_Fine || <span style={{ color: 'var(--muted)' }}>—</span>}
                  </td>
                  <td className="px-4 py-3.5">
                    <div className="flex items-center justify-end gap-1.5">
                      <button
                        onClick={() => { setEditLaw(law); setShowForm(true); }}
                        className="px-3 py-1.5 text-xs rounded-lg font-medium transition-colors hover:bg-blue-50 dark:hover:bg-blue-900/20 hover:text-blue-900 dark:hover:text-blue-300"
                        style={{ color: 'var(--foreground)', border: '1px solid var(--border)' }}
                      >
                        Edit
                      </button>
                      <button
                        onClick={() => setDeleteTarget(law)}
                        className="px-3 py-1.5 text-xs rounded-lg font-medium transition-colors hover:bg-red-50 dark:hover:bg-red-900/20 text-red-600 dark:text-red-400"
                        style={{ border: '1px solid #fecaca' }}
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

      {/* Pagination */}
      {!loading && laws.length > 0 && (
        <div
          className="flex items-center justify-between px-6 py-3 border-t shrink-0"
          style={{ background: 'var(--card-bg)', borderColor: 'var(--border)' }}
        >
          <span className="text-xs" style={{ color: 'var(--muted)' }}>
            Page {page} — showing {laws.length} records
          </span>
          <div className="flex gap-2">
            <button
              disabled={page === 1}
              onClick={() => setPage((p) => p - 1)}
              className="px-3 py-1.5 text-xs rounded-lg border transition disabled:opacity-40"
              style={{ borderColor: 'var(--border)', color: 'var(--foreground)' }}
            >
              Previous
            </button>
            <button
              disabled={!hasMore}
              onClick={() => setPage((p) => p + 1)}
              className="px-3 py-1.5 text-xs rounded-lg border transition disabled:opacity-40"
              style={{ borderColor: 'var(--border)', color: 'var(--foreground)' }}
            >
              Next
            </button>
          </div>
        </div>
      )}

      {/* Modals */}
      {showForm && (
        <LawFormModal
          law={editLaw}
          categories={categories}
          onSave={handleSave}
          onClose={() => { setShowForm(false); setEditLaw(null); }}
        />
      )}

      {deleteTarget && (
        <DeleteConfirmModal
          chapter={deleteTarget.Chapter}
          title={deleteTarget.Title}
          onConfirm={handleDelete}
          onClose={() => setDeleteTarget(null)}
        />
      )}

      {/* Toast notification */}
      {toast && (
        <div
          className={`fixed bottom-6 right-6 px-4 py-3 rounded-xl shadow-lg text-sm font-medium text-white transition-all ${
            toast.type === 'success' ? 'bg-emerald-600' : 'bg-red-600'
          }`}
        >
          {toast.msg}
        </div>
      )}
    </div>
  );
}
