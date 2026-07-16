-- ==========================================
-- 012_wishlist.sql
-- SmallBizMoneyCoach
-- ==========================================

create table if not exists public.wishlist (

    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references auth.users(id)
        on delete cascade,

    product_id uuid not null
        references public.products(id)
        on delete cascade,

    created_at timestamptz default now(),

    unique (user_id, product_id)
);

alter table public.wishlist enable row level security;

create policy "Users can view their own wishlist"
on public.wishlist
for select
to authenticated
using (auth.uid() = user_id);

create policy "Users can add to their own wishlist"
on public.wishlist
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Users can remove from their own wishlist"
on public.wishlist
for delete
to authenticated
using (auth.uid() = user_id);

create index if not exists wishlist_user_idx
on public.wishlist(user_id);

create index if not exists wishlist_product_idx
on public.wishlist(product_id);
