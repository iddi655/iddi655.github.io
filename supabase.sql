-- mix.io backend: paste all of this into Supabase SQL Editor and press Run

-- public leaderboard row (one per player)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null default 'player' check (char_length(name) between 1 and 24),
  chroma numeric not null default 0 check (chroma between 0 and 100),
  wr numeric not null default 0 check (wr between 0 and 100000),
  score numeric not null default 0,
  level int not null default 1 check (level between 1 and 1000000),
  found int not null default 0 check (found between 0 and 5000),
  dna text check (dna ~ '^#[0-9A-Fa-f]{6}$'),
  updated_at timestamptz not null default now()
);
create index if not exists profiles_score_idx on public.profiles (score desc);

-- private cloud save (only the owner can read/write)
create table if not exists public.saves (
  id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.saves enable row level security;

drop policy if exists "leaderboard is public" on public.profiles;
create policy "leaderboard is public" on public.profiles for select using (true);
drop policy if exists "insert own profile" on public.profiles;
create policy "insert own profile" on public.profiles for insert with check (auth.uid() = id);
drop policy if exists "update own profile" on public.profiles;
create policy "update own profile" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "read own save" on public.saves;
create policy "read own save" on public.saves for select using (auth.uid() = id);
drop policy if exists "insert own save" on public.saves;
create policy "insert own save" on public.saves for insert with check (auth.uid() = id);
drop policy if exists "update own save" on public.saves;
create policy "update own save" on public.saves for update using (auth.uid() = id) with check (auth.uid() = id);

-- score = chroma, plus world points once past 100 (keeps sorting simple)
create or replace function public.mixio_score() returns trigger language plpgsql as $$
begin new.score := new.chroma + new.wr / 1000.0; new.updated_at := now(); return new; end $$;
drop trigger if exists profiles_score on public.profiles;
create trigger profiles_score before insert or update on public.profiles for each row execute function public.mixio_score();
