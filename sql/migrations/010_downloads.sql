-- ==========================================
-- 010_downloads.sql
-- SmallBizMoneyCoach
-- ==========================================

create table if not exists public.downloads (

    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references auth.users(id)
        on delete cascade,

    product_id uuid not null
        references public.products(id)
        on delete cascade,

    order_id uuid not null
        references public.orders(id)
        on delete cascade,

    download_count integer not null default 0
        check (download_count >= 0),

    last_downloaded_at timestamptz,

    expires_at timestamptz,

    created_at timestamptz default now(),

    unique (user_id, product_id, order_id)

);

alter table public.downloads enable row level security;

create policy "Users can view their own downloads"
on public.downloads
for select
to authenticated
using (auth.uid() = user_id);

create index if not exists downloads_user_idx
on public.downloads(user_id);

create index if not exists downloads_product_idx
on public.downloads(product_id);

create index if not exists downloads_order_idx
on public.downloads(order_id);
