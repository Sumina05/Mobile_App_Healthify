# Healthify

A skincare companion app: ingredient analysis, barcode scanning, product catalog, and personalized recommendations, built with Flutter and a Node.js/Express API.

## Structure

```
mobile/    Flutter application (Clean Architecture, Riverpod)
backend/   Node.js/Express REST API (MongoDB, JWT auth)
```

Each folder has its own README with setup instructions.

## Quick start

### Backend

```bash
cd backend
npm install
cp .env.example .env
npm run dev
```

### Mobile

```bash
cd mobile
flutter pub get
flutter run
```

See [mobile/README.md](mobile/README.md) for device/emulator setup notes (API base URL, Google Sign-In configuration, etc.) and [backend/README.md](backend/README.md) for API and environment configuration details.

## Testing

```bash
# Backend
cd backend && npm test

# Mobile
cd mobile && flutter analyze && flutter test
```
