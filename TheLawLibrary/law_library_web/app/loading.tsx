export default function Loading() {
  return (
    <div className="flex h-screen overflow-hidden">
      <div className="flex flex-col w-full lg:w-96 xl:w-[420px] shrink-0 border-r" style={{ borderColor: 'var(--border)' }}>
        <div className="p-4 border-b" style={{ borderColor: 'var(--border)', background: 'var(--card-bg)' }}>
          <div className="h-9 rounded-lg animate-pulse mb-3" style={{ background: 'var(--border)' }} />
          <div className="flex gap-1.5">
            {[60, 80, 70, 90].map((w, i) => (
              <div key={i} className="h-6 rounded-full animate-pulse" style={{ background: 'var(--border)', width: `${w}px` }} />
            ))}
          </div>
        </div>
        <div className="flex-1 overflow-hidden">
          {Array.from({ length: 8 }).map((_, i) => (
            <div key={i} className="px-4 py-3 border-b" style={{ borderColor: 'var(--border)' }}>
              <div className="flex justify-between mb-2">
                <div className="h-4 w-16 rounded animate-pulse" style={{ background: 'var(--border)' }} />
                <div className="h-4 w-20 rounded animate-pulse" style={{ background: 'var(--border)' }} />
              </div>
              <div className="h-4 w-full rounded animate-pulse mb-1" style={{ background: 'var(--border)' }} />
              <div className="h-4 w-3/4 rounded animate-pulse" style={{ background: 'var(--border)' }} />
            </div>
          ))}
        </div>
      </div>
      <div className="flex-1 hidden lg:flex items-center justify-center" style={{ background: 'var(--card-bg)' }}>
        <div className="w-8 h-8 border-2 border-blue-900 border-t-transparent rounded-full animate-spin" />
      </div>
    </div>
  );
}
