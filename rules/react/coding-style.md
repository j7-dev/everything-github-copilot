---
paths:
  - "**/*.tsx"
  - "**/*.ts"
  - "**/*.jsx"
  - "**/*.js"
---
# React / TypeScript Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with React 18 / TypeScript specific content.

## Component Style

Always use function components with hooks — class components are legacy:

```tsx
// CORRECT: Function component with typed props
interface UserCardProps {
  userId: string
  onSelect?: (id: string) => void
}

export const UserCard: React.FC<UserCardProps> = ({ userId, onSelect }) => {
  return <div onClick={() => onSelect?.(userId)}>{userId}</div>
}
```

## Custom Hooks Pattern

Extract reusable logic into custom hooks:

```tsx
export function useUserData(userId: string) {
  const { data, isLoading, error } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetchUser(userId),
  })

  return { data, isLoading, error }
}
```

## Immutability

Always create new objects — never mutate state:

```tsx
// WRONG: Mutation
function updateUser(user: User, name: string): User {
  user.name = name  // MUTATION!
  return user
}

// CORRECT: Immutability
function updateUser(user: User, name: string): User {
  return { ...user, name }
}
```

## Error Handling

Wrap async operations in try-catch with user feedback:

```tsx
const handleSubmit = async (values: FormValues) => {
  try {
    await saveData(values)
    message.success('儲存成功')
  } catch (error) {
    console.error('Save failed:', error)
    message.error('儲存失敗，請重試')
  }
}
```

## Console.log

- No ``console.log`` statements in production code
- Use proper logging or remove debug statements before commit

## Reference

See agent: `react-reviewer` for comprehensive React code review.
