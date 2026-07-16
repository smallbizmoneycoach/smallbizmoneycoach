-- ==========================================
-- 007_orders.sql
-- SmallBizMoneyCoach
-- ==========================================

create table if not exists public.orders (

    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references auth.users(id)
        on delete cascade,

    order_number text unique not null,

    status text not null default 'pending'
        check (status in (
            'pending',
            'paid',
            'failed',
            'cancelled',
            'refunded'
        )),

    subtotal numeric(10,2) not null default 0,

    discount numeric(10,2) not null default 0,

    total numeric(10,2) not null default 0,

    currency text not null default 'USD',

    payment_provider text,

    payment_reference text unique,

    customer_email text not null,

    paid_at timestamptz,

    created_at timestamptz default now(),

    updated_at timestamptz default now()

);

alter table public.orders enable row level security;

create policy "Users can view their own orders"
on public.orders
for select
to authenticated
using (auth.uid() = user_id);

create index if not exists orders_user_idx
on public.orders(user_id);

create index if not exists orders_payment_reference_idx
on public.orders(payment_reference);

create index if not exists orders_status_idx
on public.orders(status);

create index if not exists orders_created_at_idx
on public.orders(created_at desc);
