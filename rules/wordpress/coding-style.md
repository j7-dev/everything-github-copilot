---
paths:
  - "**/*.php"
  - "**/composer.json"
  - "**/composer.lock"
---
# WordPress / PHP Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with WordPress/PHP specific content.

## Strict Types

All PHP files must start with:

```php
<?php

declare(strict_types=1);
```

## Naming Conventions

- **snake_case**: variables, functions, methods
- **PascalCase**: classes, interfaces, traits
- **UPPER_SNAKE_CASE**: constants
- **kebab-case**: hook names, post type slugs, option names

## Class Structure

Use the Singleton pattern with `SingletonTrait`:

```php
final class YourClass {
    use \J7\WpUtils\Traits\SingletonTrait;

    public function __construct() {
        $this->register_hooks();
    }

    private function register_hooks(): void {
        \add_action('init', [ __CLASS__, 'init_callback' ]);
    }
}
```

## PHPDoc Comments

All public functions and methods must have PHPDoc with typed params and return types:

```php
/**
 * Get post details
 *
 * @param int $post_id Post ID
 * @param bool $with_meta Include meta data
 * @return array<string, mixed>
 * @throws \Exception When post not found
 */
public static function get_post_details(int $post_id, bool $with_meta = false): array {
```

## Direct File Access Guard

All PHP files that should not be accessed directly:

```php
defined('ABSPATH') || exit;
```

## Immutability

Return new arrays/objects rather than mutating existing ones:

```php
// WRONG: Mutation
function add_item(array &$items, mixed $item): void {
    $items[] = $item;
}

// CORRECT: Immutability
function add_item(array $items, mixed $item): array {
    return [...$items, $item];
}
```

## Reference

See agent: `wordpress-reviewer` for comprehensive WordPress code review.
