'use client';

import { useState } from 'react';
import Image from 'next/image';
import { useTheme, type ThemeMode, type FontSize } from '@/components/ThemeProvider';
import { getFavorites } from '@/lib/favorites';

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="mb-6">
      <h2 className="text-xs font-semibold uppercase tracking-wider mb-3" style={{ color: 'var(--muted)' }}>
        {title}
      </h2>
      <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card-bg)', border: '1px solid var(--border)' }}>
        {children}
      </div>
    </div>
  );
}

function Row({ icon, label, sublabel, children }: {
  icon: React.ReactNode;
  label: string;
  sublabel?: string;
  children?: React.ReactNode;
}) {
  return (
    <div className="flex items-center justify-between px-4 py-3.5 border-b last:border-b-0" style={{ borderColor: 'var(--border)' }}>
      <div className="flex items-center gap-3">
        <span style={{ color: 'var(--muted)' }}>{icon}</span>
        <div>
          <p className="text-sm font-medium">{label}</p>
          {sublabel && <p className="text-xs mt-0.5" style={{ color: 'var(--muted)' }}>{sublabel}</p>}
        </div>
      </div>
      {children}
    </div>
  );
}

export default function SettingsPage() {
  const { theme, fontSize, setTheme, setFontSize } = useTheme();
  const [clearConfirm, setClearConfirm] = useState(false);
  const [cleared, setCleared] = useState(false);
  const favCount = typeof window !== 'undefined' ? getFavorites().length : 0;

  function handleClearFavorites() {
    if (!clearConfirm) { setClearConfirm(true); return; }
    localStorage.removeItem('law_library_favorites');
    setCleared(true);
    setClearConfirm(false);
  }

  const themeModes: { value: ThemeMode; label: string; icon: React.ReactNode }[] = [
    {
      value: 'light',
      label: 'Light',
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4">
          <path d="M10 2a.75.75 0 01.75.75v1.5a.75.75 0 01-1.5 0v-1.5A.75.75 0 0110 2zM10 15a.75.75 0 01.75.75v1.5a.75.75 0 01-1.5 0v-1.5A.75.75 0 0110 15zM10 7a3 3 0 100 6 3 3 0 000-6zM15.657 5.404a.75.75 0 10-1.06-1.06l-1.061 1.06a.75.75 0 001.06 1.06l1.06-1.06zM6.464 14.596a.75.75 0 10-1.06-1.06l-1.06 1.06a.75.75 0 001.06 1.06l1.06-1.06zM18 10a.75.75 0 01-.75.75h-1.5a.75.75 0 010-1.5h1.5A.75.75 0 0118 10zM5 10a.75.75 0 01-.75.75h-1.5a.75.75 0 010-1.5h1.5A.75.75 0 015 10zM14.596 15.657a.75.75 0 001.06-1.06l-1.06-1.061a.75.75 0 10-1.06 1.06l1.06 1.06zM5.404 6.464a.75.75 0 001.06-1.06L5.404 4.343a.75.75 0 10-1.06 1.06l1.06 1.061z" />
        </svg>
      ),
    },
    {
      value: 'system',
      label: 'System',
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4">
          <path fillRule="evenodd" d="M2 4.25A2.25 2.25 0 014.25 2h11.5A2.25 2.25 0 0118 4.25v8.5A2.25 2.25 0 0115.75 15h-3.105a3.501 3.501 0 001.1 1.677A.75.75 0 0113.26 18H6.74a.75.75 0 01-.484-1.323A3.501 3.501 0 007.355 15H4.25A2.25 2.25 0 012 12.75v-8.5zm1.5 0a.75.75 0 01.75-.75h11.5a.75.75 0 01.75.75v7.5a.75.75 0 01-.75.75H4.25a.75.75 0 01-.75-.75v-7.5z" clipRule="evenodd" />
        </svg>
      ),
    },
    {
      value: 'dark',
      label: 'Dark',
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4">
          <path fillRule="evenodd" d="M7.455 2.004a.75.75 0 01.26.77 7 7 0 009.958 7.967.75.75 0 011.067.853A8.5 8.5 0 116.647 1.921a.75.75 0 01.808.083z" clipRule="evenodd" />
        </svg>
      ),
    },
  ];

  const fontSizes: { value: FontSize; label: string; preview: string }[] = [
    { value: 'small', label: 'Small', preview: 'Aa' },
    { value: 'medium', label: 'Medium', preview: 'Aa' },
    { value: 'large', label: 'Large', preview: 'Aa' },
  ];

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold mb-6">Settings</h1>

      {/* Appearance */}
      <Section title="Appearance">
        <Row
          icon={
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
              <path fillRule="evenodd" d="M4.5 2A2.5 2.5 0 002 4.5v11A2.5 2.5 0 004.5 18h11a2.5 2.5 0 002.5-2.5V4.5A2.5 2.5 0 0015.5 2h-11zm3 5a1 1 0 000 2h5a1 1 0 100-2h-5zm0 4a1 1 0 100 2h3a1 1 0 100-2h-3z" clipRule="evenodd" />
            </svg>
          }
          label="Theme"
          sublabel="Choose your preferred colour scheme"
        >
          <div className="flex gap-1">
            {themeModes.map((m) => (
              <button
                key={m.value}
                onClick={() => setTheme(m.value)}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium transition ${
                  theme === m.value
                    ? 'bg-blue-900 text-white'
                    : 'hover:bg-gray-100 dark:hover:bg-white/10'
                }`}
                style={theme === m.value ? {} : { color: 'var(--muted)', border: '1px solid var(--border)' }}
              >
                {m.icon}
                {m.label}
              </button>
            ))}
          </div>
        </Row>

        <Row
          icon={
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
              <path fillRule="evenodd" d="M2.5 4A1.5 1.5 0 001 5.5V6h18v-.5A1.5 1.5 0 0017.5 4h-15zM19 8.5H1V14a2 2 0 002 2h14a2 2 0 002-2V8.5zM6 10.25a.75.75 0 01.75-.75h.5a.75.75 0 010 1.5h-.5a.75.75 0 01-.75-.75zm2.25 0a.75.75 0 01.75-.75h.5a.75.75 0 010 1.5h-.5a.75.75 0 01-.75-.75zm2 0a.75.75 0 01.75-.75h.5a.75.75 0 010 1.5h-.5a.75.75 0 01-.75-.75z" clipRule="evenodd" />
            </svg>
          }
          label="Font Size"
          sublabel="Adjust text size across the app"
        >
          <div className="flex gap-1">
            {fontSizes.map((s) => (
              <button
                key={s.value}
                onClick={() => setFontSize(s.value)}
                className={`flex flex-col items-center px-3 py-1.5 rounded-lg transition ${
                  fontSize === s.value
                    ? 'bg-blue-900 text-white'
                    : 'hover:bg-gray-100 dark:hover:bg-white/10'
                }`}
                style={fontSize === s.value ? {} : { color: 'var(--muted)', border: '1px solid var(--border)' }}
              >
                <span
                  className="font-bold leading-none"
                  style={{
                    fontSize: s.value === 'small' ? '11px' : s.value === 'medium' ? '14px' : '17px',
                  }}
                >
                  {s.preview}
                </span>
                <span className="text-[10px] mt-0.5">{s.label}</span>
              </button>
            ))}
          </div>
        </Row>
      </Section>

      {/* Data & Storage */}
      <Section title="Data & Storage">
        <Row
          icon={
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
              <path d="M9.653 16.915l-.005-.003-.019-.01a20.759 20.759 0 01-1.162-.682 22.045 22.045 0 01-2.582-2.184C4.508 12.683 3 10.65 3 8a5 5 0 0110 0c0 2.65-1.508 4.683-2.885 6.036a22.045 22.045 0 01-2.582 2.184 20.76 20.76 0 01-1.162.682l-.019.01-.005.003h-.002a.739.739 0 01-.69 0l-.002-.001z" />
            </svg>
          }
          label="Saved Favorites"
          sublabel={cleared ? 'Favorites cleared' : `${favCount} law${favCount !== 1 ? 's' : ''} saved`}
        >
          <button
            onClick={handleClearFavorites}
            className={`px-3 py-1.5 text-xs font-medium rounded-lg transition ${
              clearConfirm
                ? 'bg-red-600 text-white hover:bg-red-700'
                : 'text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 border border-red-200 dark:border-red-800'
            }`}
          >
            {clearConfirm ? 'Confirm clear' : 'Clear favorites'}
          </button>
        </Row>
      </Section>

      {/* About */}
      <Section title="About">
        <div className="px-6 py-6 flex flex-col items-center text-center">
          <div className="w-16 h-16 rounded-full bg-white flex items-center justify-center mb-4 shadow-sm" style={{ border: '1px solid var(--border)' }}>
            <Image src="/logo.png" alt="Logo" width={52} height={52} className="object-contain" />
          </div>
          <h3 className="text-lg font-bold mb-1">Road Offence Act Library</h3>
          <p className="text-sm mb-1" style={{ color: 'var(--muted)' }}>Version 2.0 — Web Edition</p>
          <p className="text-xs mb-4 max-w-sm leading-relaxed" style={{ color: 'var(--muted)' }}>
            A comprehensive reference tool for Road Traffic Acts and Regulations, designed for officers of the Royal Brunei Police Force.
          </p>
          <div className="flex gap-4 text-xs" style={{ color: 'var(--muted)' }}>
            <span>© 2025 RBPF (Royal Brunei Police Force)</span>
            <span>·</span>
            <span>Capstone Project</span>
          </div>
        </div>
      </Section>
    </div>
  );
}
