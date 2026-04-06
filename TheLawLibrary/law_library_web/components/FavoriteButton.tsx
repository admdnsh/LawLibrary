'use client';

import { useEffect, useState } from 'react';
import type { Law } from '@/types';
import { isFavorite, toggleFavorite } from '@/lib/favorites';

export default function FavoriteButton({ law }: { law: Law }) {
  const [favorited, setFavorited] = useState(false);

  useEffect(() => {
    setFavorited(isFavorite(law.Chapter));
  }, [law.Chapter]);

  function handleClick() {
    const next = toggleFavorite(law);
    setFavorited(next);
  }

  return (
    <button
      onClick={handleClick}
      className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-sm font-medium transition ${
        favorited
          ? 'bg-amber-400 text-amber-900 hover:bg-amber-300'
          : 'border hover:bg-amber-50 dark:hover:bg-amber-900/20'
      }`}
      style={favorited ? {} : { borderColor: 'var(--border)', color: 'var(--muted)' }}
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-4 h-4">
        <path fillRule="evenodd" d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.007 5.404.433c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.433 2.082-5.006z" clipRule="evenodd" />
      </svg>
      {favorited ? 'Saved' : 'Save'}
    </button>
  );
}
