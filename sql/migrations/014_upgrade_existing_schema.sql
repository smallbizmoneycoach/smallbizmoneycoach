-- ==========================================
-- 014_upgrade_existing_schema.sql
-- SmallBizMoneyCoach
-- Safely upgrades existing database schema
-- ==========================================

-- ==========================================
-- PRODUCTS
-- ==========================================

alter table public.products
add column if not exists short_description text;

alter table public.products
add column if not exists currency text default 'USD';

alter table public.products
add column if not exists category_id uuid;

alter table public.products
add column if not exists collection_id uuid;

alter table public.products
add column if not exists thumbnail_url text;

alter table public.products
add column if not exists preview_url text;

alter table public.products
add column if not exists file_size text;

alter table public.products
add column if not exists version text;

alter table public.products
add column if not exists language text default 'English';

alter table public.products
add column if not exists license text;

alter table public.products
add column if not exists download_limit integer;

alter table public.products
add column if not exists best_seller boolean default false;

alter table public.products
add column if not exists new_release boolean default false;

alter table public.products
add column if not exists rating numeric(2,1) default 0;

alter table public.products
add column if not exists review_count integer default 0;

alter table public.products
add column if not exists download_count integer default 0;

alter table public.products
add column if not exists visibility text default 'public';

alter table public.products
add column if not exists seo_title text;

alter table public.products
add column if not exists seo_description text;

alter table public.products
add column if not exists updated_at timestamptz default now();

-- Add foreign key relationships only if they do not already exist

do $$
begin

    if not exists (
        select 1
        from pg_constraint
        where conname = 'products_category_id_fkey'
    ) then

        alter table public.products
        add constraint products_category_id_fkey
        foreign key (category_id)
        references public.categories(id)
        on delete set null;

    end if;

end $$;

do $$
begin

    if not exists (
        select 1
        from pg_constraint
        where conname = 'products_collection_id_fkey'
    ) then

        alter table public.products
        add constraint products_collection_id_fkey
        foreign key (collection_id)
        references public.collections(id)
        on delete set null;

    end if;

end $$;

-- Product indexes

create index if not exists products_category_idx
on public.products(category_id);

create index if not exists products_collection_idx
on public.products(collection_id);

create index if not exists products_featured_idx
on public.products(is_featured);

create index if not exists products_created_at_idx
on public.products(created_at desc);


-- ==========================================
-- ORDER ITEMS
-- ==========================================

create table if not exists public.order_items (

    id uuid primary key default gen_random_uuid(),

    order_id uuid not null
        references public.orders(id)
        on delete cascade,

    product_id uuid not null
        references public.products(id)
        on delete restrict,

    product_title text not null,

    quantity integer not null default 1
        check (quantity > 0),

    unit_price numeric(10,2) not null default 0,

    total_price numeric(10,2) not null default 0,

    created_at timestamptz default now()

);

alter table public.order_items enable row level security;

-- ==========================================
-- ORDERS
-- ==========================================

alter table public.orders
add column if not exists user_id uuid;

alter table public.orders
add column if not exists order_number text;

alter table public.orders
add column if not exists subtotal numeric(10,2);

alter table public.orders
add column if not exists discount numeric(10,2) default 0;

alter table public.orders
add column if not exists total numeric(10,2);

alter table public.orders
add column if not exists payment_provider text;

alter table public.orders
add column if not exists payment_reference text;

alter table public.orders
add column if not exists paid_at timestamptz;

alter table public.orders
add column if not exists updated_at timestamptz default now();


-- ==========================================
-- DOWNLOADS
-- ==========================================

alter table public.downloads
add column if not exists user_id uuid;

alter table public.downloads
add column if not exists download_count integer default 0;

alter table public.downloads
add column if not exists last_downloaded_at timestamptz;

alter table public.downloads
add column if not exists expires_at timestamptz;


-- ==========================================
-- INDEXES
-- ==========================================

create index if not exists orders_user_idx
on public.orders(user_id);

create index if not exists order_items_order_idx
on public.order_items(order_id);

create index if not exists order_items_product_idx
on public.order_items(product_id);

create index if not exists downloads_user_idx
on public.downloads(user_id);

create index if not exists downloads_product_idx
on public.downloads(product_id);
