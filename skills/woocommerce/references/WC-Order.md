# WC_Order

**繼承自：** `WC_Abstract_Order → WC_Data`  
**來源：** https://woocommerce.github.io/code-reference/classes/WC-Order.html  
**取得實例：** `wc_get_order( int $id )`

---

## Public Properties

| Property | Type | 說明 |
|----------|------|------|
| `$refunds` | `array` | 此訂單的退款物件清單（延遲載入） |

---

## Public Methods — 狀態

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `get_status()` | — | `string` | 訂單狀態（不含 `wc-` 前綴，如 `pending`, `processing`, `completed`） |
| `has_status()` | `string\|array $status` | `bool` | 判斷是否符合指定狀態 |
| `update_status()` | `string $new_status, string $note = '', bool $manual = false` | `bool` | 更新訂單狀態 |
| `is_paid()` | — | `bool` | 是否已付款（completed/processing/refunded） |
| `is_editable()` | — | `bool` | 是否可編輯（pending/on-hold/auto-draft） |
| `needs_payment()` | — | `bool` | 是否需要付款 |
| `needs_processing()` | — | `bool` | 是否需要處理（含實體商品） |
| `payment_complete()` | `string $transaction_id = ''` | `bool` | 標記訂單付款完成，自動切換狀態 |

---

## Public Methods — 訂單識別與基本資料

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_id()` | `int` | 訂單 ID |
| `get_type()` | `string` | 物件類型（`shop_order`） |
| `get_order_number()` | `string` | 訂單編號（可被外掛覆寫，預設 = ID） |
| `get_order_key()` | `string` | 訂單驗證 key |
| `get_date_created()` | `WC_DateTime\|null` | 建立日期 |
| `get_date_modified()` | `WC_DateTime\|null` | 最後修改日期 |
| `get_date_paid()` | `WC_DateTime\|null` | 付款日期 |
| `get_date_completed()` | `WC_DateTime\|null` | 完成日期 |
| `get_currency()` | `string` | 幣別（如 `TWD`, `USD`） |
| `get_created_via()` | `string` | 建立來源（如 `checkout`, `admin`, `rest-api`） |
| `get_cart_hash()` | `string` | 購物車 hash（防重複送出） |
| `get_customer_note()` | `string` | 客戶備注 |
| `get_customer_ip_address()` | `string` | 客戶 IP |
| `get_customer_user_agent()` | `string` | 客戶 User-Agent |
| `get_transaction_id()` | `string` | 金流交易 ID |

---

## Public Methods — 客戶

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_customer_id()` | `int` | 客戶 user ID（`0` = 訪客） |
| `get_user()` | `WP_User\|false` | 取得 WP_User 物件 |
| `get_user_id()` | `int` | 同 get_customer_id() |

---

## Public Methods — 帳單地址（Billing）

| Method | Return Type |
|--------|-------------|
| `get_billing_first_name()` | `string` |
| `get_billing_last_name()` | `string` |
| `get_billing_company()` | `string` |
| `get_billing_address_1()` | `string` |
| `get_billing_address_2()` | `string` |
| `get_billing_city()` | `string` |
| `get_billing_state()` | `string` |
| `get_billing_postcode()` | `string` |
| `get_billing_country()` | `string` |
| `get_billing_email()` | `string` |
| `get_billing_phone()` | `string` |
| `get_formatted_billing_address()` | `string` (HTML 格式化地址) |

---

## Public Methods — 運送地址（Shipping）

| Method | Return Type |
|--------|-------------|
| `get_shipping_first_name()` | `string` |
| `get_shipping_last_name()` | `string` |
| `get_shipping_company()` | `string` |
| `get_shipping_address_1()` | `string` |
| `get_shipping_address_2()` | `string` |
| `get_shipping_city()` | `string` |
| `get_shipping_state()` | `string` |
| `get_shipping_postcode()` | `string` |
| `get_shipping_country()` | `string` |
| `get_shipping_phone()` | `string` |
| `get_formatted_shipping_address()` | `string` (HTML 格式化地址) |

---

## Public Methods — 付款

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_payment_method()` | `string` | 付款方式 ID（如 `paypal`, `bacs`） |
| `get_payment_method_title()` | `string` | 付款方式顯示名稱 |

---

## Public Methods — 金額

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_total()` | `float` | 訂單總金額（含稅、含運費、含折扣後） |
| `get_subtotal()` | `float` | 商品小計 |
| `get_total_tax()` | `float` | 稅額小計 |
| `get_discount_total()` | `string` | 折扣總額（不含稅） |
| `get_discount_tax()` | `string` | 折扣稅額 |
| `get_shipping_total()` | `string` | 運費（不含稅） |
| `get_shipping_tax()` | `string` | 運費稅額 |
| `get_cart_tax()` | `string` | 購物車稅額 |
| `get_total_discount()` | `float` | 取得含稅折扣總額 |
| `get_total_fees()` | `float` | 手續費總額 |
| `get_total_refunded()` | `string` | 已退款總額 |
| `get_remaining_refund_amount()` | `string` | 剩餘可退款金額 |
| `get_formatted_order_total()` | `string` | HTML 格式化總金額 |

---

