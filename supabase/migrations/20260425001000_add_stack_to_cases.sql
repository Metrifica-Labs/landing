alter table public.cases
  add column if not exists stack text[];
