import type { Metadata } from 'next';
import { Geist } from 'next/font/google';
import './globals.css';
import AppShell from '@/components/AppShell';
import { ThemeProvider } from '@/components/ThemeProvider';

const geist = Geist({
  variable: '--font-geist-sans',
  subsets: ['latin'],
});

export const metadata: Metadata = {
  title: 'Road Offence Act Library',
  description: 'Search and browse Road Traffic Acts (RTA) and Road Traffic Regulations (RTR)',
  icons: {
    icon: '/logo.png',
    apple: '/logo.png',
  },
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en" className={`${geist.variable} h-full`} suppressHydrationWarning>
      <body className="h-full flex flex-col lg:flex-row antialiased">
        <ThemeProvider>
          <AppShell>{children}</AppShell>
        </ThemeProvider>
      </body>
    </html>
  );
}
