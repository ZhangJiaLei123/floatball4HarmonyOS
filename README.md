
## 🏆 简介与推荐 floatball4HarmonyOS

原生鸿蒙实现的悬浮球，简单好用，像使用一个ImageView一样去使用他

## 🌞下载与安装

`ohpm i org.blxt.floatball`

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://ohpm.openharmony.cn/#/cn/help/downloadandinstall)


### 🌞属性详解

| 参数                             | 必须参数     | 介绍 | 默认值  |
|:-------------------------------|:---------|:----|:-----|
| image: Resource                | √        | 图片资源  | --   |
| radius: number                 | ×        | 悬浮按钮半径  | 25   |                                    
| opacityHide: number            | ×        | 半隐藏后的透明度 | 1.0  |                                   
| opacityDefault: number         | ×        | 默认透明度  | 1.0  |                                     
| marginSart   : number          | ×        | 从隐藏恢复到显示状态的默认边距       | 25   |                      
| aotoHide ：boolean              | ×        | 开启自动隐藏  | true |                                    
| aotoHideTime: number           | ×        | 自动隐藏的超时时间   | 3000 |                                
| aotoEdging : boolean           | ×        | 自动贴边   | true |                                     
| enableOutEdging: boolean       | ×        | 拖拽时允许超过边界   | true |                                
| enableDragWhenHidden: boolean  | ×        | 允许隐藏时直接拖动，如果false，则需要先点击一下，从隐藏状态显示后，才能继续拖动  | true |
| aotoEdgingTime: number         | ×        | 自动贴边的超时时间  | 3000 |                
| onClickEvent?: () => boolean;  | ×        | 点击事件传递, 如果返回false，则阻止后续事件   | --   |
| onEdgingEvent?: () => boolean; | ×        | 贴边事件传递, 如果返回false，则阻止后续事件  | --   | 
| onHideEvent?: () => boolean;   | ×        | 半隐藏事件传递, 如果返回false，则阻止后续事件  | --   |
| onShowEvent?: () => boolean;   | ×        | 显示事件传递, 如果返回false，则阻止后续事件  | --   |

### 演示
![演示](./演示.gif)

## 使用

### 📚 代码使用
这里是快捷使用，完整demo请见 开源仓库

[ gitee地址： https://gitee.com/zhangjialei2/floatball4-harmony-os](https://gitee.com/zhangjialei2/floatball4-harmony-os)  
[ github地址： https://gitee.com/zhangjialei2/floatball4-harmony-os](https://github.com/ZhangJiaLei123/floatball4HarmonyOS)


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

## 🌏仓库地址
[ gitee地址： https://gitee.com/zhangjialei2/floatball4-harmony-os](https://gitee.com/zhangjialei2/floatball4-harmony-os)  
[ github地址： https://gitee.com/zhangjialei2/floatball4-harmony-os](https://github.com/ZhangJiaLei123/floatball4HarmonyOS)

## 🍎沟通与交流🙏
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/zhangjialei2/floatball4-harmony-os)  给我

博客地址：[https://blog.csdn.net/m0_37909265/article/details/143952854](https://blog.csdn.net/m0_37909265/article/details/143952854)

## 🌏开源协议
本项目基于 [MulanPSL2](http://license.coscl.org.cn/MulanPSL2) ，在拷贝和借鉴代码时，请大家务必注明出处。

## 🌞参考资源
* https://blog.csdn.net/sd1sd2/article/details/139812386 原文实现了拖动，没有自动隐藏贴边等功能，我做了一下封装，方便使用，更多学习，请参考原作者