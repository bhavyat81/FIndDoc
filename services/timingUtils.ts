import { Timings } from '../types';

const DAY_KEYS = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
const DAY_LABELS: Record<string, string> = {
  mon: 'Mon', tue: 'Tue', wed: 'Wed', thu: 'Thu',
  fri: 'Fri', sat: 'Sat', sun: 'Sun',
};

export function todayKey(): string {
  return DAY_KEYS[new Date().getDay() === 0 ? 6 : new Date().getDay() - 1];
}

function parseTime(time: string): number {
  const [h, m] = time.split(':').map(Number);
  return h * 60 + m;
}

function formatTime(time: string): string {
  const [h, m] = time.split(':').map(Number);
  const period = h >= 12 ? 'PM' : 'AM';
  const hour = h > 12 ? h - 12 : h === 0 ? 12 : h;
  return m === 0 ? `${hour} ${period}` : `${hour}:${String(m).padStart(2, '0')} ${period}`;
}

export function isOpenNow(timings: Timings): boolean {
  const slots = timings[todayKey()];
  if (!slots || slots.length === 0) return false;
  const now = new Date();
  const nowMinutes = now.getHours() * 60 + now.getMinutes();
  return slots.some(slot => nowMinutes >= parseTime(slot.from) && nowMinutes <= parseTime(slot.to));
}

export function todayTimingString(timings: Timings): string {
  const slots = timings[todayKey()];
  if (!slots || slots.length === 0) return 'Closed today';
  return slots.map(s => `${formatTime(s.from)} – ${formatTime(s.to)}`).join(', ');
}

export function weeklyTimingSummary(timings: Timings): string {
  return DAY_KEYS.map(day => {
    const slots = timings[day];
    if (!slots || slots.length === 0) return `${DAY_LABELS[day]}: Closed`;
    const timeStr = slots.map(s => `${formatTime(s.from)} – ${formatTime(s.to)}`).join(', ');
    return `${DAY_LABELS[day]}: ${timeStr}`;
  }).join('\n');
}
