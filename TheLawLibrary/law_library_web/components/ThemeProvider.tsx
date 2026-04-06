'use client';

import { createContext, useContext, useEffect, useState } from 'react';

export type ThemeMode = 'light' | 'system' | 'dark';
export type FontSize = 'small' | 'medium' | 'large';

const FONT_SCALE: Record<FontSize, string> = {
  small: '14px',
  medium: '16px',
  large: '18px',
};

interface ThemeContextValue {
  theme: ThemeMode;
  resolvedTheme: 'light' | 'dark';
  fontSize: FontSize;
  setTheme: (t: ThemeMode) => void;
  setFontSize: (s: FontSize) => void;
  toggle: () => void;
}

const ThemeContext = createContext<ThemeContextValue>({
  theme: 'system',
  resolvedTheme: 'light',
  fontSize: 'medium',
  setTheme: () => {},
  setFontSize: () => {},
  toggle: () => {},
});

function applyTheme(mode: ThemeMode) {
  const isDark =
    mode === 'dark' ||
    (mode === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches);
  document.documentElement.classList.toggle('dark', isDark);
  return isDark ? 'dark' : 'light';
}

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setThemeState] = useState<ThemeMode>('system');
  const [resolvedTheme, setResolvedTheme] = useState<'light' | 'dark'>('light');
  const [fontSize, setFontSizeState] = useState<FontSize>('medium');

  useEffect(() => {
    const storedTheme = (localStorage.getItem('theme') as ThemeMode) ?? 'system';
    const storedFont = (localStorage.getItem('fontSize') as FontSize) ?? 'medium';

    setThemeState(storedTheme);
    setFontSizeState(storedFont);
    setResolvedTheme(applyTheme(storedTheme));
    document.documentElement.style.fontSize = FONT_SCALE[storedFont];
  }, []);

  function setTheme(mode: ThemeMode) {
    setThemeState(mode);
    localStorage.setItem('theme', mode);
    setResolvedTheme(applyTheme(mode));
  }

  function setFontSize(size: FontSize) {
    setFontSizeState(size);
    localStorage.setItem('fontSize', size);
    document.documentElement.style.fontSize = FONT_SCALE[size];
  }

  function toggle() {
    setTheme(resolvedTheme === 'light' ? 'dark' : 'light');
  }

  return (
    <ThemeContext.Provider value={{ theme, resolvedTheme, fontSize, setTheme, setFontSize, toggle }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  return useContext(ThemeContext);
}
