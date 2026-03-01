# WC_Product

**繼承自：** `WC_Abstract_Legacy_Product → WC_Data`  
**來源：** https://woocommerce.github.io/code-reference/classes/WC-Product.html  
**取得實例：** `wc_get_product( int $id )`

---

## Public Properties

| Property | Type | 說明 |
|----------|------|------|
| `$supports` | `array` | 支援的功能，如 `ajax_add_to_cart` |
| `$object_type` | `string` | 物件類型名稱 |
| `$post_type` | `string` | Post type（`product`） |
| `$cache_group` | `string` | 快取群組（`products`） |

> **注意：** `$data`（protected）儲存所有核心欄位，包括 name, sku, price, stock_quantity 等，應透過 getter/setter 存取，不直接操作。

---

## Public Methods — 資料讀取（Getters）

### 基本識別

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_id()` | `int` | 商品 ID |
| `get_name()` | `string` | 商品名稱 |
| `get_slug()` | `string` | URL slug |
| `get_type()` | `string` | 商品類型（`simple`, `variable`, `grouped`, `external`） |
| `get_status()` | `string` | 發佈狀態（`publish`, `draft` 等） |
| `get_sku()` | `string` | SKU |
| `get_global_unique_id()` | `string` | GTIN/EAN/ISBN 等全球唯一識別碼 |
| `get_permalink()` | `string` | 前台商品連結 |
| `get_formatted_name()` | `string` | 名稱附帶 SKU（用於後台顯示） |
| `get_parent_id()` | `int` | 父商品 ID（variation 用） |

### 價格

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_price()` | `string` | 當前有效售價（active price） |
| `get_regular_price()` | `string` | 原價 |
| `get_sale_price()` | `string` | 特價 |
| `get_price_html()` | `string` | 含 HTML 格式的價格顯示字串 |
| `get_price_suffix()` | `string` | 價格後綴（如含稅說明） |
| `get_date_on_sale_from()` | `WC_DateTime\|null` | 特價開始日期 |
| `get_date_on_sale_to()` | `WC_DateTime\|null` | 特價結束日期 |

### 庫存

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_stock_quantity()` | `int\|null` | 庫存數量，`null` 表示未啟用管理 |
| `get_stock_status()` | `string` | 庫存狀態（`instock`, `outofstock`, `onbackorder`） |
| `get_manage_stock()` | `bool` | 是否啟用庫存管理 |
| `get_backorders()` | `string` | 缺貨訂購設定（`no`, `notify`, `yes`） |
| `get_low_stock_amount()` | `int\|string` | 低庫存警示門檻 |
| `get_stock_managed_by_id()` | `int` | 實際管理庫存的商品 ID（variation 可能指向父商品） |

### 分類與標籤

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_category_ids()` | `array` | 商品分類 term IDs |
| `get_tag_ids()` | `array` | 商品標籤 term IDs |
| `get_brand_ids()` | `array` | 品牌 term IDs |
| `get_tax_class()` | `string` | 稅率等級 |
| `get_tax_status()` | `string` | 稅務狀態（`taxable`, `shipping`, `none`） |

### 圖片

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `get_image_id()` | — | `string` | 主圖 attachment ID |
| `get_gallery_image_ids()` | — | `array` | 相簿圖片 attachment IDs |
| `get_image()` | `$size = 'woocommerce_thumbnail', $attr = [], $placeholder = true` | `string` | 主圖 `<img>` HTML |

### 尺寸與重量

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_weight()` | `string` | 重量 |
| `get_length()` | `string` | 長 |
| `get_width()` | `string` | 寬 |
| `get_height()` | `string` | 高 |
| `get_dimensions()` | `string\|array` | 格式化尺寸（string = 顯示用；array = 原始值） |
| `get_shipping_class_id()` | `int` | 運送分級 ID |
| `get_shipping_class()` | `string` | 運送分級 slug |

### 屬性

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `get_attributes()` | — | `array` | 所有屬性（`WC_Product_Attribute[]`） |
| `get_attribute()` | `$attribute` | `string` | 指定屬性的值（字串，多值以 `, ` 串接） |
| `get_default_attributes()` | — | `array` | 預設選取的屬性值 |

### 下載

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_downloads()` | `array` | 可下載檔案（`WC_Product_Download[]`） |
| `get_download_limit()` | `int` | 下載次數限制（`-1` = 無限） |
| `get_download_expiry()` | `int` | 下載有效天數（`-1` = 永久） |
| `get_file($download_id)` | `array\|false` | 取得指定下載檔案 |
| `get_file_download_path($download_id)` | `string` | 取得檔案下載路徑 |

