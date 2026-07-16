-- ==========================================
-- 004_products.sql
-- SmallBizMoneyCoach
-- ==========================================

create table if not exists public.products (

    id uuid primary key default gen_random_uuid(),

    title text not null,

    slug text unique not null,

    short_description text,

    description text,

    price numeric(10,2) not null default 0
        check (price >= 0),

    sale_price numeric(10,2)
        check (sale_price is null or sale_price >= 0),

    currency text not null default 'USD',

    category_id uuid
        references public.categories(id)
        on delete set null,

    collection_id uuid
        references public.collections(id)
        on delete set null,

    thumbnail_url text,

    preview_url text,

    file_size text,

    version text,

    language text default 'English',

    license text,

    download_limit integer,

    featured boolean default false,

    best_seller boolean default false,

    new_release boolean default false,

    rating numeric(2,1) default 0
        check (rating >= 0 and rating <= 5),

    review_count integer default 0
        check (review_count >= 0),

    download_count integer default 0
        check (download_count >= 0),

    visibility text default 'public'
        check (visibility in ('public', 'private', 'unlisted')),

    status text default 'draft'
        check (status in ('draft', 'published', 'archived')),

    seo_title text,

    seo_description text,

    created_at timestamptz default now(),

    updated_at timestamptz default now()

);

alter table public.products enable row level security;

create policy "Published products are publicly viewable"
on public.products
for select
using (
    status = 'published'
    and visibility = 'public'
);

create index if not exists products_slug_idx
on public.products(slug);

create index if not exists products_category_idx
on public.products(category_id);

create index if not exists products_collection_idx
on public.products(collection_id);

create index if not exists products_status_idx
on public.products(status);

create index if not exists products_featured_idx
on public.products(featured);

create index if not exists products_best_seller_idx
on public.products(best_seller);

create index if not exists products_created_at_idx
on public.products(created_at desc);
