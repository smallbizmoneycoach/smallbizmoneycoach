-- ==========================================
-- 011_reviews.sql
-- SmallBizMoneyCoach
-- ==========================================

create table if not exists public.reviews (

    id uuid primary key default gen_random_uuid(),

    user_id uuid not null
        references auth.users(id)
        on delete cascade,

    product_id uuid not null
        references public.products(id)
        on delete cascade,

    rating integer not null
        check (rating >= 1 and rating <= 5),

    review text,

    verified_purchase boolean not null default false,

    status text not null default 'pending'
        check (status in ('pending', 'approved', 'rejected')),

    created_at timestamptz default now(),

    updated_at timestamptz default now(),

    unique (user_id, product_id)
);

alter table public.reviews enable row level security;

create policy "Approved reviews are publicly viewable"
on public.reviews
for select
using (
    status = 'approved'
    or auth.uid() = user_id
);

create policy "Authenticated users can create reviews"
on public.reviews
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Users can update their own reviews"
on public.reviews
for update
to authenticated
using (auth.uid() = user_id);

create index if not exists reviews_product_idx
on public.reviews(product_id);

create index if not exists reviews_user_idx
on public.reviews(user_id);

create index if not exists reviews_status_idx
on public.reviews(status);
