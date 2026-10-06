-- Run this once in Supabase: SQL Editor > New query > paste > Run.

create table if not exists public.notes (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  kind        text not null default 'thought' check (kind in ('thought', 'todo', 'wish')),
  text        text not null default '',
  tag         text not null default '',
  done        boolean not null default false,
  pinned      boolean not null default false,
  created_at  bigint not null default (extract(epoch from now()) * 1000)::bigint,
  updated_at  bigint
);

-- Added with the to-do filters: 'bada' (big) or 'chotta' (small) for to-dos, empty otherwise.
-- Existing databases: run just the next line in the SQL Editor.
alter table public.notes add column if not exists complexity text not null default '' check (complexity in ('', 'bada', 'chotta'));

create index if not exists notes_user_created_idx on public.notes (user_id, created_at desc);

-- Row-level security: every signed-in user can only see and change their own rows.
alter table public.notes enable row level security;

drop policy if exists "Users manage their own notes" on public.notes;
create policy "Users manage their own notes"
  on public.notes
  for all
  to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

-- Live updates: a note added on your phone appears on your desktop without a refresh.
do $$
begin
  alter publication supabase_realtime add table public.notes;
exception when duplicate_object then null;
end $$;
