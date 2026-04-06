import type { Law } from '@/types';

const STORAGE_KEY = 'law_library_favorites';

export function getFavorites(): Law[] {
  if (typeof window === 'undefined') return [];
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];
    return JSON.parse(raw) as Law[];
  } catch {
    return [];
  }
}

export function isFavorite(chapter: string): boolean {
  return getFavorites().some((l) => l.Chapter === chapter);
}

export function addFavorite(law: Law): void {
  const favorites = getFavorites();
  if (!favorites.some((l) => l.Chapter === law.Chapter)) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify([...favorites, law]));
  }
}

export function removeFavorite(chapter: string): void {
  const updated = getFavorites().filter((l) => l.Chapter !== chapter);
  localStorage.setItem(STORAGE_KEY, JSON.stringify(updated));
}

export function toggleFavorite(law: Law): boolean {
  if (isFavorite(law.Chapter)) {
    removeFavorite(law.Chapter);
    return false;
  } else {
    addFavorite(law);
    return true;
  }
}
