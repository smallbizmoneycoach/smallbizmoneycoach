-- ==========================================
-- 009_payment_transactions.sql
-- SmallBizMoneyCoach
-- ==========================================

create table if not exists public.payment_transactions (

    id uuid primary key default gen_random_uuid(),

    order_id uuid not null
        references public.orders(id)
        on delete cascade,

    user_id uuid not null
        references auth.users(id)
        on delete cascade,

    provider text not null default 'paystack',

    reference text unique not null,

    amount numeric(10,2) not null,

    currency text not null default 'USD',

    status text not null default 'pending'
        check (status in (
            'pending',
            'success',
            'failed',
            'abandoned'
        )),

    channel text,

    gateway_response text,

    paid_at timestamptz,

    metadata jsonb default '{}'::jsonb,

    created_at timestamptz default now(),

    updated_at timestamptz default now()

);

alter table public.payment_transactions enable row level security;

create policy "Users can view their own payment transactions"
on public.payment_transactions
for select
to authenticated
using (auth.uid() = user_id);

create index if not exists payment_transactions_order_idx
on public.payment_transactions(order_id);

create index if not exists payment_transactions_user_idx
on public.payment_transactions(user_id);

create index if not exists payment_transactions_reference_idx
on public.payment_transactions(reference);

create index if not exists payment_transactions_status_idx
on public.payment_transactions(status);
