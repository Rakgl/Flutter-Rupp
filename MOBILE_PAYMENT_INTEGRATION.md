# KHQR Payment Integration Guide (Mobile)

## Overview
When a user places an order with KHQR payment method, the API returns payment data (deeplink + QR). The mobile app shows a payment screen, and polls the API until payment is confirmed.

---

## Payment Flow

```
1. User taps "Place Order"
2. App calls POST /orders → gets payment_info (deeplink)
3. App shows Payment Screen (QR code + "Open ABA" button + countdown timer)
4. User pays via ABA app (deeplink) or scans QR
5. App polls POST /orders/{id}/verify-payment every 3-5 seconds
6. When payment_status becomes "PAID" → show success screen
7. If timer expires (15 min) → show expired screen with retry/cancel options
```

---

## API Endpoints

### Base URL
```
{{BASE_URL}}/api/v1/mobile
```

All endpoints require `Authorization: Bearer {token}` header.

---

### 1. Place Order

**`POST /orders`**

#### Request Body
```json
{
    "fulfillment_type": "PICKUP",
    "payment_method_id": "59415cc0-4436-4aa6-ab61-79f690d1f350"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `fulfillment_type` | string | Yes | `"PICKUP"` or `"DELIVERY"` |
| `delivery_address` | string | Only if DELIVERY | Max 500 chars |
| `payment_method_id` | UUID | No | ID of payment method. Use KHQR ID for QR payment |

#### Response (Success - 200)
```json
{
    "data": {
        "id": "019cff25-8fb0-729b-95a7-bcf4d6189f52",
        "order_number": "ORD-KKW7EXFI",
        "subtotal": 15.0,
        "delivery_fee": 0.0,
        "total_amount": 15.0,
        "status": "PENDING",
        "payment_status": "UNPAID",
        "fulfillment_type": "PICKUP",
        "delivery_address": null,
        "items": [
            {
                "id": "019cff25-8fbe-70ab-b5e9-d9feb0272d93",
                "itemable_id": "019cfaed-8715-70b2-b756-053b5a2848b0",
                "itemable_type": "App\\Models\\Product",
                "quantity": 1,
                "unit_price": 15.0,
                "subtotal": 15.0,
                "item_name": "Interactive Laser Toy",
                "image_url": "https://images.unsplash.com/..."
            }
        ],
        "created_at": "2026-03-18 11:12:57"
    },
    "success": true,
    "message": "Order placed successfully.",
    "payment_info": {
        "transaction_no": "ORD-KKW7EXFI",
        "qr_string": "00020101021230640016...",
        "abapay_deeplink": "abamobilebank://ababank.com?type=payway&qrcode=...",
        "checkout_qr_url": "https://checkout-sandbox.ababank.com/qr/..."
    }
}
```

#### Important Notes
- `payment_info` is **only present** when `payment_method_id` points to the KHQR payment method
- `qr_string` may be `null` in sandbox — use `abapay_deeplink` instead
- `checkout_qr_url` may also be `null` in sandbox

---

### 2. Verify Payment (Polling)

**`POST /orders/{order_id}/verify-payment`**

No request body needed. Call this endpoint every 3-5 seconds after the user initiates payment.

#### Response (Payment Confirmed)
```json
{
    "data": {
        "id": "019cff25-8fb0-729b-95a7-bcf4d6189f52",
        "order_number": "ORD-KKW7EXFI",
        "subtotal": 15.0,
        "delivery_fee": 0.0,
        "total_amount": 15.0,
        "status": "PROCESSING",
        "payment_status": "PAID",
        "fulfillment_type": "PICKUP",
        "delivery_address": null,
        "items": [...],
        "created_at": "2026-03-18 11:12:57"
    },
    "success": true,
    "message": "Payment verified successfully."
}
```

#### Response (Not Yet Paid)
```json
{
    "success": false,
    "message": "Payment not found or not completed yet.",
    "aba_response": { ... }
}
```

#### Response (Already Paid)
```json
{
    "message": "Order is already paid."
}
```

---

### 3. Cancel Order

**`POST /orders/{order_id}/cancel`**

No request body. Only works if order `status` is `"PENDING"`.

#### Response
```json
{
    "data": { ... },
    "success": true,
    "message": "Order cancelled successfully."
}
```

---

### 4. Get Order Details

**`GET /orders/{order_id}`**

Returns the order with current `status` and `payment_status`.

---

### 5. List Orders

**`GET /orders`**

Returns paginated list of the user's orders, newest first.

---

## Mobile UI Implementation

### Payment Screen (shown after placing order)

```
┌─────────────────────────────┐
│                             │
│     Order: ORD-KKW7EXFI     │
│     Amount: $15.00          │
│                             │
│    ┌───────────────────┐    │
│    │                   │    │
│    │    QR Code Image   │    │
│    │   (from qr_string  │    │
│    │    or deeplink     │    │
│    │    qrcode param)   │    │
│    │                   │    │
│    └───────────────────┘    │
│                             │
│    ⏱ Expires in 14:32       │
│                             │
│  ┌─────────────────────┐    │
│  │   Open ABA App      │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │   Cancel Order       │    │
│  └─────────────────────┘    │
│                             │
└─────────────────────────────┘
```

### How to Use Each Field

| Field | What to do |
|-------|-----------|
| `qr_string` | If not null, render as a QR code image using a QR library. This is scannable by ABA app. |
| `abapay_deeplink` | Use as the "Open ABA App" button URL. On tap, open this URL — it launches the ABA app with payment pre-filled. Also extract the `qrcode` query parameter and render it as a QR code if `qr_string` is null. |
| `checkout_qr_url` | Fallback: open in a WebView if both above are unavailable. |

### QR Code Extraction from Deeplink

If `qr_string` is null, extract the QR data from `abapay_deeplink`:

```dart
// Dart/Flutter example
final uri = Uri.parse(abapayDeeplink);
final qrData = uri.queryParameters['qrcode'];
if (qrData != null) {
    final decodedQr = Uri.decodeComponent(qrData);
    // Render decodedQr as QR code image
}
```

### Polling Logic

```dart
// Dart/Flutter example
Timer.periodic(Duration(seconds: 4), (timer) async {
    final response = await api.post('/orders/$orderId/verify-payment');

    if (response['success'] == true) {
        timer.cancel();
        // Navigate to success screen
        showPaymentSuccess(response['data']);
    }
});

