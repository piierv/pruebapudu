
-- Recomendado: activar Realtime en las tablas necesarias desde el panel si quieres inserts/updates en vivo.

create table if not exists public.sessions (
  session_id text primary key,
  presentor_uid uuid references auth.users(id) on delete cascade,
  created_at timestamp with time zone default now()
);

create table if not exists public.attendance (
  id bigserial primary key,
  session_id text references public.sessions(session_id) on delete cascade,
  user_id text,
  user_name text,
  joined_at timestamp with time zone default now(),
  left_at timestamp with time zone
);

create table if not exists public.reactions (
  id bigserial primary key,
  session_id text references public.sessions(session_id) on delete cascade,
  kind text check (kind in ('love','clap','question','thumbsup','thumbsdown')),
  user_id text,
  created_at timestamp with time zone default now()
);

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  session_id text references public.sessions(session_id) on delete cascade,
  type text,
  title text,
  options jsonb,
  created_at timestamp with time zone default now()
);

-- Opcional: archivos reportados por espectadores
create table if not exists public.spectator_files (
  id bigserial primary key,
  session_id text references public.sessions(session_id) on delete cascade,
  user_id text,
  user_name text,
  file_name text,
  file_url text,
  created_at timestamp with time zone default now()
);

-- Políticas simples (ajusta según lo que necesites)
alter table public.sessions enable row level security;
alter table public.attendance enable row level security;
alter table public.reactions enable row level security;
alter table public.questions enable row level security;
alter table public.spectator_files enable row level security;

create policy "read all sessions"
  on public.sessions for select
  using (true);

create policy "insert own sessions"
  on public.sessions for insert
  with check (auth.uid() = presentor_uid);

create policy "owner can delete session"
  on public.sessions for delete
  using (auth.uid() = presentor_uid);

create policy "attendance everyone can insert/select"
  on public.attendance for select
  using (true);
create policy "attendance insert"
  on public.attendance for insert
  with check (true);
create policy "attendance update"
  on public.attendance for update
  using (true);

create policy "reactions read/insert"
  on public.reactions for select using (true);
create policy "reactions insert"
  on public.reactions for insert with check (true);

create policy "questions read"
  on public.questions for select using (true);
create policy "questions insert"
  on public.questions for insert with check (true);

create policy "spectator_files read"
  on public.spectator_files for select using (true);
create policy "spectator_files insert"
  on public.spectator_files for insert with check (true);


-- ===== EXAMS (en tiempo real) =====
create table if not exists public.exams (
  id uuid primary key default gen_random_uuid(),
  session_id text references public.sessions(session_id) on delete cascade,
  title text not null,
  questions jsonb not null, -- [{q:"...", type:"single|multi|open", options:["A","B",..."]}]
  created_at timestamptz default now()
);

create table if not exists public.exam_answers (
  id uuid primary key default gen_random_uuid(),
  exam_id uuid references public.exams(id) on delete cascade,
  user_id text,
  user_name text,
  answers jsonb not null, -- [{idx:0, value:"A"|"[A,B]"|"texto"}]
  created_at timestamptz default now()
);

alter table public.exams enable row level security;
alter table public.exam_answers enable row level security;

create policy "exams read"
  on public.exams for select using (true);
create policy "exams insert"
  on public.exams for insert with check (true);

create policy "exam_answers read"
  on public.exam_answers for select using (true);
create policy "exam_answers insert"
  on public.exam_answers for insert with check (true);
