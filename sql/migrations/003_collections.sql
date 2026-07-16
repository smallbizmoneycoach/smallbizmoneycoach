create table if not exists public.collections (

    id uuid primary key default gen_random_uuid(),

    title text not null,

    slug text unique not null,

    description text,

    image_url text,

    featured boolean default false,

    created_at timestamptz default now()

);

alter table public.collections enable row level security;

create policy "Collections are public"
on public.collections
for select
using (true);

create index if not exists collections_slug_idx
on public.collections(slug);
