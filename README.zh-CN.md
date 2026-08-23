# SwiftMarkdownKit

专为流式 AI 输出打造的 iOS Markdown 渲染器。用一套原生 Swift API，完成 Markdown、代码、公式和完整会话的高质量渲染。

**官方网站：** [https://macdeer.com/swift-markdown-kit](https://macdeer.com/swift-markdown-kit) · **更多产品：** [https://macdeer.com](https://macdeer.com)

[English](README.md)

## 效果展示

<table>
  <tr>
    <td width="33%"><img src="github_images/IMG_6973.PNG" alt="富文本与标题"></td>
    <td width="33%"><img src="github_images/IMG_6974.PNG" alt="列表、任务项与代码"></td>
    <td width="33%"><img src="github_images/IMG_6975.PNG" alt="代码高亮"></td>
  </tr>
  <tr>
    <td align="center">富文本排版</td>
    <td align="center">列表与代码</td>
    <td align="center">语法高亮</td>
  </tr>
  <tr>
    <td><img src="github_images/IMG_6976.PNG" alt="数学公式与表格"></td>
    <td><img src="github_images/IMG_6977.PNG" alt="链接与混合内容"></td>
    <td><img src="github_images/IMG_6978.PNG" alt="嵌套内容"></td>
  </tr>
  <tr>
    <td align="center">公式与表格</td>
    <td align="center">链接与混排</td>
    <td align="center">复杂嵌套</td>
  </tr>
</table>

## 功能

- 完整 Markdown：标题、富文本、嵌套列表、任务项、引用、表格、链接、Emoji，以及可选的原始 HTML。
- 180+ 语言代码高亮，内置复制代码操作。
- KaTeX 行内与块级公式，支持 `\ce{}` 化学式。
- 容忍模型真实输出里那种「不太标准」的 Markdown：价格旁边的 `$`、方括号引用、右花括号还没流完的公式。任何内容都不会变红——KaTeX 解析不了的部分退回作者原本写下的字符。
- 推理折叠：模型的思维链——无论写在正文里的 `<think>` … `</think>`，还是单独的 `reasoning_content` 字段——都会流进正文上方的折叠面板，正文开始时自动收起。
- SwiftUI 与 UIKit 的单文档、整会话渲染组件。
- 深浅色主题、动态字体、自定义主题 token 和内容边距。
- 内置英文与简体中文：SDK 自身的文案跟随读者的系统语言，也可以跟随 App 当前展示的语言。
- 点击交互开箱即用：链接在应用内浏览器打开、图片全屏预览、代码和消息可复制；想自己接管其中某一项，改一行即可。
- 链接、渲染完成、高度变化、错误和自定义语法事件。

## 特色

- **真正为流式渲染优化。** 缓存已经稳定的内容，只更新仍在生成的尾部，长回答也能保持流畅。
- **整段会话共用一个渲染器。** 避免每条消息各建一个渲染器带来的内存和布局开销。
- **开箱即用的 LLM 内容支持。** Markdown、代码、公式、表格和未完成的流式语法统一处理。
- **完全端侧运行。** 渲染资源随 SDK 提供，不依赖渲染服务和网络。
- **接入简单。** SPM 与 XCFramework 都使用同一个 `import SwiftMarkdownKit`。

## 安装与使用

需要 iOS 17 或更高版本。

### Swift Package Manager

在 Xcode 中选择 **File → Add Package Dependencies**，输入：

`https://github.com/cellgit/swift-markdown-kit.git`

也可以写入 `Package.swift`：

```swift
dependencies: [
    .package(url: "https://github.com/cellgit/swift-markdown-kit.git", from: "0.0.7")
]
```

然后把 `SwiftMarkdownKit` product 加入 App target。

### XCFramework

从 [v0.0.7 Release](https://github.com/cellgit/swift-markdown-kit/releases/tag/v0.0.7) 下载 `SwiftMarkdownKit-0.0.7.xcframework.zip`。解压后把 `SwiftMarkdownKit.xcframework` 拖入 Xcode，加入 App target，并选择 **Embed & Sign**。

### SwiftUI 渲染 Markdown

```swift
import SwiftUI
import SwiftMarkdownKit

struct ArticleView: View {
    let markdown: String

    var body: some View {
        MarkdownRenderView(markdown: markdown)
    }
}
```

### 流式渲染 AI 回复

```swift
let controller = MarkdownRenderViewController()
controller.startStreaming()

for try await chunk in response {
    controller.appendChunk(chunk)
}

controller.finishStreaming()
```

SwiftUI 中绑定的 Markdown 字符串持续追加时，`MarkdownRenderView` 会自动走同一套增量渲染路径。

### 渲染完整会话

```swift
struct ConversationView: View {
    @State private var messages: [MarkdownChatMessage] = []

    var body: some View {
        MarkdownChatRenderView(messages: messages)
    }
}
```

### 点击交互

不需要写任何代码。只传 markdown 的渲染器已经会用应用内 `SFSafariViewController` 打开链接、用全屏预览器打开图片、支持复制代码——因为 `interaction` 默认就是 `.automatic`。

想自己接管其中一项，改一行，其余保持不变：

```swift
var options = MarkdownChatRenderOptions()
options.interaction.images = .handledByHost   // 链接仍然由 SDK 处理
```

```swift
case .action(let event):
    if case .imageTapped(let url) = event.action { presentMyOwnViewer(url) }
```

| 策略 | 行为 | 你收到什么 |
|---|---|---|
| `.automatic`（默认） | SDK 在应用内打开 | `didOpenLink` / `didPresentImage`——只是通知 |
| `.handledByHost` | 什么都不做 | `linkTapped` / `imageTapped`——不处理就没有任何反应 |
| `.disabled` | 什么都不做，且去掉可点击的样式 | 什么都不发 |

`options.interaction = .manual` 可以一次把两项都交给宿主。

**无论用哪种策略**，scheme 不在 `allowedLinkSchemes`（默认 `http`、`https`、`mailto`）里的链接都不会被打开，**也不会交给宿主**，而是以 `linkBlocked` 上报。渲染的内容是模型输出，`javascript:` 或深链不该不经检查就转手。需要放行自己的 scheme：

```swift
options.interaction.allowedLinkSchemes.insert("myapp")
```

复制、推理折叠、任务勾选不在策略范围内：它们不需要 App 提供任何信息，SDK 一律自己完成，只有「是否显示」可配（`messageActions`、`interaction.allowsCodeCopy`）。

重试和编辑正相反——SDK 无法重新发起请求、也无法写回你的输入框，所以这两个按钮只有在你显式列出时才渲染，**列出即代表你会处理** `MarkdownChatRenderEvent.messageAction`：

```swift
options.messageActions.assistantActions = [.copy, .retry]
```

### 展示模型的推理过程

写在正文里的推理不需要任何额外处理，照常传给渲染器即可，分离由渲染核心完成：

```swift
controller.appendChunk("<think>先把题目看清楚</think>答案是 42。", to: id)
```

服务商用单独字段下发推理时（DeepSeek、Qwen、GLM 的 `reasoning_content`，OpenRouter 的 `reasoning`），走另一条通道：

```swift
for try await event in response {
    switch event {
    case .reasoning(let text): controller.appendReasoningChunk(text, to: id)
    case .content(let text):   controller.appendChunk(text, to: id)
    }
}
```

两种方式的表现一致：模型思考时折叠面板保持展开，正文一开始就收起。读者自己点开或收起之后，自动收起不再覆盖这个选择。

```swift
var options = MarkdownChatRenderOptions()
options.reasoning = MarkdownChatReasoningConfiguration(
    thinkingLabel: "思考中…",
    completedLabel: "已深度思考",
    durationLabelFormat: "已深度思考（用时 {seconds} 秒）"
)
```

整会话一次性下发时，推理内容放在 `MarkdownChatMessage.reasoning`；单文档渲染器的折叠样式由 `MarkdownRenderOptions.MarkdownConfig.reasoning` 配置。

### 调整流式路径

```swift
var options = MarkdownChatRenderOptions()

// token 级 chunk 在交给渲染器之前的聚合时长。模型每秒产出几十个 token，
// 逐个送出意味着逐次跨进程往返。运行时本身按帧节奏逐字上屏，
// 因此这个参数不改变文字出现的时机，只减少跨进程往返次数。设为 0 则来一个送一个。
options.chunkCoalescingInterval = 1.0 / 30.0   // 默认值
```

### 自定义渲染效果

```swift
let options = MarkdownRenderOptions(
    colorScheme: .auto,
    theme: .github,
    contentPadding: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16),
    baseFontSize: 16
)

MarkdownRenderView(markdown: markdown, options: options)
```

### 多语言

SDK 自身显示的文案——代码块的复制按钮、推理折叠区的标题、消息操作的辅助功能标签——内置英文与简体中文。无需任何开关：只要不传对应的文案参数，每位读者看到的就是自己系统语言对应的文案，找不到时回退英文：

```swift
let options = MarkdownRenderOptions()
```

如果 App 自带语言切换，希望 SDK 跟随 App 而不是跟随系统，指定语言即可：

```swift
MarkdownRenderLocalization.language = .simplifiedChinese
```

请在启动时、构建交给渲染器的 options 之前设置。文案是在 options **被构造时**读取的，之后再改不会影响已经存在的 options。

自己传入的文案始终优先，已经做过翻译的 App 可以继续用自己的措辞：

```swift
MarkdownRenderOptions(copyText: "拷贝")
```

SDK 跟随的是**设备**语言，而不是宿主 App 声明的语言。iOS 默认会把进程内所有 framework 限制在 App 自身声明的语言范围内——如果 App 只是把中文文案写死、并没有提供 `zh-Hans.lproj`，那么在中文设备上 SDK 反而会显示英文。改为按设备语言解析后，无论 App 有没有声明多语言，SDK 都能正确翻译。如果希望 SDK 跟随 App 的语言，指定 ``language`` 即可。

渲染出的 Markdown 是作者的正文，不会被翻译。

正式发布时，把签发的 `.smklicense` 文件加入 **Copy Bundle Resources**。未放入 license 也可以完整评估全部功能，只会显示一个小型未授权角标。
