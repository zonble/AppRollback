# AppRollback

一套可以在裝置上將 App 動態 rollback 回前一版的架構小實驗。

## 故事

去年底（2016）的時候，我聽到一件很神奇的事情、簡直就是黑科技：有人做到
在每次發行 App 的時候，其實App 裡頭同時包含這一版、與前一次發行版本的
兩套 binary，在執行的時候，可以在兩個不同版本的 binary 之間切換。如果
發現目前這個版本的 bug 很多，用戶抱怨連連，甚至可以從 server 下個指令，
要求所有用戶直接 rollback 回前一個版本，省去了還要上一個新版本到 App
Store，通過蘋果審核的麻煩。

基於工程師的好奇，就自己實驗看看怎樣做到這樣的事情。

## 作法

要做到這件事，關鍵在於，App 本身的 Binary 其實只是一個空殼，大概除了
main.m 之外就什麼都沒有了，App 所有的主要功能，都寫在 framework 裡頭，
而所謂切換版本，就是決定要載入哪一個 framework。

在這邊的範例中，我們準備了一個叫做 `AppFramework.xcodeproj` 的 Xcode
專案檔案，在 `AppFramework.xcodeproj` 裡頭有兩個 target，一個叫做
`AppFramework`、另一個叫做 `AppFrameworkAsPreviousVersion`，在寫任何新
功能，建立新的 class 的時候，要把檔案同時加入到這兩個 target 中。
`AppFramework` 這個 target 編譯出來的 framework，代表的是現在版本的功
能，至於 `AppFrameworkAsPreviousVersion` 產生出來的 framework，則是目
前這個版本在未來變成「前一版」的時候使用。

接著，我們設定了一個 git submodule，位在 `PreviousVersion` 目錄下，但
是這個 submodule 跟目前專案的 git repo 的位置是一模一樣的，也就是，這
個專案把自己當做自己的 submodule。接下來，只要指定這個 submodule 的
git 版號，我們就可以決定「這一次要包的版本中的前一版的 binary」，是哪
一個版本。

打開 `AppRollback.xcodeproj`，可以看到，AppRollback 設定了兩個
dependency，一個是目前的 `AppFramework.framework`，另外就是
`PreviousVersion` 目錄下，屬於前一個版本專案的
`AppFrameworkAsPreviousVersion.framework`。在編譯 AppRollback 的時候，
會先編譯這兩個 dependency，並且透過一個 Copy File Build Phase，將這兩
個 framework 放在 App Bundle 裡頭的 `Frameworks` 目錄下。

接下來我們來看一下 main.m 裡頭的實作：

```
NSBundle *bundle = [NSBundle mainBundle];
NSString *frameworkPath = [bundle privateFrameworksPath];
BOOL roolback = YES;
NSString *previousVersionPath = [frameworkPath stringByAppendingPathComponent:@"AppFrameworkAsPreviousVersion.framework"];
NSString *currentVersionPath = [frameworkPath stringByAppendingPathComponent:@"AppFramework.framework"];

if (roolback) {
	[[NSBundle bundleWithPath:previousVersionPath] load];
}
else {
	[[NSBundle bundleWithPath:currentVersionPath] load];
}
```

簡單講，假如 roolback 這個變數是 YES，我們就透過 `NSBundle` 的 `-load`
method 載入前一版 framework，反之，就是載入目前版本的 framework。至於
要怎樣改變 roolback 這個變數，就端看要怎麼設計了，像是可以在前一次執行
的時候，去 server 呼叫某個 API，知道是不是該 rollback，然後存在
NSUserDefaults 之類的地方…。

## 限制

蘋果在 iOS 8 之後才開放 framework，所以這個架構一定只能夠在 iOS 8 之後
使用。
