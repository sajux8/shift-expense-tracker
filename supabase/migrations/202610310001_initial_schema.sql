-- Shiftly initial cloud schema. Apply through the Supabase SQL editor or CLI.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table public.workplaces (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(trim(name)) between 1 and 60),
  hourly_rate integer not null check (hourly_rate > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table public.shifts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  workplace_id uuid references public.workplaces(id) on delete set null,
  workplace_name text not null,
  shift_date date not null,
  start_time time not null,
  end_time time not null,
  break_minutes integer not null default 0 check (break_minutes between 0 and 600),
  hourly_rate integer not null check (hourly_rate > 0),
  tips integer not null default 0 check (tips >= 0),
  note text not null default '' check (char_length(note) <= 160),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  constraint shifts_different_start_and_end check (start_time <> end_time)
);

create table public.expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  amount integer not null check (amount > 0),
  expense_date date not null,
  category text not null check (char_length(trim(category)) between 1 and 60),
  payment_method text not null default 'Cash',
  note text not null default '' check (char_length(note) <= 160),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index workplaces_user_active_idx on public.workplaces(user_id, name) where deleted_at is null;
create index shifts_user_date_active_idx on public.shifts(user_id, shift_date desc) where deleted_at is null;
create index expenses_user_date_active_idx on public.expenses(user_id, expense_date desc) where deleted_at is null;

create trigger workplaces_set_updated_at before update on public.workplaces
for each row execute function public.set_updated_at();
create trigger shifts_set_updated_at before update on public.shifts
for each row execute function public.set_updated_at();
create trigger expenses_set_updated_at before update on public.expenses
for each row execute function public.set_updated_at();

alter table public.workplaces enable row level security;
alter table public.shifts enable row level security;
alter table public.expenses enable row level security;

create policy "Users manage their own workplaces" on public.workplaces
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
create policy "Users manage their own shifts" on public.shifts
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
create policy "Users manage their own expenses" on public.expenses
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.workplaces, public.shifts, public.expenses to authenticated;
revoke all on public.workplaces, public.shifts, public.expenses from anon;
