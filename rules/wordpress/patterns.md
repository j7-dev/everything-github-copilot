---
paths:
  - "**/*.php"
  - "**/composer.json"
---
# WordPress Patterns

> This file extends [common/patterns.md](../common/patterns.md) with WordPress specific content.

## Singleton Pattern

Use ``SingletonTrait`` for all plugin classes:

```php
final class MyService {
    use \J7\WpUtils\Traits\SingletonTrait;

    public function __construct() {
        // Initialize
    }
}

// Usage
MyService::instance();
```

## REST API Pattern

Extend ``ApiBase`` for REST endpoints:

```php
final class V2Api extends ApiBase {
    use \J7\WpUtils\Traits\SingletonTrait;

    protected $namespace = 'v2/myplugin';

    protected $apis = [
        [
            'endpoint'            => 'items',
            'method'              => 'get',
            'permission_callback' => null,
        ],
    ];

    public function get_items_callback(\WP_REST_Request $request): \WP_REST_Response {
        // Handle request
    }
}
```

## Repository Pattern for WP_Query

```php
final class PostRepository {

    /**
     * Find posts by criteria
     *
     * @param array<string, mixed> $args Query arguments
     * @return \WP_Post[]
     */
    public static function find(array $args = []): array {
        $defaults = [
            'post_type'      => 'post',
            'post_status'    => 'publish',
            'posts_per_page' => 20,
        ];

        $query = new \WP_Query(\wp_parse_args($args, $defaults));
        return $query->posts;
    }
}
```

## Transient Caching Pattern

```php
public static function get_expensive_data(int $id): array {
    $cache_key = "my_plugin_data_{$id}";
    $cached    = \get_transient($cache_key);

    if ($cached !== false) {
        return $cached;
    }

    $data = self::fetch_from_api($id);
    \set_transient($cache_key, $data, HOUR_IN_SECONDS);

    return $data;
}
```

## DTO Pattern

```php
class PostDTO extends BaseDTO {

    /** @var int $id Post ID */
    public int $id = 0;

    /** @var string $title Post title */
    public string $title = '';

    /** @var string $status Post status */
    public string $status = 'publish';
}
```

## Reference

See agent: `wordpress-reviewer` for pattern review.
