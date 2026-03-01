# ============================================================
# HTML 復刻差異修復工作流程 (AI-Executable)
# 工具依賴：odiff-bin、Chrome DevTools MCP
# ============================================================

Feature: HTML 復刻視覺差異自動化修復

  # ──────────────────────────────────────────
  # 前置條件
  # ──────────────────────────────────────────
  Background:
    Given Chrome DevTools MCP 已啟動並連線至目標瀏覽器
    And odiff-bin 已安裝（npm install odiff-bin）
    And 專案目錄下存在 target.png（設計稿 / 原始頁面截圖）
    And 複刻頁面可透過 localhost URL 存取
    And 兩張截圖的 viewport 尺寸一致

  # ──────────────────────────────────────────
  # Scenario 1：截圖準備與一致性驗證
  # ──────────────────────────────────────────
  Scenario: 截圖準備與尺寸驗證
    Given 複刻頁面已在瀏覽器中開啟
    When AI 透過 Chrome DevTools MCP 執行 wait_for 等待頁面完全載入
      """
      條件：document.readyState === 'complete'
      且無 pending 的 network requests（等待 500ms idle）
      """
    And AI 透過 Chrome DevTools MCP 執行 take_screenshot 存為 clone.png
    Then 驗證 target.png 與 clone.png 的寬高像素一致
      """
      若尺寸不一致：
        → 報錯並中止，提示使用者統一 viewport 設定
        → 建議 viewport：1440x900
      """

  # ──────────────────────────────────────────
  # Scenario 2：odiff 比對，取得差異行號
  # ──────────────────────────────────────────
  Scenario: 像素比對並提取差異區塊
    Given target.png 與 clone.png 尺寸一致
    When AI 執行 odiff 比對
      """
      輸入：target.png, clone.png
      輸出：diff.png（高亮差異圖）、result.diffLines（差異 y 軸行號陣列）
      參數：captureDiffLines: true
      """
    Then 取得 result.diffPercentage
      """
      if diffPercentage === 0：
        → 回報「無差異，流程結束」，停止執行
      if diffPercentage > 0：
        → 繼續執行 Scenario 3
      """
    And 將 diffLines 進行群組化
      """
      演算法：連續行號聚合為區塊
      輸出欄位：{ yStart, yCenter, yEnd }
      """

  # ──────────────────────────────────────────
  # Scenario 3：透過 Chrome DevTools MCP 查詢差異元素
  # ──────────────────────────────────────────
  Scenario: 自動查詢差異座標對應元素與樣式
    Given 已取得差異座標群組（yCenter 清單）
    When AI 透過 Chrome DevTools MCP execute_script 在複刻頁面執行查詢
      """
      對每個 yCenter：
        1. 先嘗試 x = viewportWidth / 2（水平中心）
        2. 若 elementFromPoint 回傳 null 或 <body>/<html>：
           → 改嘗試 x = viewportWidth * 0.25 及 x = viewportWidth * 0.75
        3. 若三個 x 座標均無有效元素：
           → 記錄 { y: yCenter, error: "no_element_found" }，跳過此區塊
      回傳格式：
        {
          y, selector, boundingRect,
          styles: { fontSize, fontWeight, lineHeight, letterSpacing,
                    color, backgroundColor,
                    marginTop, marginBottom, marginLeft, marginRight,
                    paddingTop, paddingBottom, paddingLeft, paddingRight,
                    width, height, display, flexDirection, gap,
                    transform, opacity }
        }
      """
    And AI 透過 Chrome DevTools MCP navigate_page 切換至目標頁面
    And 對目標頁面執行相同查詢，取得對照數值
    Then 將兩組 computedStyle 對比，只保留數值不同的屬性
      """
      輸出結構化差異報告：
        差異區塊 N：
          yRange: yStart–yEnd
          selector: <css selector>
          屬性差異: [{ property, target, clone }]
      """

  # ──────────────────────────────────────────
  # Scenario 4：AI 精準修復 CSS
  # ──────────────────────────────────────────
  Scenario: 逐一修復差異 selector
    Given 已產出結構化差異報告
    When AI 依照差異報告處理每個差異區塊
      """
      修復規則：
        1. 每次只修復一個 selector
        2. 只修改有差異的屬性，不動其他屬性
        3. 修改前先讀取現有 CSS 片段確認上下文
      """
    Then AI 修改對應 CSS 檔案並儲存
    And 修復完成後回報：
      """
      已修復：
        selector: <selector>
        修改屬性：[{ property, from, to }]
      """

  # ──────────────────────────────────────────
  # Scenario 5：迭代驗證與終止條件
  # ──────────────────────────────────────────
  Scenario: 重新截圖並驗證修復結果
    Given 本輪 CSS 修復已完成
    When AI 透過 Chrome DevTools MCP 重新截圖存為 clone-v{n}.png
    And 執行 odiff 比對 target.png vs clone-v{n}.png
    Then 判斷是否達到終止條件
      """
      終止條件（滿足任一）：
        A. diffPercentage < 10%  → 自動視為成功，停止迭代
        B. 使用者確認接受當前結果 → 停止迭代
        C. 已達第 5 次迭代        → 停止並產出最終差異報告，等待人工決策

      未達終止條件：
        → 回到 Scenario 2 繼續下一輪迭代
      """
    And 輸出最終迭代報告
      """
      {
        totalIterations: N,
        finalDiffPercentage: X%,
        status: "success" | "max_retry_reached",
        remainingDiffs: [ ...未修復的差異區塊 ]
      }
      """

  # ──────────────────────────────────────────
  # Scenario 6：錯誤處理
  # ──────────────────────────────────────────
  Scenario Outline: 錯誤情境處理
    Given 流程執行中發生 <error_type>
    Then AI 執行對應處理策略 <strategy>

    Examples:
      | error_type                    | strategy                                              |
      | 截圖尺寸不一致                  | 中止流程，提示使用者統一 viewport 後重新執行              |
      | odiff 執行失敗                 | 回報錯誤訊息與 stderr，中止流程                          |
      | elementFromPoint 無法找到元素  | 記錄 skip log，繼續處理其他差異區塊                      |
      | CSS 修復後差異增加（回歸）       | 還原本次修改（git checkout 或備份還原），回報並等待人工介入 |
      | 達到 max 5 次迭代仍未收斂       | 停止迭代，輸出最終差異報告，等待使用者決策                 |