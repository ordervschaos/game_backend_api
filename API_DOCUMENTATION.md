# Game Backend API Documentation

This document provides detailed information about the available API endpoints, their usage, and authentication requirements.

## Authentication

Most endpoints require authentication using a JWT token. The token should be included in the request header as:
```
Authorization: Bearer <your_jwt_token>
```

## Endpoints

### 1. User Registration
Create a new user account.

**Endpoint:** `POST /api/user`

**Authentication Required:** No

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "Password123!"
}
```

**Password Requirements:**
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- At least one special character

**Response (201 Created):**
```json
{
  "token": "your.jwt.token"
}
```

### 2. User Login
Authenticate and get a JWT token.

**Endpoint:** `POST /api/sessions`

**Authentication Required:** No

**Rate Limit:** 10 requests per minute

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "Password123!"
}
```

**Response (200 OK):**
```json
{
  "token": "your.jwt.token"
}
```

### 3. Get User Profile
Retrieve user information and stats.

**Endpoint:** `GET /api/user`

**Authentication Required:** Yes

**Response (200 OK):**
```json
{
  "email": "user@example.com",
  "id": 1,
  "stats": {
    "total_games_played": 5
  },
  "subscription_status": "active" // or "expired" or "no_subscription"
}
```

### 4. Create Game Event
Record a game completion event.

**Endpoint:** `POST /api/user/game_events`

**Authentication Required:** Yes

**Request Body:**
```json
{
  "game_event": {
    "type": "COMPLETED",
    "game_name": "Game Name",
    "occurred_at": "2024-04-22T18:30:00Z"
  }
}
```

**Response (201 Created):**
```json
{
  "message": "Game event created successfully",
  "game_event": {
    "id": 1,
    "game_name": "Game Name",
    "event_type": "COMPLETED",
    "occurred_at": "2024-04-22T18:30:00Z",
    "created_at": "2024-04-22T18:30:00Z",
    "updated_at": "2024-04-22T18:30:00Z"
  }
}
```

## Error Responses

### Unauthorized (401)
When authentication token is missing or invalid:
- Status code: 401
- No response body

### Forbidden (403)
When user associated with the token doesn't exist:
- Status code: 403
- No response body

### Unprocessable Entity (422)
When request validation fails:
```json
{
  "errors": [
    {
      "detail": "Error message"
    }
  ]
}
```

### Too Many Requests (429)
When rate limit is exceeded:
```
Rate limit exceeded. Retry after X seconds
```

## Rate Limiting

The API implements rate limiting for the following endpoints:

1. `/api/sessions` (Login):
   - 300 requests per 5 minutes per IP
   - 5 requests per minute per email address

Rate limit information is included in the response headers:
- `Retry-After`: Number of seconds to wait before retrying 