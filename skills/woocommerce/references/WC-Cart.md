# WC_Cart

**來源：** https://woocommerce.github.io/code-reference/classes/WC-Cart.html  
**取得全域實例：** `WC()->cart`

---

## Public Properties

| Property | Type | 說明 |
|----------|------|------|
| `$applied_coupons` | `array` | 已套用的優惠券代碼清單 |
| `$cart_contents` | `array` | 購物車內容（以 cart item key 為索引） |
| `$removed_cart_contents` | `array` | 已移除的項目（可還原） |
| `$totals` | `array` | 所有計算後的金額（subtotal, total, tax 等） |
| `$default_totals` | `array` | 預設金額結構（各欄位預設值） |
| `$shipping_methods` | `array` | 可用/已選擇的運送方式 |
| `$fees_api` | `WC_Cart_Fees` | 手續費管理物件 |
| `$session` | `WC_Cart_Session` | 購物車 session 管理物件 |
| `$has_calculated_shipping` | `bool` | 是否已計算運費 |

---

## Cart Item 結構

每個 `$cart_contents` 元素的陣列結構：

```php
[
    'key'          => 'cart_item_key',  // 唯一識別 key（由 generate_cart_id 產生）
    'product_id'   => 123,
    'variation_id' => 0,
    'variation'    => [],
    'quantity'     => 2,
    'data'         => WC_Product,      // 商品物件
    'data_hash'    => '...',
    'line_subtotal'     => 200.00,    // 折扣前小計
    'line_subtotal_tax' => 20.00,
    'line_total'        => 180.00,    // 折扣後實際金額
    'line_tax'          => 18.00,
    'line_tax_data'     => [...],
]
```

---

## Public Methods — 購物車內容

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `get_cart()` | — | `array` | 取得所有購物車項目（同 `get_cart_contents()`） |
| `get_cart_contents()` | — | `array` | 取得購物車項目 |
| `get_cart_item()` | `string $item_key` | `array` | 取得指定項目（不存在回傳空陣列） |
| `get_cart_contents_count()` | — | `int` | 購物車項目件數（數量加總） |
| `get_cart_contents_weight()` | — | `float` | 購物車總重量 |
| `get_cart_contents_total()` | — | `float\|string\|int` | 購物車商品總金額（不含稅） |
| `get_cart_hash()` | — | `string` | 購物車 hash（偵測內容是否異動） |
| `find_product_in_cart()` | `string $cart_id = ''` | `string` | 檢查指定商品是否已在購物車，回傳 cart item key（不存在回傳空字串） |
| `generate_cart_id()` | `int $product_id, int $variation_id = 0, array $variation = [], array $cart_item_data = []` | `string` | 產生購物車項目唯一 key |
| `get_removed_cart_contents()` | — | `array` | 取得已移除項目 |

---

## Public Methods — 購物車操作

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `add_to_cart()` | `int $product_id, int $quantity = 1, int $variation_id = 0, array $variation = [], array $cart_item_data = []` | `string\|bool` | 加入商品，成功回傳 cart item key，失敗回傳 `false` |
| `remove_cart_item()` | `string $cart_item_key` | `bool` | 移除指定項目（移至 removed_cart_contents） |
| `restore_cart_item()` | `string $cart_item_key` | `bool` | 還原已移除項目 |
| `set_quantity()` | `string $cart_item_key, int $quantity = 1, bool $refresh_totals = true` | `bool` | 更新項目數量（設為 `0` = 移除） |
| `empty_cart()` | `bool $clear_persistent_cart = true` | `void` | 清空購物車 |

---

## Public Methods — 優惠券

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `apply_coupon()` | `string $coupon_code` | `bool` | 套用優惠券 |
| `remove_coupon()` | `string $coupon_code` | `bool` | 移除優惠券 |
| `remove_coupons()` | — | `void` | 移除所有優惠券 |
| `get_applied_coupons()` | — | `array` | 取得已套用的優惠券代碼清單（字串陣列） |
| `get_coupons()` | — | `array` | 取得優惠券物件清單（`WC_Coupon[]`） |
| `get_coupon_discount_amount()` | `string $code, bool $ex_tax = true` | `float` | 指定優惠券的折扣金額 |
| `get_coupon_discount_tax_amount()` | `string $code` | `float` | 指定優惠券的折扣稅額 |
| `has_discount()` | `string $code = ''` | `bool` | 是否有折扣（傳入 code 則檢查特定券） |

---

