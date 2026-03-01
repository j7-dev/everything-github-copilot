---
paths:
  - "**/*.php"
  - "**/composer.json"
---
# WordPress Security

> This file extends [common/security.md](../common/security.md) with WordPress specific content.

## SQL Injection Prevention

Always use ``$wpdb->prepare()`` — NEVER string concatenation:

```php
// WRONG: SQL injection vulnerability
$results = $wpdb->get_results("SELECT * FROM {$wpdb->posts} WHERE ID = {$id}");

// CORRECT: Prepared statement
$results = $wpdb->get_results(
    $wpdb->prepare("SELECT * FROM %i WHERE ID = %d", $wpdb->posts, $id)
);
```

## XSS Prevention (Output Escaping)

Always escape before output:

```php
// Text content
echo esc_html($user_input);

// HTML attributes
echo esc_attr($attribute_value);

// URLs
echo esc_url($url);

// HTML content (limited tags)
echo wp_kses_post($html_content);

// JavaScript
echo esc_js($js_value);
```

## CSRF Protection (Nonces)

```php
// Generate nonce field in form
wp_nonce_field('my_action', 'my_nonce');

// Verify nonce in handler
if (!wp_verify_nonce($_POST['my_nonce'] ?? '', 'my_action')) {
    wp_die('Security check failed');
}

// For AJAX
check_ajax_referer('my_action', 'nonce');
```

## Input Sanitization

```php
// Text
$name = sanitize_text_field($_POST['name'] ?? '');

// Integer
$id = absint($_GET['id'] ?? 0);

// Email
$email = sanitize_email($_POST['email'] ?? '');

// HTML (for editors)
$content = wp_kses_post($_POST['content'] ?? '');

// File name
$filename = sanitize_file_name($_FILES['upload']['name'] ?? '');
```

## Capability Checks

Always verify user capabilities before privileged operations:

```php
if (!current_user_can('manage_options')) {
    wp_die('Unauthorized', 403);
}

// In REST API callback
'permission_callback' => function() {
    return current_user_can('edit_posts');
},
```

## Secret Management

```php
// NEVER: Hardcoded secrets
$api_key = 'sk-proj-xxxxx';

// ALWAYS: WordPress options or constants defined outside version control
$api_key = get_option('my_plugin_api_key', '');
// Or defined in wp-config.php
$api_key = defined('MY_API_KEY') ? MY_API_KEY : '';
```

## Agent Support

- Use **wordpress-reviewer** agent for comprehensive security audits
