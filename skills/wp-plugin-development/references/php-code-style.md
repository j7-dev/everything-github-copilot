# PHP code style (plugin work)

## File header

Every PHP file must start with:

```php
<?php
declare(strict_types=1);
```

## Naming conventions

| Element                          | Style            | Example            |
|----------------------------------|------------------|--------------------|
| Variables / functions / methods  | snake_case       | get_post_details() |
| Classes                          | PascalCase       | PostManager        |
| Constants                        | UPPER_SNAKE_CASE | MAX_ITEMS          |

## Class structure

Order within a class: properties → constructor → register_hooks → public methods → private methods.

Default to static methods; use `register_hooks()` as the single entry point for WordPress hook registration.

Mark classes as `final` when no subclassing is intended.

## String output — prefer Heredoc over concatenation

Never build HTML/multi-line strings with `.` concatenation.
Use Heredoc (with interpolation) or Nowdoc (literal) instead.

```php
// Bad
$html = '<div>' . $card_4no . '</div>';

// Good — Heredoc (interpolation supported)
$html = <<<HTML
    <div>{$card_4no}</div>
HTML;

// Good — Nowdoc (no interpolation needed)
$msg = <<<'MSG'
    Static message here.
MSG;
```

## Inline comments

Add inline comments for non-obvious logic. Write comments in Traditional Chinese.

## QA commands

```bash
composer lint     # phpcs — coding style
composer analyse  # phpstan — static analysis
```
