-- ==========================================
-- 006_product_files.sql
-- SmallBizMoneyCoach
-- ==========================================

create table if not exists public.product_files (

    id uuid primary key default gen_random_uuid(),

    product_id uuid not null
        references public.products(id)
        on delete cascade,

    file_name text not null,

    file_path text not null,

    file_size bigint,

    file_type text,

    version text,

    created_at timestamptz default now()

);

alter table public.product_files enable row level security;

create policy "Product files are only visible to authenticated users"
on public.product_files
for select
to authenticated
using (true);

create index if not exists product_files_product_idx
on public.product_files(product_id);
