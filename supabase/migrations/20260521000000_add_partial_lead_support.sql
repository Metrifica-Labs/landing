alter table leads
  alter column name drop not null,
  alter column email drop not null,
  alter column phone drop not null,
  alter column monthly_revenue drop not null;

alter table leads
  add column status text not null default 'partial'
    check (status in ('partial', 'completed')),
  add column current_step integer not null default 0;

update leads
  set status = 'completed'
  where name is not null and email is not null
    and phone is not null and monthly_revenue is not null;

create index if not exists leads_status_idx on leads (status);
