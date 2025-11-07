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
- [x] Create .env file with SUPABASE_URL and SUPABASE_ANON_KEY
- [x] Update main.dart to load .env if needed (already initializes Supabase)

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

## Current Issues to Resolve

### Authentication Token Verification Failing
- **Problem:** API endpoints returning 500 errors with "Invalid authentication token" message
- **Root Cause:** `verify_token` method in `appQuanta-server/services/supabase_service.py` failing to validate JWT tokens
- **Impact:** Cannot create apps or access protected endpoints
- **Solution Needed:**
  1. Debug token verification logic
  2. Ensure proper JWT validation with Supabase
  3. Test with real tokens from Flutter app authentication

### Database Operations Not Migrated
- **Problem:** Flutter screens still using Firebase/Firestore calls
- **Files to Update:**
  - lib/screens/home_screen.dart
  - lib/screens/my_apps_screen.dart
  - lib/screens/create_app_screen.dart
  - lib/screens/profile_screen.dart
- **Solution:** Replace all Firestore calls with Supabase database operations

### API Service Not Updated
- **Problem:** `lib/services/api_service.dart` still using Firebase auth tokens
- **Solution:** Update to use Supabase JWT tokens for API authentication

## Immediate Next Steps
1. **Fix Authentication Middleware**
   - Debug why token verification is failing in `appQuanta-server/services/supabase_service.py`
   - Ensure `verify_token` method correctly validates JWT tokens from Flutter app
   - Test with real tokens from Flutter login

2. **Update Database Operations**
   - Replace all Firestore calls in Flutter screens with Supabase calls
   - Update `lib/services/api_service.dart` to use Supabase auth tokens
   - Ensure proper error handling for database operations

3. **Test Authentication Flow**
   - Verify login/register works with Supabase
   - Test app creation with valid authentication
   - Confirm token persistence across app sessions

4. **Update Data Models**
   - Ensure Flutter models match Supabase schema (users, apps tables)
   - Update any hardcoded Firebase references

5. **Backend Database Setup**
   - Create Supabase tables: users (id, email, username, created_at), apps (id, user_id, app_name, package_name, status, created_at, apk_url)
   - Set up storage bucket for APKs
   - Enable RLS policies for data security

6. **Full Testing**
   - Test all CRUD operations for apps
   - Verify real-time updates work
   - Test APK upload/download functionality

## Testing Commands
Use these commands to test the API endpoints:

```bash
# Test app creation (requires valid token)
curl -X POST http://localhost:8000/api/v1/apps/create \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "Test App", "description": "Test description"}'

# Test getting user apps
curl -X GET http://localhost:8000/api/v1/apps \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Test root endpoint
curl http://localhost:8000/
```

## Git Status
- **Issue:** Some files may be ignored by .gitignore
- **Current .gitignore contents:** Standard Flutter ignores, no custom entries blocking commits
- **Action:** Check `git status` to see if all files are tracked. If files are missing, they might be in .gitignore or not added yet.
