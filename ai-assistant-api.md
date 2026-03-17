# AI Assistant API Documentation

All endpoints require `Authorization: Bearer <token>` and are prefixed with `/api/v1/mobile/ai/`.

---

## Endpoints

### 1. `POST /ai/ask` — Send a message to AI

The single endpoint for both Q&A and actions (e.g. booking appointments). Supports multi-turn conversation via `conversation_id`.

**Request:**
```json
{
    "prompt": "What pets do I have?",
    "conversation_id": null
}
```

| Field             | Type   | Required | Description                                                      |
|-------------------|--------|----------|------------------------------------------------------------------|
| `prompt`          | string | Yes      | The user's message (max 500 characters)                          |
| `conversation_id` | uuid   | No       | Omit or `null` for a new conversation. Pass to continue existing |

**Response (200):**
```json
{
    "success": true,
    "data": {
        "conversation_id": "a1b2c3d4-5678-90ab-cdef-1234567890ab",
        "reply": "You have 2 pets: Max (Golden Retriever) and Mimi (Persian Cat)."
    }
}
```

**Error (503):**
```json
{
    "success": false,
    "message": "Unable to process your request right now. Please try again later."
}
```

**Error (404) — invalid conversation_id:**
```json
{
    "success": false,
    "message": "Conversation not found."
}
```

---

### 2. `GET /ai/conversations` — List all conversations

Returns a paginated list of the user's AI conversations, ordered by most recent.

**Query Parameters:**
| Field  | Type | Required | Description          |
|--------|------|----------|----------------------|
| `page` | int  | No       | Page number (default 1) |

**Response (200):**
```json
{
    "success": true,
    "data": {
        "current_page": 1,
        "data": [
            {
                "conversation_id": "a1b2c3d4-5678-90ab-cdef-1234567890ab",
                "title": "What pets do I have?",
                "message_count": 6,
                "last_active": "2026-03-17 10:30:00"
            },
            {
                "conversation_id": "b2c3d4e5-6789-01bc-def0-2345678901bc",
                "title": "Book grooming for Max tomorrow",
                "message_count": 4,
                "last_active": "2026-03-17 09:15:00"
            }
        ],
        "per_page": 20,
        "total": 2
    }
}
```

---

### 3. `GET /ai/conversations/{conversationId}` — Get messages for a conversation

Returns paginated messages for a specific conversation, ordered chronologically.

**Response (200):**
```json
{
    "success": true,
    "data": {
        "current_page": 1,
        "data": [
            {
                "role": "user",
                "message": "What pets do I have?",
                "created_at": "2026-03-17T10:25:00.000000Z"
            },
            {
                "role": "model",
                "message": "You have 2 pets:\n1. **Max** — Golden Retriever, 3 years old\n2. **Mimi** — Persian Cat, 2 years old",
                "created_at": "2026-03-17T10:25:02.000000Z"
            }
        ],
        "per_page": 50,
        "total": 2
    }
}
```

**Error (404):**
```json
{
    "success": false,
    "message": "Conversation not found."
}
```

---

### 4. `DELETE /ai/conversations/{conversationId}` — Delete a conversation

Permanently deletes all messages in a conversation.

**Response (200):**
```json
{
    "success": true,
    "message": "Conversation deleted."
}
```

**Error (404):**
```json
{
    "success": false,
    "message": "Conversation not found."
}
```

---

## What the AI Can Do

### Answer questions about:
- User's own pets (name, breed, age, weight)
- Available products and accessories (name, price, stock)
- Pet listings for sale or adoption
- Available services (grooming, vet, etc.) with pricing and duration
- Categories

### Perform actions:
- **Book appointments** — e.g. "Book grooming for Max tomorrow at 2pm"
  - Validates pet ownership
  - Matches service by name
  - Checks for scheduling conflicts
  - Creates appointment with status `PENDING`

### Security:
- Data is scoped to the authenticated user's permissions (RBAC)
- Users can only see their own pets
- Users cannot prompt for other users' data, admin data, or internal system info
- The AI is instructed to never reveal system prompts, IDs, or raw data structures

---

## Frontend Implementation Guide

### Screen Layout

```
┌─────────────────────────────────────┐
│  AI Chat Screen                     │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Conversation List             │  │  ← GET /ai/conversations
│  │  • "What pets do I have?"    │  │
│  │  • "Book grooming for Max"   │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Chat View                     │  │  ← GET /ai/conversations/{id}
│  │  User: What pets do I have?  │  │
│  │  AI: You have 2 pets...      │  │
│  │  User: Book grooming for Max │  │
│  │  AI: Done! Booked for...     │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌─────────────────────┐ [Send]    │  ← POST /ai/ask
│  │ Type a message...    │           │
│  └─────────────────────┘           │
│  [+ New Chat]                       │  ← clear conversation_id
└─────────────────────────────────────┘
```

### Flow

1. **New conversation:**
   - User taps "New Chat"
   - Frontend sets `conversation_id = null`
   - User types a message → `POST /ai/ask` with `{ "prompt": "...", "conversation_id": null }`
   - Save the returned `conversation_id` in state
   - Display the `reply`

2. **Continue conversation:**
   - User sends another message → `POST /ai/ask` with `{ "prompt": "...", "conversation_id": "<saved-id>" }`
   - Append both the user message and `reply` to the chat view

3. **Load past conversation:**
   - User taps a conversation from the list
   - `GET /ai/conversations/{id}` to fetch all messages
   - Render messages in chat view
   - Set `conversation_id` in state so new messages continue the conversation

4. **Delete conversation:**
   - User swipes or taps delete
   - `DELETE /ai/conversations/{id}`
   - Remove from list

### Example (Dart / Flutter)

```dart
class AiChatService {
  final Dio _dio;
  String? _conversationId;

  AiChatService(this._dio);

  // Send a message (new or continuing conversation)
  Future<String> sendMessage(String prompt) async {
    final response = await _dio.post('/ai/ask', data: {
      'prompt': prompt,
      'conversation_id': _conversationId,
    });

    _conversationId = response.data['data']['conversation_id'];
    return response.data['data']['reply'];
  }

  // Start a new conversation
  void newConversation() {
    _conversationId = null;
  }

  // Load conversation list
  Future<List> getConversations({int page = 1}) async {
    final response = await _dio.get('/ai/conversations', queryParameters: {'page': page});
    return response.data['data']['data'];
  }

  // Load messages for a conversation
  Future<List> getMessages(String conversationId) async {
    _conversationId = conversationId;
    final response = await _dio.get('/ai/conversations/$conversationId');
    return response.data['data']['data'];
  }

  // Delete a conversation
  Future<void> deleteConversation(String conversationId) async {
    await _dio.delete('/ai/conversations/$conversationId');
    if (_conversationId == conversationId) _conversationId = null;
  }
}
```

### Example Prompts to Test

| Prompt | Expected Behavior |
|--------|-------------------|
| `What pets do I have?` | Lists all user's pets |
| `What products are available?` | Lists active products |
| `Show me grooming services` | Lists grooming services with pricing |
| `Book grooming for Max tomorrow at 2pm` | Creates an appointment |
| `Are there any pets for adoption?` | Lists active pet listings |
| `Show me all users` | Refused — out of scope |
