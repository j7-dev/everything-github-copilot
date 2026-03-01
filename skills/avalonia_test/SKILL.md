---
name: avalonia-test
description: >
  Expert in Avalonia 11.x headless unit testing with xUnit (Avalonia.Headless.XUnit).
  Covers [AvaloniaFact]/[AvaloniaTheory] attributes, AvaloniaTestApplication setup,
  UseHeadless() initialization, simulating keyboard/mouse/drag-drop input,
  visual regression with Skia, ViewModel-only testing, and CI integration.
  Use this skill whenever the user needs to: write headless UI tests for Avalonia controls,
  simulate clicks/typing/drag-drop in tests, fix [AvaloniaFact] NullReferenceException,
  set up an Avalonia headless test project from scratch, use ForceRenderTimerTick correctly,
  run Avalonia tests on Linux CI without a display, or do visual regression comparison.
  Also activate for questions about AvaloniaHeadlessPlatform, window.Show()/Close() in tests,
  focus-before-input patterns, or CollectionBehavior parallelization issues.
---

# Avalonia 11.x Headless 單元測試技能

## 核心原則

Avalonia UI 測試的核心挑戰：UI 控制項需在 Avalonia Dispatcher 執行緒上操作，而 xUnit 預設在執行緒池執行。`Avalonia.Headless.XUnit` 套件透過 `[AvaloniaFact]` 屬性自動解決這個問題。**任何時候都不應用 `[Fact]` 取代 `[AvaloniaFact]` 測試 UI 控制項**，否則會出現靜默失敗或 cross-thread 例外。

---

## 1. 專案設定（每個測試專案只做一次）

### 1.1 安裝 NuGet 套件

```xml
<PackageReference Include="Avalonia.Headless.XUnit" Version="11.*" />
<PackageReference Include="Avalonia.Themes.Fluent" Version="11.*" />
<!-- 僅在需要 Pixel 視覺測試時加入 -->
<!-- <PackageReference Include="Avalonia.Skia" Version="11.*" /> -->
```

### 1.2 建立 TestApp（必須含 Theme）

```csharp
// TestApp.cs
using Avalonia;
using Avalonia.Headless;
using Avalonia.Themes.Fluent;

public class TestApp : Application
{
    public override void Initialize()
    {
        // ⚠️ 缺少 Theme 會導致 NullReferenceException
        Styles.Add(new FluentTheme());
    }

    // 快速測試模式（不需 Pixel 比對）
    public static AppBuilder BuildAvaloniaApp() =>
        AppBuilder.Configure<TestApp>()
            .UseHeadless(new AvaloniaHeadlessPlatformOptions
            {
                UseHeadlessDrawing = true,      // 跳過 Skia，速度快
                UseCpuDisabledRenderLoop = true  // 手動控制 render tick
            });
}
```

### 1.3 設定 AssemblyInfo.cs（每個專案只定義一次）

```csharp
// AssemblyInfo.cs 或任意 .cs 檔案頂層
using Avalonia.Headless.XUnit;

// ⚠️ 整個測試 Assembly 只能有一個 AvaloniaTestApplication
[assembly: AvaloniaTestApplication(typeof(TestApp))]

// 建議停用並行以避免 Dispatcher 爭用
[assembly: CollectionBehavior(DisableTestParallelization = true)]
```

---

## 2. 測試屬性規則

| 情境 | 正確屬性 | 錯誤屬性 |
|------|----------|----------|
| 測試 Avalonia 控制項 / UI | `[AvaloniaFact]` | ~~`[Fact]`~~ |
| 參數化 UI 測試 | `[AvaloniaTheory]` | ~~`[Theory]`~~ |
| 純 ViewModel / 業務邏輯 | `[Fact]` | 不需要 AvaloniaFact |

---

## 3. 測試範本庫

### 3.1 TextBox 輸入模擬

```csharp
[AvaloniaFact]
public async Task TextBox_鍵入文字後值更新()
{
    var textBox = new TextBox { Width = 200, Height = 24 };
    var window = new Window { Content = textBox };
    window.Show();

    // ⚠️ 必須先 Focus，headless window 不自動 focus
    textBox.Focus();

    // KeyTextInput 適合 TextBox 輸入（與 KeyPress 獨立）
    window.KeyTextInput("Hello Avalonia");
    AvaloniaHeadlessPlatform.ForceRenderTimerTick(); // 刷新 binding

    Assert.Equal("Hello Avalonia", textBox.Text);
    window.Close();
}
```

### 3.2 Button 點擊模擬

```csharp
[AvaloniaFact]
public void Button_點擊後執行_Command()
{
    var executed = false;
    var button = new Button
    {
        Content = "Click",
        Width = 100, Height = 30,
        Command = ReactiveCommand.Create(() => executed = true)
    };
    var window = new Window { Content = button };
    window.Show();

    // 使用 Bounds.Center 取得按鈕中心點
    var center = button.Bounds.Center;
    window.MouseDown(center, MouseButton.Left);
    window.MouseUp(center, MouseButton.Left);
    AvaloniaHeadlessPlatform.ForceRenderTimerTick();

    Assert.True(executed);
    window.Close();
}
```

### 3.3 鍵盤快捷鍵模擬

