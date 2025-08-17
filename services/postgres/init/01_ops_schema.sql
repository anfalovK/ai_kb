create schema if not exists ops;
create extension if not exists pgcrypto;

create table if not exists ops.users(
  id uuid primary key default gen_random_uuid(),
  username text unique not null,
  created_at timestamptz default now()
);

create table if not exists ops.projects(
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references ops.users(id) on delete cascade,
  title text not null,
  description text,
  area_index int[],
  tags text[],
  status text not null default 'active',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists ops.tasks(
  id uuid primary key default gen_random_uuid(),
  project_id uuid references ops.projects(id) on delete set null,
  owner_id uuid not null references ops.users(id) on delete cascade,
  title text not null,
  details text,
  priority int default 3,
  status text not null default 'todo',
  due_at timestamptz,
  area_index int[],
  tags text[],
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists ops.events(
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references ops.users(id) on delete cascade,
  title text not null,
  description text,
  starts_at timestamptz not null,
  ends_at timestamptz,
  location text,
  area_index int[],
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists ops.reminders(
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references ops.users(id) on delete cascade,
  title text not null,
  note text,
  remind_at timestamptz,
  rrule text,
  area_index int[],
  is_active boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists idx_tasks_owner_status on ops.tasks (owner_id, status);
create index if not exists idx_tasks_due on ops.tasks (due_at);
create index if not exists idx_events_owner_start on ops.events (owner_id, starts_at);

alter table ops.projects  enable row level security;
alter table ops.tasks     enable row level security;
alter table ops.events    enable row level security;
alter table ops.reminders enable row level security;

do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'ops_api') then
     create role ops_api noinherit;
  end if;
end$$;

grant usage on schema ops to ops_api;
grant select, insert, update, delete on all tables in schema ops to ops_api;

create or replace function ops.current_user_id() returns uuid
language sql stable as $$
  select nullif(current_setting('request.jwt.claims', true)::jsonb->>'user_id','')::uuid
$$;

create policy p_projects_all on ops.projects
  for all using (owner_id = ops.current_user_id()) with check (owner_id = ops.current_user_id());
create policy p_tasks_all on ops.tasks
  for all using (owner_id = ops.current_user_id()) with check (owner_id = ops.current_user_id());
create policy p_events_all on ops.events
  for all using (owner_id = ops.current_user_id()) with check (owner_id = ops.current_user_id());
create policy p_reminders_all on ops.reminders
  for all using (owner_id = ops.current_user_id()) with check (owner_id = ops.current_user_id());
