# AppQuanta UI Redesign TODO

## 1. Create SettingsPage
- [x] Create `lib/screens/settings_screen.dart` with list layout
- [x] Add theme toggle, language, notifications, privacy options
- [x] Implement smooth animations for toggles
- [x] Style with rounded cards and ice white background

## 2. Update HomeScreen
- [x] Add subtle gradient background (gray → white)
- [x] Enhance app cards with type, creation date, status
- [x] Center FAB with elevation/shadow dynamics
- [x] Add Hero transitions for navigation

## 3. Update CreateAppScreen
- [ ] Apply glassmorphism to form fields (BackdropFilter)
- [ ] Create premium gradient button (blue → cyan)
- [ ] Add expansion animation on button tap
- [ ] Animate recent projects with staggered entrance
- [ ] Implement custom spinner (check Lottie dependency)

## 4. Update ProfileScreen
- [ ] Enlarge circular photo with animated border/shadow
- [ ] Add premium dashboard cards (apps created, last access, usage time)
- [ ] Implement edit profile bottom sheet modal
- [ ] Add logout button in soft red at bottom
- [ ] Create gradient background with particle animation (CustomPainter)

## 5. Update Navigation
- [ ] Add '/settings' route in `lib/main.dart`
- [ ] Add Settings button in ProfileScreen

## 6. Dependencies & Testing
- [ ] Check/add Lottie in pubspec.yaml if needed
- [ ] Test animations on device/emulator
- [ ] Verify color consistency
- [ ] Ensure Firebase logic untouched