```csharp
[AvaloniaFact]
public void TextBox_Ctrl_A_選取全部文字()
{
    var textBox = new TextBox { Text = "Hello World" };
    var window = new Window { Content = textBox };
    window.Show();
    textBox.Focus();

    // 使用 QWERTY 物理鍵 + 修飾鍵
    window.KeyPressQwerty(PhysicalKey.A, RawInputModifiers.Control);
    window.KeyReleaseQwerty(PhysicalKey.A, RawInputModifiers.None);

    Assert.Equal("Hello World", textBox.SelectedText);
    window.Close();
}
```

### 3.4 拖放模擬

```csharp
[AvaloniaFact]
public void DropTarget_接收拖放資料()
{
    var received = string.Empty;
    // （假設 dropTarget 已設置 DragDrop.Drop handler）
    var window = new Window { Content = dropTarget };
    window.Show();

    var data = new DataObject();
    data.Set(DataFormats.Text, "dragged payload");

    window.DragDrop(new Point(10, 20), RawDragEventType.DragEnter, data, DragDropEffects.Copy);
    window.DragDrop(new Point(10, 20), RawDragEventType.Drop, data, DragDropEffects.Copy);
    AvaloniaHeadlessPlatform.ForceRenderTimerTick();

    Assert.Equal("dragged payload", received);
    window.Close();
}
```

### 3.5 非同步操作測試

```csharp
[AvaloniaFact]
public async Task 非同步載入後_Label_顯示結果()
{
    var vm = new MyViewModel();
    var label = new TextBlock { [!TextBlock.TextProperty] = new Binding("Status") };
    var window = new Window { DataContext = vm, Content = label };
    window.Show();

    await vm.LoadDataAsync();
    // 等待 UI 更新
    await Dispatcher.UIThread.InvokeAsync(() => { });
    AvaloniaHeadlessPlatform.ForceRenderTimerTick();

    Assert.Equal("載入完成", label.Text);
    window.Close();
}

// 輪詢等待工具方法
async Task WaitForConditionAsync(Func<bool> condition, TimeSpan? timeout = null)
{
    var deadline = DateTime.UtcNow + (timeout ?? TimeSpan.FromSeconds(5));
    while (!condition())
    {
        if (DateTime.UtcNow > deadline)
            throw new TimeoutException("條件未在超時內滿足");
        AvaloniaHeadlessPlatform.ForceRenderTimerTick();
        await Task.Delay(10);
    }
}
```

### 3.6 ViewModel 純 C# 測試（不需 Headless）

```csharp
// ViewModel 測試不需要 [AvaloniaFact]，用普通 [Fact] 即可
[Fact]
public async Task ViewModel_IncrementCommand_增加計數()
{
    var vm = new CounterViewModel();
    Assert.Equal(0, vm.Count);

    await vm.IncrementCommand.Execute();

    Assert.Equal(1, vm.Count);
}
```

---

## 4. 視覺迴歸測試（Pixel 比對）

需要時參考 `references/visual-regression.md`。

啟用 Skia 渲染需修改 `BuildAvaloniaApp()`：
- `UseHeadlessDrawing = false`
- `.UseSkia()` 加入 pipeline
- 使用 `window.CaptureRenderedFrame()` 取得 `WriteableBitmap`

---

## 5. 常見錯誤與修正

| 症狀 | 原因 | 修正 |
|------|------|------|
| `InvalidOperationException: Call from invalid thread` | 用 `[Fact]` 而非 `[AvaloniaFact]` | 改用 `[AvaloniaFact]` |
| 輸入後 `TextBox.Text` 仍為 null | 缺少 `textBox.Focus()` | 加入 `textBox.Focus()` |
| Binding 未更新就斷言 | 未呼叫 `ForceRenderTimerTick()` | 輸入後加 `ForceRenderTimerTick()` |
| `NullReferenceException` on styles | TestApp 缺少 Theme | 在 `Initialize()` 加入 `FluentTheme` |
| 多個 test 互相干擾 | 並行執行爭用 Dispatcher | 加入 `DisableTestParallelization = true` |
| Build 失敗: 重複 `AvaloniaTestApplication` | Assembly 多處定義 | 全專案只保留一個 |

---

## 6. CI 設定（GitHub Actions）

```yaml
- name: 執行 Avalonia Headless 測試
  run: dotnet test ./tests/MyApp.Tests --logger "trx;LogFileName=results.trx" --blame-hang-timeout 5m
  # Linux CI 不需要安裝 Xvfb 或其他顯示伺服器
```

詳細 CI 設定請參考 `references/ci-setup.md`。

---

## 7. 生成測試的工作流程

當使用者描述要測試的場景時：

1. **判斷測試類型**：是 UI 控制項測試？還是純 ViewModel 邏輯測試？
2. **選擇屬性**：UI → `[AvaloniaFact]`，純邏輯 → `[Fact]`
3. **生成完整可編譯程式碼**，包含：
   - using 指令
   - 控制項初始化與 `window.Show()`
   - 正確的輸入模擬（Focus → Input → ForceRenderTimerTick）
   - Assert
   - `window.Close()`
4. **若是新專案**，同時提供 `TestApp.cs` + `AssemblyInfo.cs` 設定範本
5. **提醒陷阱**：依據測試類型主動提示相關常見錯誤

---

## 參考文件

- `references/visual-regression.md` — 視覺迴歸測試詳細指南
- `references/ci-setup.md` — CI 環境整合詳細設定
