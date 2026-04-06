import { getLaw } from '@/lib/api';
import { notFound } from 'next/navigation';
import Link from 'next/link';
import CategoryBadge from '@/components/CategoryBadge';
import FavoriteButton from '@/components/FavoriteButton';

const FINE_LABELS = [
  'Compound Fine',
  '2nd Compound Fine',
  '3rd Compound Fine',
  '4th Compound Fine',
  '5th Compound Fine',
];

const FINE_KEYS = [
  'Compound_Fine',
  'Second_Compound_Fine',
  'Third_Compound_Fine',
  'Fourth_Compound_Fine',
  'Fifth_Compound_Fine',
] as const;

export default async function LawDetailPage(props: {
  params: Promise<{ chapter: string }>;
}) {
  const { chapter } = await props.params;
  const law = await getLaw(decodeURIComponent(chapter));

  if (!law) notFound();

  const fines = FINE_KEYS.map((key, i) => ({
    label: FINE_LABELS[i],
    value: law[key] as string | undefined,
  })).filter((f) => f.value && f.value.trim() !== '');

  return (
    <div className="max-w-3xl mx-auto px-4 py-8">
      {/* Back */}
      <Link
        href="/"
        className="inline-flex items-center gap-1.5 text-sm mb-6 hover:underline"
        style={{ color: 'var(--muted)' }}
      >
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4">
          <path fillRule="evenodd" d="M17 10a.75.75 0 01-.75.75H5.612l4.158 3.96a.75.75 0 11-1.04 1.08l-5.5-5.25a.75.75 0 010-1.08l5.5-5.25a.75.75 0 111.04 1.08L5.612 9.25H16.25A.75.75 0 0117 10z" clipRule="evenodd" />
        </svg>
        Back to Laws
      </Link>

      {/* Header card */}
      <div className="rounded-2xl p-6 mb-4" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
        <div className="flex items-start justify-between gap-4 mb-4">
          <div className="flex items-center gap-2 flex-wrap">
            <span className="text-sm font-mono font-bold px-3 py-1 rounded-lg bg-blue-900 text-white">
              {law.Chapter}
            </span>
            <CategoryBadge category={law.Category} />
          </div>
          <FavoriteButton law={law} />
        </div>
        <h1 className="text-2xl font-bold leading-snug">{law.Title}</h1>
      </div>

      {/* Description */}
      <div className="rounded-2xl p-6 mb-4" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
        <h2 className="text-xs font-semibold uppercase tracking-wide mb-3" style={{ color: 'var(--muted)' }}>
          Description
        </h2>
        <p className="text-sm leading-relaxed">{law.Description}</p>
      </div>

      {/* Compound fines */}
      {fines.length > 0 && (
        <div className="rounded-2xl p-6" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
          <h2 className="text-xs font-semibold uppercase tracking-wide mb-4" style={{ color: 'var(--muted)' }}>
            Compound Fines
          </h2>
          <div className="space-y-3">
            {fines.map((fine, i) => (
              <div
                key={i}
                className="flex items-center justify-between px-4 py-3 rounded-xl"
                style={{ background: 'var(--background)', border: '1px solid var(--border)' }}
              >
                <div className="flex items-center gap-3">
                  <span className="w-6 h-6 rounded-full bg-blue-900 text-white text-xs flex items-center justify-center font-bold shrink-0">
                    {i + 1}
                  </span>
                  <span className="text-sm" style={{ color: 'var(--muted)' }}>{fine.label}</span>
                </div>
                <span className="text-sm font-semibold text-emerald-600 dark:text-emerald-400">
                  {fine.value}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
