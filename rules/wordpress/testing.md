---
paths:
  - "**/*.php"
  - "**/phpunit.xml*"
  - "**/composer.json"
---
# WordPress Testing

> This file extends [common/testing.md](../common/testing.md) with WordPress specific content.

## Framework

Use **PHPUnit** with the WordPress test framework for unit and integration tests.

## Setup

```bash
# Install test suite
composer require --dev phpunit/phpunit wp-phpunit/wp-phpunit

# Run tests
composer test
# or
vendor/bin/phpunit
```

## Test Organization

```php
<?php

declare(strict_types=1);

namespace J7\YourPlugin\Tests;

use WP_UnitTestCase;

class YourClassTest extends WP_UnitTestCase {

    public function test_it_creates_post(): void {
        $post_id = wp_insert_post([
            'post_title'  => 'Test Post',
            'post_status' => 'publish',
            'post_type'   => 'post',
        ]);

        $this->assertIsInt($post_id);
        $this->assertGreaterThan(0, $post_id);
    }
}
```

## Coverage

```bash
# Generate coverage report
vendor/bin/phpunit --coverage-html coverage/

# Check minimum coverage (80%)
vendor/bin/phpunit --coverage-text
```

## Agent Support

- Use **wordpress-reviewer** agent for test quality review
