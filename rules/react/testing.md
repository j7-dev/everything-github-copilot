---
paths:
  - "**/*.tsx"
  - "**/*.ts"
  - "**/vitest.config*"
  - "**/jest.config*"
---
# React Testing

> This file extends [common/testing.md](../common/testing.md) with React specific content.

## Framework

Use **Vitest** + **React Testing Library** for unit/integration tests.
Use **Playwright** for E2E tests.

## Component Testing

```tsx
import { render, screen, userEvent } from '@testing-library/react'
import { describe, it, expect, vi } from 'vitest'
import { UserCard } from './UserCard'

describe('UserCard', () => {
  it('calls onSelect when clicked', async () => {
    const onSelect = vi.fn()
    render(<UserCard userId="123" onSelect={onSelect} />)

    await userEvent.click(screen.getByRole('button'))
    expect(onSelect).toHaveBeenCalledWith('123')
  })
})
```

## Hook Testing

```tsx
import { renderHook, waitFor } from '@testing-library/react'
import { useUserData } from './useUserData'

it('fetches user data', async () => {
  const { result } = renderHook(() => useUserData('123'))

  await waitFor(() => expect(result.current.isLoading).toBe(false))
  expect(result.current.data).toBeDefined()
})
```

## Coverage

```bash
# Run with coverage
npx vitest run --coverage

# Minimum 80% required
```

## E2E Testing

```bash
# Run Playwright E2E tests
npx playwright test

# Use e2e-runner agent for E2E workflows
```

## Agent Support

- Use **react-reviewer** agent for test quality review
- Use **e2e-runner** agent for Playwright E2E tests
