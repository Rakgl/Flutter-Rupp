# Mobile Payment Integration Guide (KHQR / ABA PayWay)

## Overview

Users can pay for orders using KHQR (ABA PayWay). The flow:
1. User adds items to cart
2. User places an order with `payment_method_id` for KHQR
3. API returns payment info (deeplink to open ABA app)
4. User pays in ABA app
5. Mobile app polls `verify-payment` endpoint until order is PAID
6. Show success screen

## Base URL

```
{{BASE_URL}}/api/v1/mobile
```

| Environment | BASE_URL |
|-------------|----------|
| Local dev | Your ngrok/tunnel URL (backend dev provides this) |
| Staging | `https://staging.yourdomain.com` |
| Production | `https://api.yourdomain.com` |

The mobile app does NOT need to know about ngrok or callbacks. Just use the configured base URL.

All authenticated endpoints require: `Authorization: Bearer {token}`

---

## Step 1: Fetch Payment Methods

**Do NOT hardcode payment method IDs.** Fetch them dynamically:

```
GET {{BASE_URL}}/api/v1/mobile/payment-methods
Authorization: Bearer {token}
```

### Response

```json
{
    "data": [
        {
            "id": "uuid-1",
            "name": "KHQR",
            "description": "Scan to pay with any banking app",
            "type": "BANK",
            "image": "https://..."
        },
        {
            "id": "uuid-2",
            "name": "Cash on Delivery",
            "description": "Pay with cash when your order arrives",
            "type": "CASH",
            "image": null
        },
        {
            "id": "uuid-3",
            "name": "Bank Transfer",
            "description": "Transfer directly to our bank account",
            "type": "BANK",
            "image": null
        }
    ]
}
```

### How to use

1. Call this endpoint when showing the checkout/payment method selection screen
2. Display all methods with their `name`, `description`, and `image`
3. When user selects one, store the `id` to send with the order
4. If `name === "KHQR"` → after order, show the payment screen with deeplink/QR (see Step 4)
5. If `name === "Cash on Delivery"` → after order, show order confirmation (no payment screen needed)

---

## Step 2: Add Items to Cart

```
POST {{BASE_URL}}/api/v1/mobile/cart/add
Authorization: Bearer {token}
Content-Type: application/json

{
    "item_id": "uuid-of-product",
    "item_type": "product",
    "quantity": 1
}
```

### Supported `item_type` values:
| item_type | Description |
|-----------|-------------|
| `product` | Store product |
| `pet_listing` | Pet from marketplace |
| `pet` | User's own pet |
| `service` | Grooming/vet service |

### View Cart

```
GET {{BASE_URL}}/api/v1/mobile/cart
Authorization: Bearer {token}
```

### Update Item Quantity

```
PUT {{BASE_URL}}/api/v1/mobile/cart/items/{cart_item_id}
Authorization: Bearer {token}
Content-Type: application/json

{
    "quantity": 3
}
```

### Remove Item

```
DELETE {{BASE_URL}}/api/v1/mobile/cart/items/{cart_item_id}
Authorization: Bearer {token}
```

### Clear Cart

```
DELETE {{BASE_URL}}/api/v1/mobile/cart/clear
Authorization: Bearer {token}
```

---

## Step 3: Place Order (Checkout)

```
POST {{BASE_URL}}/api/v1/mobile/orders
Authorization: Bearer {token}
Content-Type: application/json

{
    "fulfillment_type": "PICKUP",
    "payment_method_id": "{{selected_payment_method_id}}"
}
```

### Request Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `fulfillment_type` | string | Yes | `"PICKUP"` or `"DELIVERY"` |
| `delivery_address` | string | Only if DELIVERY | Max 500 chars |
| `payment_method_id` | UUID | Yes | ID from `GET /payment-methods` response |

### Success Response (with KHQR)

```json
{
    "data": {
        "id": "order-uuid",
        "order_number": "ORD-XXXXXXXX",
        "subtotal": 15,
        "delivery_fee": 0,
        "total_amount": 15,
        "status": "PENDING",
        "payment_status": "UNPAID",
        "fulfillment_type": "PICKUP",
        "delivery_address": null,
        "items": [
            {
                "id": "item-uuid",
                "itemable_id": "product-uuid",
                "itemable_type": "App\\Models\\Product",
                "quantity": 1,
                "unit_price": 15,
                "subtotal": 15,
                "item_name": "Interactive Laser Toy",
                "image_url": "https://..."
            }
        ],
        "created_at": "2026-03-18 08:23:57"
    },
    "success": true,
    "message": "Order placed successfully.",
    "payment_info": {
        "transaction_no": "ORD-XXXXXXXX",
        "qr_string": "00020101021230...",
        "abapay_deeplink": "abamobilebank://ababank.com?type=payway&qrcode=...",
        "checkout_qr_url": "https://checkout.ababank.com/qr/..."
    }
}
```

### Key Fields in `payment_info`

| Field | What to do with it |
|-------|-------------------|
| `abapay_deeplink` | **Primary.** Open this URL to launch ABA app for payment. Use as an "Open ABA" / "Pay Now" button. |
| `qr_string` | Render as a QR code image on screen (user can scan with ABA app). May be `null` in sandbox. |
| `checkout_qr_url` | Fallback web URL showing the QR. May be `null` in sandbox. |

