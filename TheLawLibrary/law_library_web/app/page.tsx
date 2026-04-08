'use client';

import { useState, useEffect, useCallback, useRef } from 'react';
import type { Law } from '@/types';
import { getLaws, getCategories } from '@/lib/api';
import CategoryBadge from '@/components/CategoryBadge';
import LawDetailPanel from '@/components/LawDetailPanel';

const LIMIT = 15;

export default function HomePage() {
  const [laws, setLaws] = useState<Law[]>([]);
  const [categories, setCategories] = useState<string[]>([]);
  const [search, setSearch] = useState('');
  const [category, setCategory] = useState('');
  const [page, setPage] = useState(1);
  const [hasMore, setHasMore] = useState(true);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [selectedLaw, setSelectedLaw] = useState<Law | null>(null);
  const [searchInput, setSearchInput] = useState('');
  const [focusedIndex, setFocusedIndex] = useState(-1);
  const itemRefs = useRef<(HTMLButtonElement | null)[]>([]);

  useEffect(() => {
    getCategories().then(setCategories).catch(() => {});
  }, []);

  const fetchLaws = useCallback(async (s: string, cat: string, p: number) => {
    setLoading(true);
    setError('');
    try {
      const data = await getLaws({ search: s, category: cat, page: p, limit: LIMIT });
      setLaws(data);
      setHasMore(data.length === LIMIT);
      setFocusedIndex(-1);
      itemRefs.current = [];
    } catch {
      setLaws([]);
      setHasMore(false);
      setError('Failed to load laws. Check your connection.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchLaws(search, category, page);
  }, [search, category, page, fetchLaws]);

  // Auto-search: fires 400ms after the user stops typing
  // eslint-disable-next-line react-hooks/exhaustive-deps
  useEffect(() => {
    const timer = setTimeout(() => {
      setSearch(searchInput);
      setPage(1);
    }, 400);
    return () => clearTimeout(timer);
  }, [searchInput]);

  // Close detail panel on Escape
  useEffect(() => {
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === 'Escape') setSelectedLaw(null);
    }
    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, []);

  function handleSearch(e: React.FormEvent) {
    e.preventDefault();
    setPage(1);
    setSearch(searchInput);
    setSelectedLaw(null);
  }

  function handleCategory(cat: string) {
    setCategory(cat);
    setPage(1);
    setSelectedLaw(null);
  }

  function handleClear() {
    setSearchInput('');
    setSearch('');
    setCategory('');
    setPage(1);
    setSelectedLaw(null);
  }

  function handleListKeyDown(e: React.KeyboardEvent) {
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      const next = Math.min(focusedIndex + 1, laws.length - 1);
      setFocusedIndex(next);
      itemRefs.current[next]?.focus();
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      const prev = Math.max(focusedIndex - 1, 0);
      setFocusedIndex(prev);
      itemRefs.current[prev]?.focus();
    }
  }

  return (
    <div className="flex h-screen overflow-hidden">
      {/* Left panel: list */}
      <div
        className={`flex-col shrink-0 border-r w-full lg:w-96 xl:w-[420px] ${selectedLaw ? 'hidden lg:flex' : 'flex'}`}
        style={{ borderColor: 'var(--border)' }}
      >
        {/* Search bar */}
        <div
          className="p-4 border-b"
          style={{ borderColor: 'var(--border)', background: 'var(--card-bg)' }}
        >
          <form onSubmit={handleSearch} className="flex gap-2 mb-3">
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
                style={{
                  background: 'var(--background)',
                  borderColor: 'var(--border)',
                  color: 'var(--foreground)',
                }}
              />
            </div>
            <button
              type="submit"
              className="px-3 py-2 bg-blue-900 text-white text-sm rounded-lg hover:bg-blue-800 transition shrink-0"
            >
              Search
            </button>
          </form>

          {/* Category chips */}
          <div className="flex flex-wrap gap-1.5">
            <button
              onClick={() => handleCategory('')}
              className={`px-2.5 py-1 rounded-full text-xs font-medium transition ${
                category === '' ? 'bg-blue-900 text-white' : ''
              }`}
              style={
                category === ''
                  ? {}
                  : {
                      background: 'var(--background)',
                      color: 'var(--muted)',
                      border: '1px solid var(--border)',
                    }
              }
            >
              All
            </button>
            {categories.map((cat) => (
              <button
                key={cat}
                onClick={() => handleCategory(cat)}
                className={`px-2.5 py-1 rounded-full text-xs font-medium transition ${
                  category === cat ? 'bg-blue-900 text-white' : ''
                }`}
                style={
                  category === cat
                    ? {}
                    : {
                        background: 'var(--background)',
                        color: 'var(--muted)',
                        border: '1px solid var(--border)',
                      }
                }
              >
                {cat}
              </button>
            ))}
          </div>

          {(search || category) && (
            <div className="mt-2 flex items-center justify-between">
              <span className="text-xs" style={{ color: 'var(--muted)' }}>
                {search && `"${search}"`}
                {search && category && ' · '}
                {category}
              </span>
              <button
                onClick={handleClear}
                className="text-xs text-blue-600 dark:text-blue-400 hover:underline"
              >
                Clear
              </button>
            </div>
          )}
        </div>

        {/* Law list */}
        <div className="flex-1 overflow-y-auto" onKeyDown={handleListKeyDown}>
          {!loading && !error && laws.length > 0 && (
            <div className="px-4 py-2 border-b flex items-center" style={{ borderColor: 'var(--border)' }}>
              <span className="text-xs font-medium" style={{ color: 'var(--muted)' }}>
                {laws.length}{hasMore ? '+' : ''} result{laws.length !== 1 ? 's' : ''}
              </span>
            </div>
          )}
          {loading ? (
            <div className="flex items-center justify-center h-32">
              <div className="w-6 h-6 border-2 border-blue-900 border-t-transparent rounded-full animate-spin" />
            </div>
          ) : error ? (
            <div className="flex flex-col items-center justify-center h-32 text-center px-4 gap-3">
              <svg xmlns="http://www.w3.org/2000/svg" className="w-8 h-8 opacity-30" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z" />
              </svg>
              <p className="text-sm" style={{ color: 'var(--muted)' }}>{error}</p>
              <button
                onClick={() => fetchLaws(search, category, page)}
                className="text-xs px-3 py-1.5 bg-blue-900 text-white rounded-lg hover:bg-blue-800 transition"
              >
                Retry
              </button>
            </div>
          ) : laws.length === 0 ? (
            <div
              className="flex flex-col items-center justify-center h-32 text-center px-4"
              style={{ color: 'var(--muted)' }}
            >
              <p className="text-sm">No laws found</p>
              {(search || category) && (
                <button
                  onClick={handleClear}
                  className="text-xs text-blue-600 dark:text-blue-400 mt-1 hover:underline"
                >
                  Clear filters
                </button>
              )}
            </div>
          ) : (
            <>
              {laws.map((law, index) => (
                <button
                  key={law.Chapter}
                  ref={(el) => { itemRefs.current[index] = el; }}
                  onClick={() => { setSelectedLaw(law); setFocusedIndex(index); }}
                  onFocus={() => setFocusedIndex(index)}
                  className={`w-full text-left px-4 py-3.5 border-b transition-colors focus:outline-none focus:ring-2 focus:ring-inset focus:ring-blue-500 ${
                    selectedLaw?.Chapter === law.Chapter
                      ? 'bg-blue-50 dark:bg-blue-900/20'
                      : 'hover:bg-gray-50 dark:hover:bg-white/5'
                  }`}
                  style={{
                    borderBottomColor: 'var(--border)',
                    borderLeft: selectedLaw?.Chapter === law.Chapter ? '3px solid var(--accent-blue)' : '3px solid transparent',
                  }}
                >
                  <div className="flex items-start justify-between gap-2 mb-1.5">
                    <span className="text-xs font-mono text-blue-900 dark:text-blue-400 font-semibold tracking-wide">
                      {law.Chapter}
                    </span>
                    <CategoryBadge category={law.Category} />
                  </div>
                  <p className="text-sm font-medium leading-snug line-clamp-2 pr-1">{law.Title}</p>
                  {law.Compound_Fine && (
                    <p className="text-xs mt-1.5 text-emerald-600 dark:text-emerald-400 font-semibold">
                      Fine: {law.Compound_Fine}
                    </p>
                  )}
                </button>
              ))}

              {/* Pagination */}
              <div
                className="flex items-center justify-between px-4 py-3"
                style={{ borderTop: '1px solid var(--border)' }}
              >
                <button
                  disabled={page === 1}
                  onClick={() => setPage((p) => p - 1)}
                  className="text-xs px-3 py-1.5 rounded-lg border transition disabled:opacity-40"
                  style={{ borderColor: 'var(--border)', color: 'var(--foreground)' }}
                >
                  Previous
                </button>
                <span className="text-xs" style={{ color: 'var(--muted)' }}>
                  Page {page}
                </span>
                <button
                  disabled={!hasMore}
                  onClick={() => setPage((p) => p + 1)}
                  className="text-xs px-3 py-1.5 rounded-lg border transition disabled:opacity-40"
                  style={{ borderColor: 'var(--border)', color: 'var(--foreground)' }}
                >
                  Next
                </button>
              </div>
            </>
          )}
        </div>
      </div>

      {/* Right panel: detail */}
      <div
        className={`flex-1 overflow-hidden ${selectedLaw ? 'block' : 'hidden lg:block'}`}
        style={{ background: 'var(--card-bg)' }}
      >
        <LawDetailPanel law={selectedLaw} onClose={() => setSelectedLaw(null)} />
      </div>
    </div>
  );
}