## Public Methods — 訂單項目

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `get_items()` | `string\|array $types = 'line_item'` | `array` | 取得項目清單，可指定類型（`line_item`, `fee`, `shipping`, `tax`, `coupon`） |
| `get_item()` | `int $item_id` | `WC_Order_Item\|false` | 取得單一項目 |
| `get_item_count()` | `string $item_type = ''` | `int\|string` | 取得項目件數 |
| `get_fees()` | — | `array` | 手續費項目 |
| `get_taxes()` | — | `array` | 稅項 |
| `get_coupons()` | — | `array` | 優惠券項目 |
| `get_coupon_codes()` | — | `array` | 使用的優惠券代碼清單 |
| `get_shipping_methods()` | — | `array` | 運送方式項目 |
| `add_product()` | `WC_Product $product, int $qty = 1, array $args = []` | `int\|WP_Error` | 新增商品至訂單，回傳 item ID |
| `add_item()` | `WC_Order_Item $item` | `false\|void` | 新增任意項目 |
| `remove_item()` | `int $item_id` | `false\|void` | 移除項目 |
| `remove_order_items()` | `string $type = null` | `void` | 移除全部（或指定類型）項目 |
| `get_order_item_totals()` | `string $context = 'view'` | `array` | 取得訂單顯示用金額摘要（含運費、稅、折扣等） |

---

## Public Methods — 計算

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `calculate_totals()` | `bool $and_taxes = true` | `float` | 重新計算訂單總金額 |
| `calculate_taxes()` | `array $args = []` | `void` | 重新計算稅額 |
| `calculate_shipping()` | — | `float` | 重新計算運費 |
| `apply_coupon()` | `string $coupon_code` | `true\|WP_Error` | 套用優惠券 |
| `remove_coupon()` | `string $code` | `bool` | 移除優惠券 |

---

## Public Methods — URL

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_view_order_url()` | `string` | 前台訂單查看 URL |
| `get_edit_order_url()` | `string` | 後台編輯 URL |
| `get_checkout_payment_url()` | `string` | 付款頁 URL |
| `get_checkout_order_received_url()` | `string` | 感謝頁 URL |
| `get_cancel_order_url()` | `string` | 取消訂單 URL |

---

## Public Methods — 訂單備注

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `add_order_note()` | `string $note, int $is_customer_note = 0, bool $added_by_user = false` | `int` | 新增訂單備注，回傳 comment ID |
| `get_customer_order_notes()` | — | `array` | 取得所有客戶可見備注 |

---

## Public Methods — 退款

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `get_refunds()` | — | `array` | 取得退款物件清單（`WC_Order_Refund[]`） |
| `get_total_refunded()` | — | `string` | 已退款金額 |
| `get_remaining_refund_amount()` | — | `string` | 可退款餘額 |
| `get_qty_refunded_for_item()` | `int $item_id` | `int` | 指定項目已退款數量 |
| `get_total_qty_refunded()` | — | `int` | 所有項目退款總數量 |

---

## Public Methods — 地址判斷

| Method | Return Type | 說明 |
|--------|------------|------|
| `has_billing_address()` | `bool` | 是否有帳單地址 |
| `has_shipping_address()` | `bool` | 是否有運送地址 |
| `has_downloadable_item()` | `bool` | 是否含可下載商品 |
| `has_shipping_method()` | `bool` | 是否包含指定運送方式 |
| `needs_shipping()` | `bool` | 是否需要運送 |
| `needs_shipping_address()` | `bool` | 是否需要運送地址 |
| `key_is_valid()` | `bool` | 訂單 key 是否有效 |
| `is_download_permitted()` | `bool` | 是否允許下載 |

---

## Public Methods — Meta 操作

```php
$order->get_meta( '_tracking_number' );
$order->update_meta_data( '_tracking_number', '123456' );
$order->add_meta_data( '_note', 'extra info' );
$order->delete_meta_data( '_note' );
$order->save_meta_data(); // 或直接 save()
```

---

## Public Methods — 儲存

| Method | Return Type | 說明 |
|--------|-------------|------|
| `save()` | `int` | 儲存訂單至資料庫，回傳訂單 ID |
| `delete()` | `bool` | 刪除訂單 |

---

## 常用開發範例

```php
$order = wc_get_order( 456 );

// 狀態操作
$order->get_status();                    // 'processing'
$order->has_status( 'completed' );       // false
$order->update_status( 'completed', '已出貨', true );

// 取得商品項目
$items = $order->get_items(); // array of WC_Order_Item_Product
foreach ( $items as $item_id => $item ) {
    $product  = $item->get_product();
    $quantity = $item->get_quantity();
    $total    = $item->get_total();
}

// 取得地址
$email   = $order->get_billing_email();
$country = $order->get_shipping_country();

// 金額
$total    = $order->get_total();         // float
$discount = $order->get_discount_total(); // string

// 新增備注
$order->add_order_note( '訂單已出貨', 1 ); // 第二參數 1 = 客戶可見

// 標記付款完成
$order->payment_complete( 'TXN-12345' );

// Meta
$order->update_meta_data( '_shipped_at', date('Y-m-d H:i:s') );
$order->save();
```
