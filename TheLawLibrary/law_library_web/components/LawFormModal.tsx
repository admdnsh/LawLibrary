'use client';

import { useState, useEffect } from 'react';
import type { Law } from '@/types';

interface Props {
  law?: Law | null;
  categories: string[];
  onSave: (law: Law, originalChapter?: string) => Promise<void>;
  onClose: () => void;
}

const EMPTY: Law = {
  Chapter: '',
  Category: '',
  Title: '',
  Description: '',
  Compound_Fine: '',
  Second_Compound_Fine: '',
  Third_Compound_Fine: '',
  Fourth_Compound_Fine: '',
  Fifth_Compound_Fine: '',
};

const FINE_FIELDS: { key: keyof Law; label: string }[] = [
  { key: 'Compound_Fine', label: 'Compound Fine' },
  { key: 'Second_Compound_Fine', label: '2nd Compound Fine' },
  { key: 'Third_Compound_Fine', label: '3rd Compound Fine' },
  { key: 'Fourth_Compound_Fine', label: '4th Compound Fine' },
  { key: 'Fifth_Compound_Fine', label: '5th Compound Fine' },
];

export default function LawFormModal({ law, categories, onSave, onClose }: Props) {
  const [form, setForm] = useState<Law>(EMPTY);
  const [originalChapter, setOriginalChapter] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [customCategory, setCustomCategory] = useState('');
  const [useCustomCategory, setUseCustomCategory] = useState(false);

  const isEdit = !!law;

  useEffect(() => {
    if (law) {
      setForm({ ...EMPTY, ...law });
      setOriginalChapter(law.Chapter);
    } else {
      setForm(EMPTY);
      setOriginalChapter('');
    }
  }, [law]);

  function set(key: keyof Law, value: string) {
    setForm((prev) => ({ ...prev, [key]: value }));
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError('');

    const finalCategory = useCustomCategory ? customCategory.trim() : form.Category;
    if (!finalCategory) {
      setError('Category is required');
      return;
    }

    const payload: Law = { ...form, Category: finalCategory };

    setSaving(true);
    try {
      await onSave(payload, isEdit ? originalChapter : undefined);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save law');
    } finally {
      setSaving(false);
    }
  }

  const inputStyle = {
    background: 'var(--background)',
    borderColor: 'var(--border)',
    color: 'var(--foreground)',
  };

  const inputClass =
    'w-full px-3 py-2 rounded-lg border text-sm outline-none focus:ring-2 focus:ring-blue-500 transition';

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      {/* Backdrop */}
      <div className="absolute inset-0 bg-black/50" onClick={onClose} />

      {/* Modal */}
      <div
        className="relative w-full max-w-2xl rounded-2xl shadow-xl overflow-hidden flex flex-col max-h-[90vh]"
        style={{ background: 'var(--card-bg)' }}
      >
        {/* Header */}
        <div
          className="flex items-center justify-between px-6 py-4 border-b shrink-0"
          style={{ borderColor: 'var(--border)' }}
        >
          <h2 className="text-lg font-bold">{isEdit ? 'Edit Law' : 'Add New Law'}</h2>
          <button
            onClick={onClose}
            className="p-1.5 rounded-lg transition"
            style={{ color: 'var(--muted)' }}
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5">
              <path fillRule="evenodd" d="M5.47 5.47a.75.75 0 011.06 0L12 10.94l5.47-5.47a.75.75 0 111.06 1.06L13.06 12l5.47 5.47a.75.75 0 11-1.06 1.06L12 13.06l-5.47 5.47a.75.75 0 01-1.06-1.06L10.94 12 5.47 6.53a.75.75 0 010-1.06z" clipRule="evenodd" />
            </svg>
          </button>
        </div>

        {/* Body */}
        <form onSubmit={handleSubmit} className="overflow-y-auto flex-1">
          <div className="px-6 py-4 space-y-4">
            {/* Chapter + Category row */}
            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="block text-xs font-semibold mb-1.5 uppercase tracking-wide" style={{ color: 'var(--muted)' }}>
                  Chapter *
                </label>
                <input
                  type="text"
                  value={form.Chapter}
                  onChange={(e) => set('Chapter', e.target.value)}
                  required
                  className={inputClass}
                  style={inputStyle}
                  placeholder="e.g. 68:01"
                />
              </div>
              <div>
                <label className="block text-xs font-semibold mb-1.5 uppercase tracking-wide" style={{ color: 'var(--muted)' }}>
                  Category *
                </label>
                {useCustomCategory ? (
                  <div className="flex gap-2">
                    <input
                      type="text"
                      value={customCategory}
                      onChange={(e) => setCustomCategory(e.target.value)}
                      className={`${inputClass} flex-1`}
                      style={inputStyle}
                      placeholder="New category"
                    />
                    <button
                      type="button"
                      onClick={() => setUseCustomCategory(false)}
                      className="text-xs px-2 rounded-lg border"
                      style={{ borderColor: 'var(--border)', color: 'var(--muted)' }}
                    >
                      List
                    </button>
                  </div>
                ) : (
                  <div className="flex gap-2">
                    <select
                      value={form.Category}
                      onChange={(e) => set('Category', e.target.value)}
                      required={!useCustomCategory}
                      className={`${inputClass} flex-1`}
                      style={inputStyle}
                    >
                      <option value="">Select...</option>
                      {categories.map((c) => (
                        <option key={c} value={c}>{c}</option>
                      ))}
                    </select>
                    <button
                      type="button"
                      onClick={() => setUseCustomCategory(true)}
                      className="text-xs px-2 rounded-lg border whitespace-nowrap"
                      style={{ borderColor: 'var(--border)', color: 'var(--muted)' }}
                    >
                      New
                    </button>
                  </div>
                )}
              </div>
            </div>

            {/* Title */}
            <div>
              <label className="block text-xs font-semibold mb-1.5 uppercase tracking-wide" style={{ color: 'var(--muted)' }}>
                Title *
              </label>
              <input
                type="text"
                value={form.Title}
                onChange={(e) => set('Title', e.target.value)}
                required
                className={inputClass}
                style={inputStyle}
                placeholder="Law title"
              />
            </div>

            {/* Description */}
            <div>
              <label className="block text-xs font-semibold mb-1.5 uppercase tracking-wide" style={{ color: 'var(--muted)' }}>
                Description
              </label>
              <textarea
                value={form.Description}
                onChange={(e) => set('Description', e.target.value)}
                rows={4}
                className={`${inputClass} resize-none`}
                style={inputStyle}
                placeholder="Full law description..."
              />
            </div>

            {/* Compound fines */}
            <div>
              <label className="block text-xs font-semibold mb-2 uppercase tracking-wide" style={{ color: 'var(--muted)' }}>
                Compound Fines
              </label>
              <div className="space-y-2">
                {FINE_FIELDS.map(({ key, label }) => (
                  <div key={key} className="flex items-center gap-3">
                    <span className="text-xs w-36 shrink-0" style={{ color: 'var(--muted)' }}>
                      {label}
                    </span>
                    <input
                      type="text"
                      value={(form[key] as string) || ''}
                      onChange={(e) => set(key, e.target.value)}
                      className={`${inputClass} flex-1`}
                      style={inputStyle}
                      placeholder="e.g. BND500"
                    />
                  </div>
                ))}
              </div>
            </div>

            {error && (
              <div className="px-3 py-2 rounded-lg bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
                {error}
              </div>
            )}
          </div>

          {/* Footer */}
          <div
            className="flex items-center justify-end gap-3 px-6 py-4 border-t shrink-0"
            style={{ borderColor: 'var(--border)' }}
          >
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 text-sm rounded-lg border transition"
              style={{ borderColor: 'var(--border)', color: 'var(--foreground)' }}
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={saving}
              className="px-4 py-2 text-sm font-semibold rounded-lg bg-blue-900 text-white hover:bg-blue-800 transition disabled:opacity-60 flex items-center gap-2"
            >
              {saving && <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />}
              {saving ? 'Saving...' : isEdit ? 'Update Law' : 'Create Law'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
