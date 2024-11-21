
## floatball4HarmonyOS 
原生鸿蒙实现的悬浮球

### 功能
* 自定义图片
* 自定义悬浮球尺寸（圆角）
* 支持自动贴边（自动左右贴边）
* 支持自动半隐藏（先贴边再隐藏）
* 支持隐藏动画
* 支持自定义点击响应

### 演示  
![演示](./演示.gif)


### 使用  
> 这里是快捷使用，完整demo请见 entry中的 index.ets
``` arkts

   build() {
    Stack() {
      // 一个webview，充当用户业务视图
      // ... 用户业务代码

      // 悬浮按钮
      FloatBall({
        image: $r('app.media.startIcon'),  // 图片资源
        radius: 25,                        // 悬浮按钮半径
        marginSart: 25,                    // 从隐藏恢复到显示状态的默认边距
        aotoEdging: true,                  // 开启自动贴边
        aotoHide: true,                    // 开启自动隐藏
        onMyClick: (): void => {
          promptAction.showToast({ message: '点击了悬浮球' });
          if(this.controller.accessStep(-1)){
            this.controller.backward(); // 返回上一个web页
          }
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
