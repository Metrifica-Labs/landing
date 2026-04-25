-- Cases table
create table public.cases (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  description text not null,
  category    text not null,
  category_color text not null default '#2864E8',
  image_url   text,
  "order"     integer not null default 0,
  published   boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Auto-update updated_at
create or replace function public.handle_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger cases_updated_at
  before update on public.cases
  for each row execute procedure public.handle_updated_at();

-- Row Level Security
alter table public.cases enable row level security;

-- Public read of published cases only
create policy "Public can read published cases"
  on public.cases
  for select
  using (published = true);

-- Storage bucket for case images
insert into storage.buckets (id, name, public)
values ('cases', 'cases', true)
on conflict do nothing;

-- Allow public to read images from the cases bucket
create policy "Public can read case images"
  on storage.objects
  for select
  using (bucket_id = 'cases');
