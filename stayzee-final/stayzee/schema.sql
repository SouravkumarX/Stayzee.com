-- ═══════════════════════════════════════════════
--  STAYZEE  ·  Supabase Database Schema
--  Run this in your Supabase SQL Editor
-- ═══════════════════════════════════════════════

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ── 1. PROFILES ──────────────────────────────────
create table public.profiles (
  id            uuid references auth.users on delete cascade primary key,
  full_name     text not null,
  phone         text,
  bio           text,
  avatar_url    text,
  id_verified   boolean default false,
  selfie_url    text,
  gender        text check (gender in ('male','female','other')),
  rating        numeric(3,2) default 5.0,
  is_host       boolean default false,
  created_at    timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Public profiles are viewable by everyone"
  on profiles for select using (true);

create policy "Users can insert their own profile"
  on profiles for insert with check (auth.uid() = id);

create policy "Users can update their own profile"
  on profiles for update using (auth.uid() = id);

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', 'New User'));
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ── 2. LISTINGS ──────────────────────────────────
create table public.listings (
  id              uuid default uuid_generate_v4() primary key,
  host_id         uuid references public.profiles(id) on delete cascade not null,
  title           text not null,
  description     text,
  city            text not null,
  address         text,
  price_per_night numeric(10,2) not null,
  max_guests      int default 1,
  room_type       text check (room_type in ('private_room','shared_room','entire_place')),
  gender_filter   text check (gender_filter in ('any','female_only','male_only')),
  amenities       text[] default '{}',
  house_rules     text,
  images          text[] default '{}',
  is_active       boolean default true,
  rating          numeric(3,2) default 0,
  total_reviews   int default 0,
  created_at      timestamptz default now()
);

alter table public.listings enable row level security;

create policy "Listings are viewable by everyone"
  on listings for select using (true);

create policy "Hosts can insert their own listings"
  on listings for insert with check (auth.uid() = host_id);

create policy "Hosts can update their own listings"
  on listings for update using (auth.uid() = host_id);

create policy "Hosts can delete their own listings"
  on listings for delete using (auth.uid() = host_id);

-- ── 3. BOOKINGS ──────────────────────────────────
create table public.bookings (
  id              uuid default uuid_generate_v4() primary key,
  listing_id      uuid references public.listings(id) on delete cascade not null,
  guest_id        uuid references public.profiles(id) on delete cascade not null,
  host_id         uuid references public.profiles(id) on delete cascade not null,
  check_in        date not null,
  check_out       date not null,
  guests          int default 1,
  total_price     numeric(10,2) not null,
  status          text default 'pending'
                    check (status in ('pending','confirmed','cancelled','completed')),
  message         text,
  created_at      timestamptz default now()
);

alter table public.bookings enable row level security;

create policy "Guests can view their own bookings"
  on bookings for select using (auth.uid() = guest_id or auth.uid() = host_id);

create policy "Authenticated users can create bookings"
  on bookings for insert with check (auth.uid() = guest_id);

create policy "Host or guest can update booking status"
  on bookings for update using (auth.uid() = host_id or auth.uid() = guest_id);

-- ── 4. REVIEWS ───────────────────────────────────
create table public.reviews (
  id          uuid default uuid_generate_v4() primary key,
  listing_id  uuid references public.listings(id) on delete cascade not null,
  booking_id  uuid references public.bookings(id) on delete cascade not null,
  reviewer_id uuid references public.profiles(id) on delete cascade not null,
  rating      int check (rating between 1 and 5) not null,
  comment     text,
  created_at  timestamptz default now(),
  unique(booking_id, reviewer_id)
);

alter table public.reviews enable row level security;

create policy "Reviews are viewable by everyone"
  on reviews for select using (true);

create policy "Authenticated users can create reviews"
  on reviews for insert with check (auth.uid() = reviewer_id);

-- ── 5. MESSAGES ──────────────────────────────────
create table public.messages (
  id          uuid default uuid_generate_v4() primary key,
  sender_id   uuid references public.profiles(id) on delete cascade not null,
  receiver_id uuid references public.profiles(id) on delete cascade not null,
  booking_id  uuid references public.bookings(id) on delete set null,
  content     text not null,
  is_read     boolean default false,
  created_at  timestamptz default now()
);

alter table public.messages enable row level security;

create policy "Users can view their own messages"
  on messages for select using (auth.uid() = sender_id or auth.uid() = receiver_id);

create policy "Authenticated users can send messages"
  on messages for insert with check (auth.uid() = sender_id);

-- ── 6. STORAGE BUCKETS ───────────────────────────
-- Run in Supabase Dashboard > Storage > New Bucket
-- Bucket: listing-images  (public: true)
-- Bucket: avatars          (public: true)

insert into storage.buckets (id, name, public)
values ('listing-images', 'listing-images', true)
on conflict do nothing;

insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict do nothing;

create policy "Anyone can view listing images"
  on storage.objects for select using (bucket_id = 'listing-images');

create policy "Authenticated users can upload listing images"
  on storage.objects for insert
  with check (bucket_id = 'listing-images' and auth.role() = 'authenticated');

create policy "Anyone can view avatars"
  on storage.objects for select using (bucket_id = 'avatars');

create policy "Users can upload their own avatar"
  on storage.objects for insert
  with check (bucket_id = 'avatars' and auth.role() = 'authenticated');
