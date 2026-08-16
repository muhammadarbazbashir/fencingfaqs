-- Run this in Supabase SQL Editor to add PayPal checkout columns
ALTER TABLE public.settings
  ADD COLUMN IF NOT EXISTS paypal_client_id   text default '',
  ADD COLUMN IF NOT EXISTS paypal_amount       text default '0.00',
  ADD COLUMN IF NOT EXISTS paypal_currency     text default 'USD',
  ADD COLUMN IF NOT EXISTS paypal_description  text default 'Fencing Resources';