> **Note:** In sandbox mode, `qr_string` and `checkout_qr_url` may return `null`. The `abapay_deeplink` is always returned.

---

## Step 4: Payment Screen (Mobile UI)

After placing the order, show a **Payment Screen** with:

1. **QR Code** — if `qr_string` is not null, render it as a QR image using a QR library
2. **"Pay with ABA" button** — opens `abapay_deeplink` using deep linking
3. **Order summary** — show `total_amount`, `order_number`
4. **Timer** — 15-minute countdown (QR expiry). After expiry, show "Payment expired" with option to cancel.
5. **Auto-polling** — start polling `verify-payment` every 3-5 seconds (see Step 5)

### Opening the Deeplink

**Flutter:**
```dart
import 'package:url_launcher/url_launcher.dart';

await launchUrl(Uri.parse(paymentInfo['abapay_deeplink']));
```

**React Native:**
```javascript
import { Linking } from 'react-native';

Linking.openURL(paymentInfo.abapay_deeplink);
```

**Kotlin (Android):**
```kotlin
val intent = Intent(Intent.ACTION_VIEW, Uri.parse(abapayDeeplink))
startActivity(intent)
```

**Swift (iOS):**
```swift
if let url = URL(string: abapayDeeplink) {
    UIApplication.shared.open(url)
}
```

---

## Step 5: Poll for Payment Verification

After showing the payment screen, poll this endpoint every **3-5 seconds**:

```
POST {{BASE_URL}}/api/v1/mobile/orders/{order_id}/verify-payment
Authorization: Bearer {token}
```

### Payment Successful Response

```json
{
    "data": {
        "id": "order-uuid",
        "order_number": "ORD-XXXXXXXX",
        "status": "PROCESSING",
        "payment_status": "PAID",
        ...
    },
    "success": true,
    "message": "Payment verified successfully."
}
```

### Payment Not Yet Completed Response (HTTP 422)

```json
{
    "success": false,
    "message": "Payment not found or not completed yet."
}
```

### Polling Logic (Pseudocode)

```
maxAttempts = 180  // 15 minutes at 5-second intervals
attempts = 0

while attempts < maxAttempts:
    response = POST /orders/{order_id}/verify-payment

    if response.success == true:
        // Payment confirmed!
        navigateTo(OrderSuccessScreen)
        stopPolling()
        return

    if response.status == 422:
        // Not paid yet, keep polling
        wait(5 seconds)
        attempts++
        continue

    // Other error
    showError(response.message)
    stopPolling()
    return

// Timeout - 15 minutes passed
showExpiredScreen()
```

---

## Step 6: Cancel Order (Optional)

If the user wants to cancel before paying:

```
POST {{BASE_URL}}/api/v1/mobile/orders/{order_id}/cancel
Authorization: Bearer {token}
```

### Response

```json
{
    "data": {
        "id": "order-uuid",
        "status": "CANCELLED",
        ...
    },
    "success": true,
    "message": "Order cancelled successfully."
}
```

> Only `PENDING` orders can be cancelled.

---

## Step 7: View Orders

### List All Orders

```
GET {{BASE_URL}}/api/v1/mobile/orders
Authorization: Bearer {token}
```

Returns paginated list of user's orders, newest first.

### View Single Order

```
GET {{BASE_URL}}/api/v1/mobile/orders/{order_id}
Authorization: Bearer {token}
```

---

## Order Status Flow

```
PENDING (created, awaiting payment)
    ├── PAID → PROCESSING (payment confirmed)
    │           └── COMPLETED (fulfilled by store)
    └── CANCELLED (user cancelled before paying)
```

| Status | Payment Status | Meaning |
|--------|---------------|---------|
| `PENDING` | `UNPAID` | Order created, waiting for payment |
| `PROCESSING` | `PAID` | Payment confirmed, store is preparing |
| `COMPLETED` | `PAID` | Order fulfilled |
| `CANCELLED` | `UNPAID` | User cancelled the order |

---

## Error Handling

| HTTP Code | Meaning | Action |
|-----------|---------|--------|
| 200 | Success | Process response |
| 403 | Unauthorized (not your order) | Show error, go back |
| 422 | Validation error / payment pending | Show message or keep polling |
| 500 | Server error | Show generic error, retry |

---

## Summary of Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/payment-methods` | Yes | Fetch available payment methods |
| GET | `/payment-history` | Yes | User's order/payment history (all statuses) |
| GET | `/cart` | Yes | View current cart |
| POST | `/cart/add` | Yes | Add item to cart |
| PUT | `/cart/items/{id}` | Yes | Update item quantity |
| DELETE | `/cart/items/{id}` | Yes | Remove item from cart |
| DELETE | `/cart/clear` | Yes | Clear entire cart |
| POST | `/orders` | Yes | Place order (returns payment info if KHQR) |
| GET | `/orders` | Yes | List user's orders |
| GET | `/orders/{id}` | Yes | View single order |
| POST | `/orders/{id}/verify-payment` | Yes | Check if payment went through |
| POST | `/orders/{id}/cancel` | Yes | Cancel a pending order |
