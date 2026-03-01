# CI 環境整合指南

## GitHub Actions（跨平台）

```yaml
name: Avalonia Headless Tests

on: [push, pull_request]

jobs:
  test:
    strategy:
      matrix:
        os: [windows-latest, ubuntu-latest, macos-latest]
    runs-on: ${{ matrix.os }}

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '9.x'

      - name: Restore
        run: dotnet restore

      - name: Build
        run: dotnet build --no-restore

      - name: Run Headless Tests
        # Linux 不需要 Xvfb，headless 直接執行
        run: |
          dotnet test ./tests/MyApp.Tests \
            --no-build \
            --logger "trx;LogFileName=results.trx" \
            --blame-hang-timeout 5m \
            --blame-hang-dump-type full

      - name: Upload Test Results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: test-results-${{ matrix.os }}
          path: '**/*.trx'
```

## 平行執行控制

```csharp
// AssemblyInfo.cs
// 單一 Dispatcher 不可並行 — 停用平行可避免 race condition
[assembly: CollectionBehavior(DisableTestParallelization = true)]
[assembly: AvaloniaTestFramework]
[assembly: AvaloniaTestApplication(typeof(TestApp))]
```

## 診斷 Hang 與 Deadlock

```bash
# 取得 hang dump
dotnet test --blame-hang-timeout 5m --blame-hang-dump-type full

# 分析 dump
dotnet-dump analyze <dump-file>
```

## 失敗時捕獲 Screenshot

```csharp
// 在 xUnit 中使用 ITestOutputHelper 記錄截圖路徑
public class MyTests
{
    private readonly ITestOutputHelper _output;
    public MyTests(ITestOutputHelper output) => _output = output;

    [AvaloniaFact]
    public void 測試帶截圖()
    {
        var window = new Window { Content = new TextBlock { Text = "Test" } };
        window.Show();

        try
        {
            // ... 測試邏輯
        }
        catch
        {
            // 失敗時捕獲截圖
            var frame = window.CaptureRenderedFrame();
            var path = Path.Combine(Path.GetTempPath(), $"fail_{DateTime.Now:yyyyMMdd_HHmmss}.png");
            frame?.Save(path);
            _output.WriteLine($"Screenshot saved: {path}");
            throw;
        }
        finally
        {
            window.Close();
        }
    }
}
```

## 環境清理（防止 CI stale state）

```yaml
- name: Cleanup stale processes (macOS/Linux)
  if: runner.os != 'Windows'
  run: pkill -f "MyTestApp" || true

- name: Cleanup stale processes (Windows)
  if: runner.os == 'Windows'
  run: Get-Process | Where-Object { $_.Name -like "*MyTestApp*" } | Stop-Process -Force -ErrorAction SilentlyContinue
```
