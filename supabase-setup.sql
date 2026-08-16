-- =====================================================
-- Jane's Link Site — Supabase Setup Script
-- Run this ONCE in your Supabase SQL Editor
-- Dashboard > SQL Editor > New query > Paste > Run
-- =====================================================

-- 1. SETTINGS TABLE (single config row for the whole site)
create table if not exists public.settings (
  id integer primary key default 1,
  name text default 'Jane',
  subtitle text default 'See what I am up to.',
  bio text default 'Hi! I''m an avid fencer and content creator passionate about helping others improve their technique. Check out my resources below or drop me a message!',
  profile_image_url text default '',
  link_bio_url text default '#',
  link_faq_url text default '#',
  link_instagram_url text default '#',
  link_youtube_url text default '#',
  paypal_url text default '#'
);

-- Insert the single default config row (safe to run multiple times)
insert into public.settings (id)
values (1)
on conflict (id) do nothing;

-- 2. CONTACTS TABLE (stores all contact form submissions)
create table if not exists public.contacts (
  id uuid primary key default gen_random_uuid(),
  name text,
  email text,
  message text,
  replied boolean default false,
  created_at timestamptz default now()
);

-- 3. ROW LEVEL SECURITY (RLS)
alter table public.settings enable row level security;
alter table public.contacts enable row level security;

-- Settings: anyone can READ (so the public site can load config)
create policy "Public read settings"
  on public.settings for select using (true);

-- Settings: only logged-in admin can UPDATE
create policy "Admin update settings"
  on public.settings for update
  using (auth.role() = 'authenticated');

-- Contacts: anyone can INSERT (submit the contact form)
create policy "Public insert contacts"
  on public.contacts for insert
  with check (true);

-- Contacts: only logged-in admin can read / update
create policy "Admin read contacts"
  on public.contacts for select
  using (auth.role() = 'authenticated');

create policy "Admin update contacts"
  on public.contacts for update
  using (auth.role() = 'authenticated');

-- 4. STORAGE BUCKET FOR PROFILE IMAGES
insert into storage.buckets (id, name, public)
values ('profile', 'profile', true)
on conflict (id) do nothing;

create policy "Public read profile images"
  on storage.objects for select
  using (bucket_id = 'profile');

create policy "Admin upload profile images"
  on storage.objects for insert
  with check (bucket_id = 'profile' and auth.role() = 'authenticated');

create policy "Admin update profile images"
  on storage.objects for update
  using (bucket_id = 'profile' and auth.role() = 'authenticated');
