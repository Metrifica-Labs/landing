create table leads (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  email text not null,
  phone text not null,
  monthly_revenue text not null,
  created_at timestamptz default now()
);