## Public Methods — 金額（原始數值）

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_total()` | `float\|string` | 購物車總金額（`context = 'edit'` 回傳 float，`'view'` 回傳格式化字串） |
| `get_subtotal()` | `float` | 商品小計（不含稅） |
| `get_subtotal_tax()` | `float` | 商品小計稅額 |
| `get_total_tax()` | `float` | 稅額合計 |
| `get_discount_total()` | `float` | 折扣總額（不含稅） |
| `get_discount_tax()` | `float` | 折扣稅額 |
| `get_shipping_total()` | `float` | 運費（不含稅） |
| `get_shipping_tax()` | `float` | 運費稅額 |
| `get_fee_total()` | `float` | 手續費總額 |
| `get_fee_tax()` | `float` | 手續費稅額 |
| `get_taxes()` | `array` | 稅率分項原始資料 |
| `get_tax_totals()` | `array` | 稅率分項（格式化，含 label） |
| `get_totals()` | `array` | 所有金額欄位的完整陣列 |
| `get_fees()` | `array` | 手續費項目清單 |

---

## Public Methods — 金額（格式化顯示）

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_cart_subtotal()` | `string` | HTML 格式化小計（含稅顯示依設定） |
| `get_cart_total()` | `string` | HTML 格式化總金額 |
| `get_cart_shipping_total()` | `string` | HTML 格式化運費 |
| `get_cart_tax()` | `string` | HTML 格式化稅額 |

---

## Public Methods — 計算

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `calculate_totals()` | — | `void` | 重新計算所有金額（觸發 `woocommerce_calculate_totals` action） |
| `calculate_shipping()` | — | `void` | 重新計算運費 |
| `calculate_fees()` | — | `void` | 重新計算手續費 |

---

## Public Methods — 手續費

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `add_fee()` | `string $name, float $amount, bool $taxable = false, string $tax_class = ''` | `void` | 新增手續費（通常在 `woocommerce_cart_calculate_fees` hook 內呼叫） |
| `fees_api()` | — | `WC_Cart_Fees` | 取得手續費 API 物件 |

---

## Public Methods — 狀態判斷

| Method | Return Type | 說明 |
|--------|-------------|------|
| `is_empty()` | `bool` | 購物車是否為空 |
| `needs_payment()` | `bool` | 是否需要付款（總金額 > 0） |
| `needs_shipping()` | `bool` | 是否有需要運送的商品 |
| `needs_shipping_address()` | `bool` | 是否需要填寫運送地址 |
| `show_shipping()` | `bool` | 購物車頁是否顯示運費計算 |
| `has_calculated_shipping()` | `bool` | 是否已完成運費計算 |
| `display_prices_including_tax()` | `bool` | 是否含稅顯示價格 |
| `get_tax_price_display_mode()` | `string` | 稅務顯示模式（`incl` 或 `excl`） |

---

## Public Methods — 商品資訊

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `get_cross_sells()` | — | `array` | 交叉銷售商品 IDs（基於購物車內容） |
| `get_item_data()` | `array $cart_item, bool $flat = false` | `string` | 取得購物車項目的屬性/meta 顯示字串 |

---

## Public Methods — 客戶

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_customer()` | `WC_Customer` | 取得當前購物車客戶物件 |

---

## 常用開發範例

```php
$cart = WC()->cart;

// 取得所有項目
foreach ( $cart->get_cart() as $cart_item_key => $cart_item ) {
    $product  = $cart_item['data'];           // WC_Product
    $qty      = $cart_item['quantity'];       // int
    $subtotal = $cart_item['line_subtotal'];  // float（折扣前）
    $total    = $cart_item['line_total'];     // float（折扣後）

    echo $product->get_name() . ' x' . $qty;
}

// 加入商品
$cart_item_key = $cart->add_to_cart( 123, 2 );         // simple
$cart_item_key = $cart->add_to_cart( 123, 1, 456 );    // variable + variation_id

// 更新數量
$cart->set_quantity( $cart_item_key, 3 );

// 移除
$cart->remove_cart_item( $cart_item_key );

// 金額
$total    = $cart->get_total( 'edit' );  // float
$subtotal = $cart->get_subtotal();       // float

// 判斷狀態
if ( ! $cart->is_empty() && $cart->needs_payment() ) {
    // 需要結帳付款
}

// 新增手續費（在 hook 內使用）
add_action( 'woocommerce_cart_calculate_fees', function( $cart ) {
    $cart->add_fee( '服務費', 50, true );  // 含稅
} );
```

---

## 注意事項

- `add_to_cart()` 回傳的 `string` 是 cart item key（可用於後續操作），回傳 `false` 表示失敗（通常有 notice 訊息）
- `calculate_totals()` 會觸發多個 WooCommerce action，不要在 `woocommerce_cart_calculate_fees` hook 內呼叫，會造成無限迴圈
- `get_total()` 預設 context = `'view'`（格式化字串），改為 `'edit'` 取得 float 數值
- 直接修改 `$cart->cart_contents` 不會觸發計算，應透過 `set_quantity()` 或 `add_to_cart()` 操作
