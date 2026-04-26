alter table public.cases
  add column if not exists link text,
  add column if not exists images text[];
