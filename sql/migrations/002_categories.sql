create table if not exists public.categories (

    id uuid primary key default gen_random_uuid(),

    name text not null,

    slug text unique not null,

    description text,

    icon text,

    image_url text,

    featured boolean default false,

    created_at timestamptz default now()
);

alter table public.categories enable row level security;

create policy "Public categories are viewable by everyone"
on public.categories
for select
using (true);

create index if not exists categories_slug_idx
on public.categories(slug);
