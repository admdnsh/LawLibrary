const CATEGORY_COLORS: Record<string, string> = {
  Traffic: 'bg-blue-100 text-blue-800 dark:bg-blue-900/40 dark:text-blue-300',
  Road: 'bg-blue-100 text-blue-800 dark:bg-blue-900/40 dark:text-blue-300',
  Business: 'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-300',
  Environmental: 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900/40 dark:text-emerald-300',
  Safety: 'bg-orange-100 text-orange-800 dark:bg-orange-900/40 dark:text-orange-300',
  Health: 'bg-pink-100 text-pink-800 dark:bg-pink-900/40 dark:text-pink-300',
  Criminal: 'bg-red-100 text-red-800 dark:bg-red-900/40 dark:text-red-300',
  Civil: 'bg-purple-100 text-purple-800 dark:bg-purple-900/40 dark:text-purple-300',
  Labor: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/40 dark:text-yellow-300',
};

function hashColor(str: string): string {
  const colors = [
    'bg-slate-100 text-slate-800 dark:bg-slate-800 dark:text-slate-300',
    'bg-indigo-100 text-indigo-800 dark:bg-indigo-900/40 dark:text-indigo-300',
    'bg-cyan-100 text-cyan-800 dark:bg-cyan-900/40 dark:text-cyan-300',
    'bg-teal-100 text-teal-800 dark:bg-teal-900/40 dark:text-teal-300',
    'bg-violet-100 text-violet-800 dark:bg-violet-900/40 dark:text-violet-300',
  ];
  let hash = 0;
  for (let i = 0; i < str.length; i++) hash = (hash * 31 + str.charCodeAt(i)) & 0xffff;
  return colors[hash % colors.length];
}

export default function CategoryBadge({ category }: { category: string }) {
  const colorClass =
    Object.entries(CATEGORY_COLORS).find(([key]) =>
      category.toLowerCase().includes(key.toLowerCase())
    )?.[1] ?? hashColor(category);

  return (
    <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${colorClass}`}>
      {category}
    </span>
  );
}
