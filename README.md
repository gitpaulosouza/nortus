# nortus

Loomi's technical challenge news app

## Authentication

The app implements authentication following the challenge specifications:

### Login Flow
- Endpoint: `POST /auth` (via WireMock API)
- Credentials: `login: "desafioLoomi"`, `password: "senha123"`
- User provides email as "login" field; valid login is exactly the challenge credentials
- Session persisted via SharedPreferences only when "Keep me logged in" is checked
- No token usage; authentication is based on isLoggedIn boolean flag

### Registration
- Simulated locally (no API call) per challenge specs
- Accepts any valid email/password combination
- Auto-completes with success response

### Resilience
The WireMock API may exceed its monthly request quota. The `AuthDatasource` handles this gracefully with a fallback mechanism: when quota is exceeded (detected via error response or 4xx/5xx status), the app validates credentials locally (`desafioLoomi`/`senha123` only). This ensures the authentication flow remains functional during API quota issues.

### Request Delay
All authentication requests maintain a consistent 3-second delay for realistic UX.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
