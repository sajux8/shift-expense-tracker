-- Shiftly reusable shift templates. Apply once in Supabase SQL Editor.
create table if not exists public.shift_templates (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  workplace_id uuid not null,
  name text not null check (char_length(trim(name)) between 1 and 50),
  start_time time not null,
  end_time time not null,
  break_minutes integer not null default 0 check (break_minutes between 0 and 600),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  constraint shift_templates_workplace_same_user foreign key (workplace_id, user_id)
    references public.workplaces(id, user_id),
  constraint shift_templates_different_start_and_end check (start_time <> end_time)
);
create index if not exists shift_templates_user_name_active_idx
  on public.shift_templates(user_id, name) where deleted_at is null;
create trigger shift_templates_set_updated_at before update on public.shift_templates
for each row execute function public.set_updated_at();
alter table public.shift_templates enable row level security;
create policy "Users manage their own shift templates" on public.shift_templates
for all to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
grant select, insert, update, delete on public.shift_templates to authenticated;
revoke all on public.shift_templates from anon;
