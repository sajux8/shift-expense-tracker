-- Bill occurrences. Repeating bills create the next occurrence in the client.
create table if not exists public.bills (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  series_id uuid not null,
  name text not null check (char_length(trim(name)) between 1 and 60),
  amount integer not null check (amount > 0),
  category text not null check (char_length(trim(category)) between 1 and 60),
  due_date date not null,
  anchor_day smallint not null check (anchor_day between 1 and 31),
  anchor_month smallint not null check (anchor_month between 1 and 12),
  frequency text not null check (frequency in ('once', 'weekly', 'monthly', 'yearly')),
  status text not null default 'pending' check (status in ('pending', 'paid', 'skipped')),
  payment_method text not null default 'Bank transfer',
  note text not null default '' check (char_length(note) <= 160),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);
create index if not exists bills_user_due_active_idx
  on public.bills(user_id, due_date) where deleted_at is null;
create index if not exists bills_user_series_active_idx
  on public.bills(user_id, series_id) where deleted_at is null;
create trigger bills_set_updated_at before update on public.bills
for each row execute function public.set_updated_at();
alter table public.bills enable row level security;
create policy "Users manage their own bills" on public.bills
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
grant select, insert, update, delete on public.bills to authenticated;
revoke all on public.bills from anon;
