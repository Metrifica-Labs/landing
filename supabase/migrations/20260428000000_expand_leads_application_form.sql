alter table leads
  add column company_name text,
  add column instagram text,
  add column business_moment text[] default '{}'::text[],
  add column business_description text,
  add column current_problems text[] default '{}'::text[],
  add column consequence_12_months text,
  add column previous_attempt text,
  add column failed_attempt_details text,
  add column current_systems text,
  add column ideal_system_solution text,
  add column willing_to_invest text,
  add column why_metrifica text;
