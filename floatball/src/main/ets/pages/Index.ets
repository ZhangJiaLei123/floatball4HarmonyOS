import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  controller: WebviewController = new webview.WebviewController();

  build() {
    Stack() {

    }
    .height('100%')
    .width('100%')
  }
}