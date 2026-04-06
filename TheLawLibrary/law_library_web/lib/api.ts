import type { Law, ApiResponse } from '@/types';

const BASE_URL = 'https://law-library-api-production.up.railway.app';

export interface LawsParams {
  page?: number;
  limit?: number;
  search?: string;
  category?: string;
}

export async function getLaws(params: LawsParams = {}): Promise<Law[]> {
  const query = new URLSearchParams({
    page: String(params.page ?? 1),
    limit: String(params.limit ?? 15),
  });
  if (params.search) query.set('search', params.search);
  if (params.category) query.set('category', params.category);

  const res = await fetch(`${BASE_URL}/get_laws.php?${query}`, { cache: 'no-store' });
  if (!res.ok) throw new Error('Failed to fetch laws');
  const data = await res.json();
  if (!Array.isArray(data)) return [];
  return data;
}

export async function getLaw(chapter: string): Promise<Law | null> {
  const res = await fetch(
    `${BASE_URL}/get_law.php?chapter=${encodeURIComponent(chapter)}`,
    { cache: 'no-store' }
  );
  if (!res.ok) return null;
  const data = await res.json();
  if (data?.error) return null;
  return data;
}

export async function getCategories(): Promise<string[]> {
  const res = await fetch(`${BASE_URL}/get_categories.php`, {
    next: { revalidate: 3600 },
  });
  if (!res.ok) return [];
  const data = await res.json();
  if (!Array.isArray(data)) return [];
  // API returns [{Category: "..."}, ...] — extract the string value
  if (data.length > 0 && typeof data[0] === 'object') {
    return data.map((item: Record<string, string>) => Object.values(item)[0]).filter(Boolean);
  }
  return data;
}

export async function getLawCount(): Promise<number> {
  const res = await fetch(`${BASE_URL}/get_law_count.php`, { cache: 'no-store' });
  if (!res.ok) return 0;
  const data = await res.json();
  return data?.total_laws ?? 0;
}

export async function login(
  username: string,
  password: string
): Promise<{ success: boolean; message: string; user?: { Username: string; isAdmin: number } }> {
  const body = new URLSearchParams({ username, password });
  const res = await fetch(`${BASE_URL}/login.php`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: body.toString(),
  });
  return res.json();
}

export async function createLaw(law: Law): Promise<ApiResponse> {
  const res = await fetch(`${BASE_URL}/create_law.php`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(law),
  });
  return res.json();
}

export async function updateLaw(law: Law & { Original_Chapter: string }): Promise<ApiResponse> {
  const res = await fetch(`${BASE_URL}/update_law.php`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(law),
  });
  return res.json();
}

export async function deleteLaw(chapter: string): Promise<ApiResponse> {
  const res = await fetch(`${BASE_URL}/delete_law.php`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ Chapter: chapter }),
  });
  return res.json();
}
