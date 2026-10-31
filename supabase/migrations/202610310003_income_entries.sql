-- Shiftly extra income entries (tips, service charge, bonuses, and other income).
create table if not exists public.income_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  amount integer not null check (amount > 0),
  entry_date date not null,
  income_type text not null check (income_type in ('tips', 'service_charge', 'bonus', 'other')),
  workplace_id uuid,
  note text not null default '' check (char_length(note) <= 160),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  constraint income_entries_workplace_same_user foreign key (workplace_id, user_id)
    references public.workplaces(id, user_id)
);
create index if not exists income_entries_user_date_active_idx
  on public.income_entries(user_id, entry_date desc) where deleted_at is null;
create trigger income_entries_set_updated_at before update on public.income_entries
for each row execute function public.set_updated_at();
alter table public.income_entries enable row level security;
create policy "Users manage their own income entries" on public.income_entries
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
grant select, insert, update, delete on public.income_entries to authenticated;
revoke all on public.income_entries from anon;