### 購買設定

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_sold_individually()` | `bool` | 是否每次只能購買一件 |
| `get_max_purchase_quantity()` | `int\|float` | 最大購買數量（`-1` = 無限） |
| `get_min_purchase_quantity()` | `int\|float` | 最小購買數量 |
| `get_purchase_quantity_step()` | `int\|float` | 數量遞增步驟 |
| `get_purchase_note()` | `string` | 購買後附注 |

### 評價與銷售

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_average_rating()` | `float` | 平均評分 |
| `get_review_count()` | `int` | 評論數 |
| `get_rating_count()` | `int` | 評分總數 |
| `get_rating_counts()` | `array` | 各星評分數量 |
| `get_total_sales()` | `int` | 總銷售件數 |

### 關聯商品

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_upsell_ids()` | `array` | 向上銷售商品 IDs |
| `get_cross_sell_ids()` | `array` | 交叉銷售商品 IDs |
| `get_children()` | `array` | 子商品 IDs（grouped/variable 適用） |

### 其他

| Method | Return Type | 說明 |
|--------|-------------|------|
| `get_featured()` | `bool` | 是否精選商品 |
| `get_catalog_visibility()` | `string` | 目錄可見性（`visible`, `catalog`, `search`, `hidden`） |
| `get_reviews_allowed()` | `bool` | 是否允許評論 |
| `get_date_created()` | `WC_DateTime\|null` | 建立日期 |
| `get_date_modified()` | `WC_DateTime\|null` | 修改日期 |
| `get_description()` | `string` | 完整描述 |
| `get_short_description()` | `string` | 簡短描述 |
| `get_virtual()` | `bool` | 是否虛擬商品（無運送） |
| `get_downloadable()` | `bool` | 是否可下載商品 |
| `get_menu_order()` | `int` | 排序順序 |
| `get_data()` | `array` | 所有核心資料（陣列格式） |
| `get_meta($key, $single = true, $context = 'view')` | `mixed` | 取得自訂 meta |

---

## Public Methods — 狀態判斷（Boolean Checks）

| Method | Return Type | 說明 |
|--------|-------------|------|
| `is_on_sale()` | `bool` | 是否特價中 |
| `is_in_stock()` | `bool` | 是否有庫存可購買 |
| `is_downloadable()` | `bool` | 是否可下載商品 |
| `is_virtual()` | `bool` | 是否虛擬商品 |
| `is_taxable()` | `bool` | 是否需課稅 |
| `is_shipping_taxable()` | `bool` | 運費是否課稅 |
| `is_purchasable()` | `bool` | 是否可加入購物車 |
| `is_featured()` | `bool` | 是否精選 |
| `is_visible()` | `bool` | 是否在目錄顯示 |
| `is_sold_individually()` | `bool` | 是否僅能單件購買 |
| `is_on_backorder($qty_in_cart = 0)` | `bool` | 是否缺貨訂購中 |
| `is_type($type)` | `bool` | 判斷商品類型 |
| `managing_stock()` | `bool` | 是否正在管理庫存 |
| `backorders_allowed()` | `bool` | 是否允許缺貨訂購 |
| `backorders_require_notification()` | `bool` | 缺貨訂購是否需通知客戶 |
| `needs_shipping()` | `bool` | 是否需要運送 |
| `has_dimensions()` | `bool` | 是否有尺寸設定 |
| `has_weight()` | `bool` | 是否有重量設定 |
| `has_attributes()` | `bool` | 是否有可見屬性 |
| `has_enough_stock($quantity)` | `bool` | 是否有足夠庫存 |
| `has_child()` | `bool` | 是否有子商品 |
| `has_options()` | `bool` | 是否需選擇選項（加入購物車前） |
| `has_file($download_id = '')` | `bool` | 是否有下載檔案 |
| `exists()` | `bool` | 商品 post 是否存在 |
| `supports($feature)` | `bool` | 是否支援指定功能 |
| `child_has_dimensions()` | `bool` | 子商品是否有尺寸 |
| `child_has_weight()` | `bool` | 子商品是否有重量 |

---

## Public Methods — 資料寫入（Setters）

| Method | Parameters | 說明 |
|--------|------------|------|
| `set_name()` | `string $name` | 設定商品名稱 |
| `set_slug()` | `string $slug` | 設定 URL slug |
| `set_status()` | `string $status` | 設定發佈狀態 |
| `set_sku()` | `string $sku` | 設定 SKU |
| `set_price()` | `string $price` | 設定當前售價 |
| `set_regular_price()` | `string $price` | 設定原價 |
| `set_sale_price()` | `string $price` | 設定特價 |
| `set_date_on_sale_from()` | `string\|integer\|null $date` | 設定特價開始日 |
| `set_date_on_sale_to()` | `string\|integer\|null $date` | 設定特價結束日 |
| `set_description()` | `string $description` | 設定完整描述 |
| `set_short_description()` | `string $description` | 設定簡短描述 |
| `set_stock_quantity()` | `int\|null $quantity` | 設定庫存數量 |
| `set_stock_status()` | `string $status` | 設定庫存狀態 |
| `set_manage_stock()` | `bool $manage_stock` | 設定是否管理庫存 |
| `set_backorders()` | `string $backorders` | 設定缺貨訂購（`no`/`notify`/`yes`） |
| `set_low_stock_amount()` | `int\|string $amount` | 設定低庫存警示量 |
| `set_weight()` | `string $weight` | 設定重量 |
| `set_length()` | `string $length` | 設定長 |
| `set_width()` | `string $width` | 設定寬 |
| `set_height()` | `string $height` | 設定高 |
| `set_tax_class()` | `string $class` | 設定稅率等級 |
| `set_tax_status()` | `string $status` | 設定稅務狀態 |
| `set_category_ids()` | `array $term_ids` | 設定商品分類 |
| `set_tag_ids()` | `array $term_ids` | 設定商品標籤 |
| `set_brand_ids()` | `array $term_ids` | 設定品牌 |
| `set_image_id()` | `string $image_id` | 設定主圖 |
| `set_gallery_image_ids()` | `array $image_ids` | 設定相簿圖片 |
| `set_attributes()` | `array $attributes` | 設定屬性 |
| `set_default_attributes()` | `array $default_attributes` | 設定預設屬性 |
| `set_featured()` | `bool $featured` | 設定精選 |
| `set_catalog_visibility()` | `string $visibility` | 設定目錄可見性 |
| `set_reviews_allowed()` | `bool $reviews_allowed` | 設定是否允許評論 |
| `set_virtual()` | `bool $virtual` | 設定虛擬商品 |
| `set_downloadable()` | `bool $downloadable` | 設定可下載 |
| `set_downloads()` | `array $downloads` | 設定下載檔案 |
| `set_download_limit()` | `int $download_limit` | 設定下載次數限制 |
| `set_download_expiry()` | `int $download_expiry` | 設定下載有效天數 |
| `set_upsell_ids()` | `array $upsell_ids` | 設定向上銷售 |
| `set_cross_sell_ids()` | `array $cross_sell_ids` | 設定交叉銷售 |
| `set_parent_id()` | `int $parent_id` | 設定父商品 ID |
| `set_sold_individually()` | `bool $sold_individually` | 設定單件銷售 |
| `set_purchase_note()` | `string $purchase_note` | 設定購買後附注 |
| `set_shipping_class_id()` | `int $id` | 設定運送分級 |
| `set_total_sales()` | `int $total_sales` | 設定銷售件數 |
| `set_menu_order()` | `int $menu_order` | 設定排序 |

---

## Public Methods — 動作

| Method | Parameters | Return Type | 說明 |
|--------|------------|-------------|------|
| `save()` | — | `int` | 儲存至資料庫，回傳商品 ID |
| `delete()` | `bool $force_delete = false` | `bool` | 刪除商品 |
| `add_to_cart_url()` | — | `string` | 加入購物車 URL |
| `add_to_cart_text()` | — | `string` | 加入購物車按鈕文字 |
| `single_add_to_cart_text()` | — | `string` | 商品頁加入購物車文字 |
| `get_availability()` | — | `array` | 庫存可用性資訊（包含 text 和 class） |

---

## Meta 操作

```php
// 讀取
$value = $product->get_meta( '_custom_field' );

// 新增（允許重複 key）
$product->add_meta_data( '_custom_field', 'value' );

// 更新（依 key 更新，不重複）
$product->update_meta_data( '_custom_field', 'value' );

// 刪除
$product->delete_meta_data( '_custom_field' );

// 儲存到資料庫
$product->save_meta_data();
// 或一併儲存商品資料與 meta
$product->save();
```

---

## 常用開發範例

```php
// 取得商品
$product = wc_get_product( 123 );

// 基本資料
$product->get_id();           // 123
$product->get_name();         // '商品名稱'
$product->get_type();         // 'simple'
$product->get_sku();          // 'SKU-001'
$product->get_price();        // '100' (字串)
$product->get_stock_quantity(); // 50

// 狀態判斷
if ( $product->is_in_stock() && $product->is_purchasable() ) {
    // 可加入購物車
}

// 修改並儲存
$product->set_stock_quantity( 30 );
$product->set_stock_status( 'instock' );
$product->save();
```
