'use client';

import { useEffect, useState } from 'react';
import type { Law } from '@/types';
import CategoryBadge from './CategoryBadge';
import { isFavorite, toggleFavorite } from '@/lib/favorites';

const FINE_LABELS = [
  'Compound Fine',
  '2nd Compound Fine',
  '3rd Compound Fine',
  '4th Compound Fine',
  '5th Compound Fine',
];

const FINE_KEYS: (keyof Law)[] = [
  'Compound_Fine',
  'Second_Compound_Fine',
  'Third_Compound_Fine',
  'Fourth_Compound_Fine',
  'Fifth_Compound_Fine',
];

interface Props {
  law: Law | null;
  onClose?: () => void;
}

export default function LawDetailPanel({ law, onClose }: Props) {
  const [favorited, setFavorited] = useState(false);

  useEffect(() => {
    if (law) setFavorited(isFavorite(law.Chapter));
  }, [law]);

  if (!law) {
    return (
      <div className="flex flex-col items-center justify-center h-full text-center p-8">
        <div
          className="w-20 h-20 rounded-2xl flex items-center justify-center mb-5"
          style={{ background: 'var(--background)', border: '1px solid var(--border)' }}
        >
          <svg xmlns="http://www.w3.org/2000/svg" className="w-10 h-10 opacity-20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
          </svg>
        </div>
        <p className="font-semibold mb-1.5">Select a law to view details</p>
        <p className="text-xs" style={{ color: 'var(--muted)' }}>Browse the list on the left to get started</p>
      </div>
    );
  }

  const fines = FINE_KEYS.map((key, i) => ({
    label: FINE_LABELS[i],
    value: law[key] as string | undefined,
  })).filter((f) => f.value && f.value.trim() !== '');

  function handleFavorite() {
    const next = toggleFavorite(law!);
    setFavorited(next);
  }

  return (
    <div className="h-full overflow-y-auto">
      {/* Top header strip */}
      <div className="px-6 pt-5 pb-4 border-b" style={{ borderColor: 'var(--border)' }}>
        <div className="flex items-start justify-between gap-4">
          <div className="flex items-center gap-2 flex-wrap">
            <span className="text-xs font-mono font-semibold px-2.5 py-1 rounded-lg bg-blue-900 text-white tracking-wide">
              {law.Chapter}
            </span>
            <CategoryBadge category={law.Category} />
          </div>
          <div className="flex items-center gap-1 shrink-0">
            <button
              onClick={handleFavorite}
              className={`p-2 rounded-lg transition-colors ${
                favorited
                  ? 'text-amber-500 bg-amber-50 dark:bg-amber-900/20 hover:bg-amber-100 dark:hover:bg-amber-900/30'
                  : 'text-gray-400 hover:text-amber-500 hover:bg-amber-50 dark:hover:bg-amber-900/10'
              }`}
              title={favorited ? 'Remove from favorites' : 'Add to favorites'}
            >
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5">
                <path fillRule="evenodd" d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.007 5.404.433c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.433 2.082-5.006z" clipRule="evenodd" />
              </svg>
            </button>
            {onClose && (
              <button
                onClick={onClose}
                className="p-2 rounded-lg transition-colors hover:bg-gray-100 dark:hover:bg-white/10"
                style={{ color: 'var(--muted)' }}
              >
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5">
                  <path fillRule="evenodd" d="M5.47 5.47a.75.75 0 011.06 0L12 10.94l5.47-5.47a.75.75 0 111.06 1.06L13.06 12l5.47 5.47a.75.75 0 11-1.06 1.06L12 13.06l-5.47 5.47a.75.75 0 01-1.06-1.06L10.94 12 5.47 6.53a.75.75 0 010-1.06z" clipRule="evenodd" />
                </svg>
              </button>
            )}
          </div>
        </div>

        {/* Title */}
        <h2 className="text-xl font-bold mt-3 leading-snug">{law.Title}</h2>
      </div>

      <div className="px-6 py-5 space-y-5">
        {/* Description */}
        <div
          className="rounded-xl p-4"
          style={{
            background: 'var(--background)',
            border: '1px solid var(--border)',
            borderLeft: '3px solid var(--accent-blue)',
          }}
        >
          <h3 className="text-xs font-semibold uppercase tracking-wider mb-2.5" style={{ color: 'var(--muted)' }}>
            Description
          </h3>
          <p className="text-sm leading-relaxed">{law.Description}</p>
        </div>

        {/* Compound Fines */}
        {fines.length > 0 ? (
          <div>
            <h3 className="text-xs font-semibold uppercase tracking-wider mb-3" style={{ color: 'var(--muted)' }}>
              Compound Fines
            </h3>
            <div className="space-y-2">
              {fines.map((fine, i) => (
                <div
                  key={i}
                  className="flex items-center justify-between px-4 py-3 rounded-xl"
                  style={{
                    background: 'var(--background)',
                    border: '1px solid var(--border)',
                    borderLeft: i === 0 ? '3px solid var(--accent-green)' : '1px solid var(--border)',
                  }}
                >
                  <span className="text-sm" style={{ color: 'var(--muted)' }}>{fine.label}</span>
                  <span className={`font-bold tabular-nums ${i === 0 ? 'text-base text-emerald-600 dark:text-emerald-400' : 'text-sm text-emerald-600/80 dark:text-emerald-400/80'}`}>
                    {fine.value}
                  </span>
                </div>
              ))}
            </div>
          </div>
        ) : (
          <p className="text-sm italic" style={{ color: 'var(--muted)' }}>No compound fine information available.</p>
        )}
      </div>
    </div>
  );
}
