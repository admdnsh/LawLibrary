'use client';

import { useEffect, useRef, useState } from 'react';
import type { Law } from '@/types';
import { getFavorites, removeFavorite } from '@/lib/favorites';
import CategoryBadge from '@/components/CategoryBadge';
import LawDetailPanel from '@/components/LawDetailPanel';
import Link from 'next/link';

export default function FavoritesPage() {
  const [favorites, setFavorites] = useState<Law[]>([]);
  const [search, setSearch] = useState('');
  const [selectedLaw, setSelectedLaw] = useState<Law | null>(null);
  const [focusedIndex, setFocusedIndex] = useState(-1);
  const itemRefs = useRef<(HTMLButtonElement | null)[]>([]);

  useEffect(() => {
    setFavorites(getFavorites());
  }, []);

  // Close detail panel on Escape
  useEffect(() => {
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === 'Escape') setSelectedLaw(null);
    }
    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, []);

  function handleListKeyDown(e: React.KeyboardEvent) {
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      const next = Math.min(focusedIndex + 1, filtered.length - 1);
      setFocusedIndex(next);
      itemRefs.current[next]?.focus();
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      const prev = Math.max(focusedIndex - 1, 0);
      setFocusedIndex(prev);
      itemRefs.current[prev]?.focus();
    }
  }

  function handleRemove(chapter: string) {
    removeFavorite(chapter);
    setFavorites((prev) => prev.filter((l) => l.Chapter !== chapter));
    if (selectedLaw?.Chapter === chapter) setSelectedLaw(null);
  }

  const filtered = favorites.filter(
    (l) =>
      l.Title.toLowerCase().includes(search.toLowerCase()) ||
      l.Chapter.toLowerCase().includes(search.toLowerCase()) ||
      l.Category.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="flex h-screen overflow-hidden">
      {/* Left panel */}
      <div
        className={`flex-col shrink-0 border-r w-full lg:w-96 xl:w-[420px] ${selectedLaw ? 'hidden lg:flex' : 'flex'}`}
        style={{ borderColor: 'var(--border)' }}
      >
        {/* Header */}
        <div
          className="p-4 border-b"
          style={{ borderColor: 'var(--border)', background: 'var(--card-bg)' }}
        >
          <h1 className="text-lg font-bold mb-3">Favorites</h1>
          <div className="relative">
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
              placeholder="Search favorites..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full pl-9 pr-3 py-2 text-sm rounded-lg border outline-none focus:ring-2 focus:ring-blue-500 transition"
              style={{
                background: 'var(--background)',
                borderColor: 'var(--border)',
                color: 'var(--foreground)',
              }}
            />
          </div>
        </div>

        {/* List */}
        <div className="flex-1 overflow-y-auto" onKeyDown={handleListKeyDown}>
          {favorites.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-48 text-center px-4 gap-4">
              <div
                className="w-16 h-16 rounded-2xl flex items-center justify-center"
                style={{ background: 'var(--background)', border: '1px solid var(--border)' }}
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="w-8 h-8 opacity-20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M11.48 3.499a.562.562 0 011.04 0l2.125 5.111a.563.563 0 00.475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 00-.182.557l1.285 5.385a.562.562 0 01-.84.61l-4.725-2.885a.563.563 0 00-.586 0L6.982 20.54a.562.562 0 01-.84-.61l1.285-5.386a.562.562 0 00-.182-.557l-4.204-3.602a.563.563 0 01.321-.988l5.518-.442a.563.563 0 00.475-.345L11.48 3.5z" />
                </svg>
              </div>
              <div>
                <p className="text-sm font-semibold mb-1">No favorites yet</p>
                <Link href="/" className="text-xs text-blue-600 dark:text-blue-400 hover:underline">
                  Browse laws to add some
                </Link>
              </div>
            </div>
          ) : filtered.length === 0 ? (
            <div
              className="flex items-center justify-center h-24 text-sm"
              style={{ color: 'var(--muted)' }}
            >
              No results for &ldquo;{search}&rdquo;
            </div>
          ) : (
            filtered.map((law, index) => (
              <div
                key={law.Chapter}
                className={`border-b transition-colors ${
                  selectedLaw?.Chapter === law.Chapter
                    ? 'bg-blue-50 dark:bg-blue-900/20'
                    : 'hover:bg-gray-50 dark:hover:bg-white/5'
                }`}
                style={{
                  borderBottomColor: 'var(--border)',
                  borderLeft: selectedLaw?.Chapter === law.Chapter ? '3px solid var(--accent-blue)' : '3px solid transparent',
                }}
              >
                <div className="flex items-start gap-2 px-4 pt-3.5 pb-2">
                  <button
                    ref={(el) => { itemRefs.current[index] = el; }}
                    className="flex-1 text-left min-w-0 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-blue-500 rounded"
                    onClick={() => { setSelectedLaw(law); setFocusedIndex(index); }}
                    onFocus={() => setFocusedIndex(index)}
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
                  <button
                    onClick={() => handleRemove(law.Chapter)}
                    className="shrink-0 p-1.5 rounded-lg text-gray-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors mt-0.5"
                    title="Remove from favorites"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4">
                      <path fillRule="evenodd" d="M8.75 1A2.75 2.75 0 006 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 10.23 1.482l.149-.022.841 10.518A2.75 2.75 0 007.596 19h4.807a2.75 2.75 0 002.742-2.53l.841-10.52.149.023a.75.75 0 00.23-1.482A41.03 41.03 0 0014 4.193V3.75A2.75 2.75 0 0011.25 1h-2.5zM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4zM8.58 7.72a.75.75 0 00-1.5.06l.3 7.5a.75.75 0 101.5-.06l-.3-7.5zm4.34.06a.75.75 0 10-1.5-.06l-.3 7.5a.75.75 0 101.5.06l.3-7.5z" clipRule="evenodd" />
                    </svg>
                  </button>
                </div>
              </div>
            ))
          )}
        </div>

        {favorites.length > 0 && (
          <div
            className="px-4 py-2.5 border-t flex items-center"
            style={{ borderColor: 'var(--border)' }}
          >
            <span className="text-xs font-medium" style={{ color: 'var(--muted)' }}>
              {filtered.length} of {favorites.length} saved
            </span>
          </div>
        )}
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
