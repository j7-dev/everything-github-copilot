# 視覺迴歸測試指南

## Skia 渲染設定

```csharp
public static AppBuilder BuildAvaloniaApp() =>
    AppBuilder.Configure<TestApp>()
        .UseSkia()
        .UseHeadless(new AvaloniaHeadlessPlatformOptions
        {
            UseHeadlessDrawing = false,  // 必須 false 才能使用 Skia
            UseSkia = true,
            PreferDispatcherScheduling = true
        });
```

## 捕獲幀

```csharp
[AvaloniaFact]
public void Border_視覺外觀符合預期()
{
    var border = new Border
    {
        Width = 200, Height = 100,
        Background = Brushes.CornflowerBlue
    };
    var window = new Window { Content = border };
    window.Show();

    // CaptureRenderedFrame 自動刷新 render tick
    using var frame = window.CaptureRenderedFrame();
    Assert.NotNull(frame);
    Assert.Equal(200, frame.Size.Width);
    Assert.Equal(100, frame.Size.Height);

    // 可存至磁碟供 CI artifacts 使用
    // frame.Save("baseline.png");
    window.Close();
}
```

## 像素比對工具

```csharp
public static (int failures, double percentage) CompareFrames(
    WriteableBitmap expected, WriteableBitmap actual, byte tolerance = 2)
{
    using var left = expected.Lock();
    using var right = actual.Lock();

    if (left.Size != right.Size)
        throw new InvalidOperationException($"尺寸不符: {left.Size} vs {right.Size}");

    var failCount = 0;
    unsafe
    {
        for (var y = 0; y < left.Size.Height; y++)
        {
            var pL = (byte*)left.Address + y * left.RowBytes;
            var pR = (byte*)right.Address + y * right.RowBytes;
            for (var x = 0; x < left.Size.Width; x++)
            {
                var idx = x * 4;
                var delta = Math.Max(
                    Math.Abs(pL[idx] - pR[idx]),
                    Math.Max(Math.Abs(pL[idx+1] - pR[idx+1]),
                             Math.Abs(pL[idx+2] - pR[idx+2])));
                if (delta > tolerance) failCount++;
            }
        }
    }

    var total = left.Size.Width * left.Size.Height;
    return (failCount, (double)failCount / total * 100);
}
```

## 使用 RenderTargetBitmap（不需完整 Window）

```csharp
var root = new Border { Width = 200, Height = 120, Background = Brushes.Red };
await Dispatcher.UIThread.InvokeAsync(() =>
    root.Measure(new Size(double.PositiveInfinity, double.PositiveInfinity)));
root.Arrange(new Rect(root.DesiredSize));

using var rtb = new RenderTargetBitmap(new PixelSize(200, 120));
rtb.Render(root);
```

## 基準圖片管理

- 存放於 `tests/BaselineImages/` 目錄
- 命名格式：`{ControlName}_{Theme}_{Resolution}.png`
- 透過 `WriteableBitmap.Decode(stream)` 載入比較
- CI 失敗時上傳 diff mask 為 artifact
