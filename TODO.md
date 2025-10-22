# AppQuanta Migration to Supabase

## Overview
Migrate AppQuanta from Firebase to Supabase as the exclusive backend.

## Steps

### 1. Remove Firebase Dependencies and Configurations
- [x] Remove Firebase-related files: (No Firebase files found - already removed)
- [x] Check and remove any Firebase plugins from Gradle files if present (No Firebase deps in pubspec.yaml)
- [x] Clean pubspec.yaml (no Firebase deps listed, but ensure)

### 2. Update Authentication
- [x] Replace AuthService with SupabaseService in all screens:
  - [x] lib/screens/login_screen.dart (Already uses SupabaseService)
  - [x] lib/screens/register_screen.dart
  - [x] lib/screens/profile_screen.dart
  - [ ] lib/screens/home_screen.dart
  - [ ] lib/screens/my_apps_screen.dart
  - [ ] lib/screens/create_app_screen.dart
- [ ] Update auth state streams and methods

### 3. Update Database Calls
- [ ] Replace Firestore queries with Supabase database calls in:
  - [ ] lib/screens/home_screen.dart
  - [ ] lib/screens/my_apps_screen.dart
  - [ ] lib/screens/create_app_screen.dart
  - [ ] lib/screens/profile_screen.dart
- [ ] Update data models to match Supabase schema (users, apps tables)

### 4. Update API Service
- [ ] Update lib/services/api_service.dart to use Supabase auth for JWT instead of Firebase

### 5. Add Environment Configuration
- [ ] Create .env file with SUPABASE_URL and SUPABASE_ANON_KEY
- [ ] Update main.dart to load .env if needed (already initializes Supabase)

### 6. Testing and Refinement
- [ ] Run flutter clean && flutter pub get
- [ ] Test authentication (login, register, logout)
- [ ] Test app creation and listing
- [ ] Test real-time updates
- [ ] Verify no Firebase references remain
- [ ] Test APK upload/download (once backend is ready)

### 7. Backend Setup (Note: Requires Supabase Console)
- [ ] Create Supabase project
- [ ] Set up users table: id (uuid), email, username, created_at
- [ ] Set up apps table: id (uuid), user_id (uuid), app_name, package_name, status, created_at, apk_url
- [ ] Create apks storage bucket
- [ ] Create upload_apk edge function
- [ ] Enable Realtime API for apps table
