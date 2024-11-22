import { FloatBall } from 'org.blxt.floatball';
import { promptAction } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct Index {
  controller: WebviewController = new webview.WebviewController();

  build() {
    Stack() {
      // 一个webview，充当用户业务视图
      Web({ src: "www.baidu.com", controller: this.controller })
        .domStorageAccess(true)
        .onlineImageAccess(true)
        .imageAccess(true)
        .zoomAccess(false)                             // 禁止缩放
        .javaScriptAccess(true)                        // 启用js交互
        .backgroundColor(Color.White)                  // 背景
        .width('100%')

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
        // .touchable(false)                         // 这个过期了，.hitTestBehavior(HitTestMode.None)代替
        .hitTestBehavior(HitTestMode.None)           // 重要用于点击事件穿透，不然无法点击Web内容
        .width("100%")
        .height("100%")
    }
    .height('100%')
    .width('100%')
  }
}
