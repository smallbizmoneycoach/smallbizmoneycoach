-- ==========================================
-- 013_coupons.sql
-- SmallBizMoneyCoach
-- ==========================================

create table if not exists public.coupons (

    id uuid primary key default gen_random_uuid(),

    code text unique not null,

    discount_type text not null
        check (discount_type in ('percentage', 'fixed')),

    discount_value numeric(10,2) not null
        check (discount_value > 0),

    usage_limit integer,

    usage_count integer not null default 0
        check (usage_count >= 0),

    minimum_order_amount numeric(10,2) default 0,

    expires_at timestamptz,

    active boolean not null default true,

    created_at timestamptz default now()
);

alter table public.coupons enable row level security;

create index if not exists coupons_code_idx
on public.coupons(code);

create index if not exists coupons_active_idx
on public.coupons(active);
