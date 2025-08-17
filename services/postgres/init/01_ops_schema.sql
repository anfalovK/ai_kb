CREATE SCHEMA IF NOT EXISTS ops;

CREATE TABLE ops.users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE ops.projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES ops.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE ops.tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES ops.projects(id) ON DELETE CASCADE,
  title text NOT NULL,
  due_date date,
  done boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE ops.events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES ops.projects(id) ON DELETE CASCADE,
  title text NOT NULL,
  starts_at timestamptz,
  ends_at timestamptz,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE ops.reminders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid REFERENCES ops.tasks(id) ON DELETE CASCADE,
  remind_at timestamptz,
  created_at timestamptz DEFAULT now()
);

CREATE ROLE ops_api NOLOGIN;

ALTER DEFAULT PRIVILEGES IN SCHEMA ops GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ops_api;
ALTER DEFAULT PRIVILEGES IN SCHEMA ops GRANT USAGE, SELECT ON SEQUENCES TO ops_api;
GRANT USAGE ON SCHEMA ops TO ops_api;

CREATE OR REPLACE FUNCTION ops.current_user_id() RETURNS uuid AS $$
  SELECT nullif(current_setting('request.jwt.claim.sub', true), '')::uuid;
$$ LANGUAGE sql STABLE;

ALTER TABLE ops.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE ops.reminders ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_own_users ON ops.users
  FOR SELECT USING (id = ops.current_user_id());

CREATE POLICY select_own_projects ON ops.projects
  FOR ALL USING (user_id = ops.current_user_id())
  WITH CHECK (user_id = ops.current_user_id());

CREATE POLICY select_own_tasks ON ops.tasks
  FOR ALL USING (project_id IN (SELECT id FROM ops.projects WHERE user_id = ops.current_user_id()))
  WITH CHECK (project_id IN (SELECT id FROM ops.projects WHERE user_id = ops.current_user_id()));

CREATE POLICY select_own_events ON ops.events
  FOR ALL USING (project_id IN (SELECT id FROM ops.projects WHERE user_id = ops.current_user_id()))
  WITH CHECK (project_id IN (SELECT id FROM ops.projects WHERE user_id = ops.current_user_id()));

CREATE POLICY select_own_reminders ON ops.reminders
  FOR ALL USING (task_id IN (
    SELECT id FROM ops.tasks WHERE project_id IN (SELECT id FROM ops.projects WHERE user_id = ops.current_user_id())
  ))
  WITH CHECK (task_id IN (
    SELECT id FROM ops.tasks WHERE project_id IN (SELECT id FROM ops.projects WHERE user_id = ops.current_user_id())
  ));

CREATE INDEX ON ops.projects(user_id);
CREATE INDEX ON ops.tasks(project_id);
CREATE INDEX ON ops.events(project_id);
CREATE INDEX ON ops.reminders(task_id);
