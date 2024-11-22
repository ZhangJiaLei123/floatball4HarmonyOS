
## floatball4HarmonyOS
原生鸿蒙实现的悬浮球

### 功能

| 功能                | 支持 |
|:------------------|:---:|
| 自定义图片             |√ |
| 自定义悬浮球尺寸（圆角）      |√ |
| 支持自动贴边（自动左右贴边））   |√ |
| 支持自动半隐藏（先贴边再隐藏）   |√ |
| 支持 隐藏/显示 动画       | √|
| 支持自定义点击响应         |√ |
| 支持下显示、隐藏、贴边事件状态回调 |√ |
| 支持隐藏后透明           |√ |
| 支持隐藏后透明           | √|
| 配置拖拽时是否允许超过边界     | √|
| 配置隐藏时是否直接拖动       |√ |



### 演示
![演示](./演示.gif)


### 使用
由于项目没有推送到官方仓库,目前只能下载项目源码使用

### 导入模块
* A. 直接复制代码食用
  直接复制 'src/main/ets/pages/FloatBall.ets' 到你项目里面后直接 import 即可

* B. 导入model
  从File导入model后，在'entry'模块的 'oh-package.json5' 中做如下修改
``` json5
{
  // ...
  "dependencies": {
    // 这里写导入的模块文件夹名称
    "floatball": "file:../floatball"
  }
}
 
```
改完后要同步一下，会自动生成 'oh-package-lock.json5'

```json5
{
  // ...
  "packages": {
    "floatball@../floatball": {
      "name": "floatball",
      "version": "1.0.0",
      "resolved": "../floatball",
      "registryType": "local",
      "packageType": "InterfaceHar"
    }
  }
}
```
### 代码使用
这里是快捷使用，完整demo请见 entry中的 index.ets
``` arkts

   build() {
    Stack() {
      // 一个webview，充当用户业务视图
      // ... 用户业务代码

      // 悬浮按钮
      FloatBall({
        image: $r('app.media.startIcon'),             // 图片资源
        radius: 25,                                   // 悬浮按钮半径
        marginSart: 25,                               // 从隐藏恢复到显示状态的默认边距
        aotoEdging: true,                             // 开启自动贴边
        aotoHide: true,                               // 开启自动隐藏
        opacityHide: 0.5,                             // 半隐藏后的透明度
        onClickEvent: (): boolean => {                // 点击事件
          promptAction.showToast({ message: '点击了悬浮球' });
          if(this.controller.accessStep(-1)){
            this.controller.backward(); // 返回上一个web页
          }
          return true
        },
        onEdgingEvent: (): boolean => {
          promptAction.showToast({ message: '我贴边了' });
          return true
        },
        onHideEvent: (): boolean => {
          promptAction.showToast({ message: '我隐藏了' });
          return true
        },
        onShowEvent: (): boolean => {
          promptAction.showToast({ message: '我显示了' });
          return true
        }
      })
        // .touchable(false) // 这个过期了，.hitTestBehavior(HitTestMode.None)代替
        .hitTestBehavior(HitTestMode.None) // 重要用于点击事件穿透，不然无法点击Web内容
        .width("100%")
        .height("100%")
    }
    .height('100%')
    .width('100%')
  }
```

## 仓库地址
[ gitee地址： https://gitee.com/zhangjialei2/floatball4-harmony-os](https://gitee.com/zhangjialei2/floatball4-harmony-os)  
[ github地址： https://gitee.com/zhangjialei2/floatball4-harmony-os](https://github.com/ZhangJiaLei123/floatball4HarmonyOS)

## 参考资源
* https://blog.csdn.net/sd1sd2/article/details/139812386 原文实现了拖动，没有自动隐藏贴边等功能，我做了一下封装，方便使用，更多学习，请参考原作者