// ─────────────────────────────────────────────
//  STAYZEE  ·  Supabase Client Configuration
//  Replace SUPABASE_URL and SUPABASE_ANON_KEY
//  with your project values from supabase.com
// ─────────────────────────────────────────────

const SUPABASE_URL = 'https://jucqgjvsvbegymficfxu.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1Y3FnanZzdmJlZ3ltZmljZnh1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMzMjY5NjksImV4cCI6MjA4ODkwMjk2OX0.v5reSpsKjamRYt2ZfBqulRSymFE7N5JH8wytF_fc_dM';

const { createClient } = supabase;
const sb = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// ── Auth Helpers ──────────────────────────────
async function getSession() {
  const { data: { session } } = await sb.auth.getSession();
  return session;
}

async function getUser() {
  const { data: { user } } = await sb.auth.getUser();
  return user;
}

async function requireAuth(redirectTo = '/pages/login.html') {
  const session = await getSession();
  if (!session) { window.location.href = redirectTo; return null; }
  return session.user;
}

async function signOut() {
  await sb.auth.signOut();
  window.location.href = '/pages/login.html';
}

// ── Profile Helpers ───────────────────────────
async function getProfile(userId) {
  const { data, error } = await sb
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .single();
  return { data, error };
}

async function upsertProfile(profile) {
  const { data, error } = await sb
    .from('profiles')
    .upsert(profile)
    .select()
    .single();
  return { data, error };
}

// ── Listing Helpers ───────────────────────────
async function getListings(filters = {}) {
  let query = sb
    .from('listings')
    .select(`*, profiles(full_name, avatar_url, rating)`)
    .eq('is_active', true);

  if (filters.city)    query = query.ilike('city', `%${filters.city}%`);
  if (filters.minPrice) query = query.gte('price_per_night', filters.minPrice);
  if (filters.maxPrice) query = query.lte('price_per_night', filters.maxPrice);
  if (filters.gender_filter) query = query.eq('gender_filter', filters.gender_filter);

  query = query.order('created_at', { ascending: false });
  const { data, error } = await query;
  return { data, error };
}

async function getListingById(id) {
  const { data, error } = await sb
    .from('listings')
    .select(`*, profiles(full_name, avatar_url, rating, bio)`)
    .eq('id', id)
    .single();
  return { data, error };
}

async function createListing(listing) {
  const { data, error } = await sb
    .from('listings')
    .insert(listing)
    .select()
    .single();
  return { data, error };
}

async function updateListing(id, updates) {
  const { data, error } = await sb
    .from('listings')
    .update(updates)
    .eq('id', id)
    .select()
    .single();
  return { data, error };
}

// ── Image Upload ──────────────────────────────
async function uploadListingImage(file, listingId) {
  const ext = file.name.split('.').pop();
  const path = `listings/${listingId}/${Date.now()}.${ext}`;
  const { data, error } = await sb.storage
    .from('listing-images')
    .upload(path, file, { cacheControl: '3600', upsert: false });
  if (error) return { url: null, error };
  const { data: { publicUrl } } = sb.storage
    .from('listing-images')
    .getPublicUrl(path);
  return { url: publicUrl, error: null };
}

async function uploadAvatar(file, userId) {
  const ext = file.name.split('.').pop();
  const path = `avatars/${userId}.${ext}`;
  const { error } = await sb.storage
    .from('avatars')
    .upload(path, file, { cacheControl: '3600', upsert: true });
  if (error) return { url: null, error };
  const { data: { publicUrl } } = sb.storage
    .from('avatars')
    .getPublicUrl(path);
  return { url: publicUrl, error: null };
}

// ── Booking Helpers ───────────────────────────
async function createBooking(booking) {
  const { data, error } = await sb
    .from('bookings')
    .insert(booking)
    .select()
    .single();
  return { data, error };
}

async function getMyBookings(userId) {
  const { data, error } = await sb
    .from('bookings')
    .select(`*, listings(title, city, images, price_per_night, profiles(full_name))`)
    .eq('guest_id', userId)
    .order('created_at', { ascending: false });
  return { data, error };
}

async function getHostBookings(hostId) {
  const { data, error } = await sb
    .from('bookings')
    .select(`*, listings(title, city), profiles!guest_id(full_name, avatar_url)`)
    .eq('host_id', hostId)
    .order('created_at', { ascending: false });
  return { data, error };
}

async function updateBookingStatus(id, status) {
  const { data, error } = await sb
    .from('bookings')
    .update({ status })
    .eq('id', id)
    .select()
    .single();
  return { data, error };
}

// ── Reviews ───────────────────────────────────
async function createReview(review) {
  const { data, error } = await sb
    .from('reviews')
    .insert(review)
    .select()
    .single();
  return { data, error };
}

async function getListingReviews(listingId) {
  const { data, error } = await sb
    .from('reviews')
    .select(`*, profiles(full_name, avatar_url)`)
    .eq('listing_id', listingId)
    .order('created_at', { ascending: false });
  return { data, error };
}
