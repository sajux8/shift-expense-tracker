-- Actual gross and net pay recorded from a payslip for estimate comparison.
create table if not exists public.payslips (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  workplace_id uuid not null,
  period_start date not null,
  period_end date not null,
  pay_date date,
  gross_amount integer not null check (gross_amount > 0),
  net_amount integer not null check (net_amount >= 0),
  note text not null default '' check (char_length(note) <= 160),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  constraint payslips_valid_period check (period_end >= period_start),
  constraint payslips_workplace_same_user foreign key (workplace_id, user_id)
    references public.workplaces(id, user_id)
);
create index if not exists payslips_user_period_active_idx
  on public.payslips(user_id, period_end desc) where deleted_at is null;
create trigger payslips_set_updated_at before update on public.payslips
for each row execute function public.set_updated_at();
alter table public.payslips enable row level security;
create policy "Users manage their own payslips" on public.payslips
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
grant select, insert, update, delete on public.payslips to authenticated;
revoke all on public.payslips from anon;
