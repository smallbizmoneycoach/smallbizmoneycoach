-- ==========================================
-- 005_product_images.sql
-- SmallBizMoneyCoach
-- ==========================================

create table if not exists public.product_images (

    id uuid primary key default gen_random_uuid(),

    product_id uuid not null
        references public.products(id)
        on delete cascade,

    image_url text not null,

    alt_text text,

    sort_order integer default 0,

    created_at timestamptz default now()

);

alter table public.product_images enable row level security;

create policy "Product images are publicly viewable"
on public.product_images
for select
using (true);

create index if not exists product_images_product_idx
on public.product_images(product_id);

create index if not exists product_images_sort_idx
on public.product_images(product_id, sort_order);
