# WC_Order_Item_Product

**繼承自：** `WC_Order_Item → WC_Data`  
**來源：** https://woocommerce.github.io/code-reference/classes/WC-Order-Item-Product.html  
**類型識別：** `get_type()` 回傳 `'line_item'`  
**取得方式：** `$order->get_items()` 回傳的陣列元素

---

## Public Properties

> 核心資料存放於 `$extra_data`（protected），透過 getter/setter 存取。

| Property | Type | 說明 |
|----------|------|------|
| `$legacy_cart_item_key` | `string` | ⚠️ 已棄用 |
| `$legacy_values` | `array` | ⚠️ 已棄用 |

---

## Extra Data 欄位（透過 Getter/Setter 存取）

| 欄位 | Type | 說明 |
|------|------|------|
| `product_id` | `int` | 商品 ID（父商品，variable 的話是 parent） |
| `variation_id` | `int` | 變體 ID（非 variation 則為 0） |
| `quantity` | `int` | 購買數量 |
| `tax_class` | `string` | 稅率等級 |
| `subtotal` | `string` | 小計（折扣前） |
| `subtotal_tax` | `string` | 小計稅額 |
| `total` | `string` | 實際金額（折扣後） |
| `total_tax` | `string` | 實際稅額 |
| `taxes` | `array` | 各稅率分項資料 |

---

## Public Methods — 資料讀取（Getters）

### 商品識別

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_product_id()` | `int` | 商品 ID（variable 時為父商品 ID） |
| `get_variation_id()` | `int` | 變體 ID（`0` = 非 variation） |
| `get_product()` | `WC_Product\|bool` | 取得 WC_Product 物件（失敗回傳 `false`） |
| `get_name()` | `string` | 商品名稱（含 variation 屬性，如 `T-Shirt - Red, L`） |
| `get_type()` | `string` | 固定回傳 `'line_item'` |

### 數量與金額

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_quantity()` | `int` | 購買數量 |
| `get_subtotal()` | `string` | 小計（折扣前、不含稅） |
| `get_subtotal_tax()` | `string` | 小計稅額 |
| `get_total()` | `string` | 實際金額（折扣後、不含稅） |
| `get_total_tax()` | `string` | 實際稅額 |
| `get_taxes()` | `array` | 稅率分項（格式：`['total' => [...], 'subtotal' => [...]]`） |
| `get_tax_class()` | `string` | 稅率等級 |
| `get_tax_status()` | `string` | 稅務狀態（`taxable`, `shipping`, `none`） |

### 關聯

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_order_id()` | `int` | 所屬訂單 ID |
| `get_order()` | `WC_Order` | 取得所屬 WC_Order 物件 |

---

## Public Methods — 下載

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `get_item_downloads()` | — | `array` | 取得可下載檔案清單（含 download URL） |
| `get_item_download_url()` | `string $download_id` | `string` | 取得指定下載檔案的 URL |

---

## Public Methods — Meta

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `get_meta()` | `string $key, bool $single = true, string $context = 'view'` | `mixed` | 取得自訂 meta（variation 屬性也以 meta 形式存在） |
| `get_formatted_meta_data()` | `string $hideprefix = '_', bool $include_all = false` | `array` | 取得格式化 meta（前台顯示用，可自動隱藏底線開頭） |
| `add_meta_data()` | `string $key, mixed $value, bool $unique = false` | `void` | 新增 meta |
| `update_meta_data()` | `string $key, mixed $value` | `void` | 更新 meta |
| `delete_meta_data()` | `string $key` | `void` | 刪除 meta |

---

## Public Methods — 資料寫入（Setters）

| Method | Parameters | 說明 |
|--------|------------|------|
| `set_product_id()` | `int $value` | 設定商品 ID |
| `set_variation_id()` | `int $value` | 設定變體 ID |
| `set_quantity()` | `int\|string $value` | 設定數量 |
| `set_subtotal()` | `string $value` | 設定小計 |
| `set_subtotal_tax()` | `string $value` | 設定小計稅額 |
| `set_total()` | `string $value` | 設定實際金額 |
| `set_total_tax()` | `string $value` | 設定實際稅額 |
| `set_tax_class()` | `string $value` | 設定稅率等級 |
| `set_taxes()` | `array $raw_tax_data` | 設定稅率分項 |
| `set_product()` | `WC_Product $product` | 設定關聯商品（同時帶入 product_id, name, tax_class 等） |
| `set_variation()` | `array $variation` | 設定 variation 選項值 |
| `set_backorder_meta()` | — | `void` | 設定缺貨訂購標記 meta |

---

## Public Methods — 儲存

| Method | Return Type | 說明 |
|--------|-------------|------|
| `save()` | `int` | 儲存至資料庫，回傳 item ID |

---

## 常用開發範例

```php
$order = wc_get_order( 456 );
$items = $order->get_items(); // WC_Order_Item_Product[]

foreach ( $items as $item_id => $item ) {
    // 取得商品物件
    $product = $item->get_product();  // WC_Product|false

    // 基本資料
    $name        = $item->get_name();         // 'T-Shirt - Red, L'
    $product_id  = $item->get_product_id();   // 父商品 ID
    $variation_id = $item->get_variation_id(); // 變體 ID（非 variation 為 0）
    $qty         = $item->get_quantity();     // 2

    // 金額（都是字串）
    $subtotal    = $item->get_subtotal();     // '200.00'（折扣前）
    $total       = $item->get_total();        // '160.00'（折扣後）
    $total_tax   = $item->get_total_tax();    // '16.00'

    // Meta（如變體屬性）
    $color = $item->get_meta( 'pa_color' );

    // 格式化 meta（前台顯示）
    $meta_data = $item->get_formatted_meta_data( '_' );
    foreach ( $meta_data as $meta ) {
        echo $meta->display_key . ': ' . $meta->display_value;
    }
}

// 計算總稅額（考慮 subtotal vs total 差異）
// subtotal = 折扣前，total = 折扣後（實際收費）
// 通常應使用 total，而非 subtotal
```

---

## 注意事項

- `get_subtotal()` vs `get_total()`：`subtotal` 是折扣前金額，`total` 是套用折扣後的實際收費金額，報表計算應使用 `total`
- variation 的 `get_product_id()` 回傳的是**父商品 ID**，要取得 variation 本身的商品物件需使用 `get_variation_id()` 搭配 `wc_get_product()`
- `get_product()` 會回傳 `false`（若商品已刪除），呼叫前務必做 null check
