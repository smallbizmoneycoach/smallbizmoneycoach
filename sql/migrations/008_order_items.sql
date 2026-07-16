-- ==========================================
-- 008_order_items.sql
-- SmallBizMoneyCoach
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

create policy "Users can view their own order items"
on public.order_items
for select
to authenticated
using (
    exists (
        select 1
        from public.orders
        where orders.id = order_items.order_id
        and orders.user_id = auth.uid()
    )
);

create index if not exists order_items_order_idx
on public.order_items(order_id);

create index if not exists order_items_product_idx
on public.order_items(product_id);
