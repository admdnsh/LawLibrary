'use client';

import { useState, useEffect, useMemo, useRef } from 'react';
import Fuse from 'fuse.js';
import type { Law } from '@/types';
import { getLaws, getCategories } from '@/lib/api';
import CategoryBadge from '@/components/CategoryBadge';
import LawDetailPanel from '@/components/LawDetailPanel';

const PAGE_SIZE = 15;

export default function HomePage() {
  const [allLaws, setAllLaws] = useState<Law[]>([]);
  const [categories, setCategories] = useState<string[]>([]);
  const [searchInput, setSearchInput] = useState('');
  const [search, setSearch] = useState('');
  const [category, setCategory] = useState('');
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [selectedLaw, setSelectedLaw] = useState<Law | null>(null);
  const [focusedIndex, setFocusedIndex] = useState(-1);
  const itemRefs = useRef<(HTMLButtonElement | null)[]>([]);

  // Load all laws once on mount
  useEffect(() => {
    setLoading(true);
    Promise.all([
      getLaws({ limit: 9999 }),
      getCategories(),
    ])
      .then(([lawData, catData]) => {
        setAllLaws(lawData);
        setCategories(catData);
      })
      .catch(() => setError('Failed to load laws. Check your connection.'))
      .finally(() => setLoading(false));
  }, []);

  // Fuse instance — rebuilt only when allLaws changes
  const fuse = useMemo(() => new Fuse(allLaws, {
    keys: [
      { name: 'Title',       weight: 0.5 },
      { name: 'Chapter',     weight: 0.25 },
      { name: 'Category',    weight: 0.15 },
      { name: 'Description', weight: 0.1 },
    ],
    threshold: 0.4,
    ignoreLocation: true,
  }), [allLaws]);

  // Filtered + searched results
  const results = useMemo(() => {
    let list = search
      ? fuse.search(search).map((r) => r.item)
      : allLaws;
    if (category) list = list.filter((l) => l.Category === category);
    return list;
  }, [search, category, allLaws, fuse]);

  // Paginated slice
  const paginated = useMemo(() => {
    const start = (page - 1) * PAGE_SIZE;
    return results.slice(start, start + PAGE_SIZE);
  }, [results, page]);

  const totalPages = Math.max(1, Math.ceil(results.length / PAGE_SIZE));

  // Debounce search input
  useEffect(() => {
    const timer = setTimeout(() => {
      setSearch(searchInput);
      setPage(1);
      setFocusedIndex(-1);
      itemRefs.current = [];
    }, 250);
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
    setSearch(searchInput);
    setPage(1);
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
      const next = Math.min(focusedIndex + 1, paginated.length - 1);
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
          {!loading && !error && results.length > 0 && (
            <div className="px-4 py-2 border-b flex items-center" style={{ borderColor: 'var(--border)' }}>
              <span className="text-xs font-medium" style={{ color: 'var(--muted)' }}>
                {results.length} result{results.length !== 1 ? 's' : ''}
                {search && <span className="ml-1 text-blue-600 dark:text-blue-400">· fuzzy match</span>}
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
                onClick={() => window.location.reload()}
                className="text-xs px-3 py-1.5 bg-blue-900 text-white rounded-lg hover:bg-blue-800 transition"
              >
                Retry
              </button>
            </div>
          ) : results.length === 0 ? (
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
              {paginated.map((law, index) => (
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
              {totalPages > 1 && (
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
                    Page {page} of {totalPages}
                  </span>
                  <button
                    disabled={page >= totalPages}
                    onClick={() => setPage((p) => p + 1)}
                    className="text-xs px-3 py-1.5 rounded-lg border transition disabled:opacity-40"
                    style={{ borderColor: 'var(--border)', color: 'var(--foreground)' }}
                  >
                    Next
                  </button>
                </div>
              )}
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
