-- ==========================================
-- 001_profiles.sql
-- SmallBizMoneyCoach
-- ==========================================

create extension if not exists "pgcrypto";

create table if not exists public.profiles (
    id uuid primary key references auth.users(id) on delete cascade,

    first_name text,
    last_name text,

    avatar_url text,

    phone text,

    country text,

    role text default 'customer'
        check (role in ('customer','admin','vendor')),

    created_at timestamptz default now(),

    updated_at timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Users can view their own profile"
on public.profiles
for select
using (auth.uid() = id);

create policy "Users can insert their own profile"
on public.profiles
for insert
with check (auth.uid() = id);

create policy "Users can update their own profile"
on public.profiles
for update
using (auth.uid() = id);

create index if not exists profiles_country_idx
on public.profiles(country);

create index if not exists profiles_role_idx
on public.profiles(role);