// Also set a timeout timer
Timer(Duration(minutes: 15), () {
    pollingTimer.cancel();
    // Show payment expired screen
    showPaymentExpired();
});
```

### "Open ABA App" Button

```dart
// Dart/Flutter example using url_launcher
final deeplink = paymentInfo['abapay_deeplink'];
if (await canLaunchUrl(Uri.parse(deeplink))) {
    await launchUrl(Uri.parse(deeplink), mode: LaunchMode.externalApplication);
} else {
    // ABA app not installed — show QR code for scanning instead
    showQRCode();
}
```

---

## Order & Payment Status Values

### `status`
| Value | Meaning |
|-------|---------|
| `PENDING` | Order created, awaiting payment |
| `PROCESSING` | Payment received, order being prepared |
| `CANCELLED` | Order was cancelled |

### `payment_status`
| Value | Meaning |
|-------|---------|
| `UNPAID` | No payment received yet |
| `PAID` | Payment confirmed |
| `FAILED` | Payment failed |

---

## Payment Method

To get the KHQR payment method ID for the order:

**`GET /api/v1/web/content-blocks/{id}`** or hardcode the KHQR payment method ID if it's fixed in your environment.

KHQR Payment Method ID (current): `59415cc0-4436-4aa6-ab61-79f690d1f350`

> Note: In production, you should fetch available payment methods dynamically rather than hardcoding.

---

## Error Handling

| Scenario | What to show |
|----------|-------------|
| `payment_info` is missing from order response | Payment method is not KHQR — no QR screen needed |
| `qr_string` and `checkout_qr_url` are both null | Extract QR from `abapay_deeplink` query param |
| Polling returns `success: false` for 15+ minutes | Show "Payment expired" with options to retry or cancel |
| Order cancel fails with 422 | Order is no longer PENDING (already paid or processing) |
| Cart is empty (422) | Show "Your cart is empty" message |
| Insufficient stock (422) | Show the product name from error message |

---

## Sequence Diagram

```
Mobile App                    API                         ABA PayWay
    │                          │                              │
    │  POST /orders            │                              │
    │─────────────────────────>│                              │
    │                          │  POST /payments/purchase     │
    │                          │─────────────────────────────>│
    │                          │  {qr_string, deeplink}       │
    │                          │<─────────────────────────────│
    │  {order + payment_info}  │                              │
    │<─────────────────────────│                              │
    │                          │                              │
    │  Show QR / Open ABA      │                              │
    │─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─>│
    │                          │                              │
    │                          │  POST /payway/callback       │
    │                          │<─────────────────────────────│
    │                          │  (order → PAID)              │
    │                          │                              │
    │  POST /verify-payment    │                              │
    │─────────────────────────>│                              │
    │  {payment_status: PAID}  │                              │
    │<─────────────────────────│                              │
    │                          │                              │
    │  Show Success Screen     │                              │
    │                          │                              │
```
