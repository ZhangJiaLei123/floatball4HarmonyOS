import { window } from '@kit.ArkUI'

const TAG: string = '[FloatBall]';


/**
 * 悬浮球
 */
@Entry
@Component
export struct FloatBall {
  @State statusHeight: number = 0 // 状态栏高度
  @State bottomAvoidAreaHeight: number = 0 // 手机底部规避区域高度
  @State curLeft: number = 0 // 当前悬浮按钮距离窗口左边距离
  @State curTop: number = 0 // 当前悬浮按钮距离窗口顶部距离
  private startLeft: number = 0 // 开始移动那一刻悬浮按钮距离窗口左边距离
  private startTop: number = 0 // 开始移动那一刻悬浮按钮距离窗口顶部距离
  private startX: number = 0 // 开始移动触摸点x坐标，相对窗口左上角
  private startY: number = 0 // 开始移动触摸点y坐标，相对窗口左上角
  private winWidth: number = 0 // 窗口宽度
  private winHeight: number = 0 // 窗口高度
  private isTouc = false // 是否触摸中
  private time = 0 // 隐藏定时器
  image: Resource = null! // 图片资源
  radius: number = 25 // 悬浮按钮半径
  marginSart = 25 // 从隐藏恢复到显示状态的默认边距
  aotoHide = true // 开启自动隐藏
  aotoHideTime = 3000 // 自动隐藏的超时时间
  aotoEdging = true // 自动贴边
  aotoEdgingTime = 3000 // 自动贴边的超时时间
  onMyClick?: () => void; // 点击事件传递

  aboutToAppear() {
    this.getWindowInfo()
  }

  //获取窗口尺寸信息
  getWindowInfo() {
    window.getLastWindow(getContext(this), (err, windowClass) => {
      if (!err.code) { //状态栏高度
        this.statusHeight = px2vp(windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height)
        //获取手机底部规避区域高度
        this.bottomAvoidAreaHeight =
          px2vp(windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
            .bottomRect
            .height) //获取窗口宽高
        let windowProperties = windowClass.getWindowProperties()
        this.winWidth = px2vp(windowProperties.windowRect.width)
        this.winHeight = px2vp(windowProperties.windowRect.height)
        //设置初始位置位于屏幕右下角，演示设置可根据实际调整
        this.curLeft = 10
        this.curTop = this.winHeight * 0.75

        // 开启自动用隐藏
        if (this.aotoHide) {
          this.onHide()
        }
      }
    })
  }

  build() {
    //悬浮按钮
    Row() {
      Image(this.image).width(this.radius * 2)
    }
    .width(this.radius * 2)
    .height(this.radius * 2)
    .justifyContent(FlexAlign.Center)
    .borderRadius(this.radius)
    .backgroundColor('#E8E8E8')
    .position({ x: this.curLeft, y: this.curTop })
    .onTouch((event: TouchEvent) => { //手指按下记录初始触摸点坐标、悬浮按钮位置
      if (event.type === TouchType.Down) {
        this.isTouc = true
        this.startX = event.touches[0].windowX
        this.startY = event.touches[0].windowY
        this.startLeft = this.curLeft
        this.startTop = this.curTop
        console.log('TouchEvent: 按下');
      } //手指拖动
      else if (event.type === TouchType.Up) {
        this.isTouc = false
        console.log('TouchEvent: 松开');
        // 松开后隐藏
        if (this.aotoHide) {
          this.onHide()
        }
      } //手指拖动
      else if (event.type === TouchType.Move) {
        this.isTouc = true
        let touch = event.touches[0] //计算悬浮球与左边距离（x坐标）， 当前悬浮球距离左边=开始位置(x轴)+（当前触摸点x坐标-开始移动触摸点x坐标）
        let curLeft = this.startLeft + (touch.windowX - this.startX) //限制悬浮球不能移除屏幕左边
        curLeft = Math.max(0, curLeft) // 限制悬浮球不能移除屏幕右边
        this.curLeft = Math.min(this.winWidth - 2 * this.radius,
          curLeft) //计算悬浮球与顶部距离（y坐标）， 当前悬浮球距离顶部=开始位置(y轴)+（当前触摸点y坐标-开始移动触摸点y坐标）
        let curTop = this.startTop + (touch.windowY - this.startY) //限制悬浮球不能移除屏幕上边
        curTop = Math.max(0, curTop) //限制悬浮球不能移除屏幕下边
        this.curTop =
          Math.min(this.winHeight - 2 * this.radius - this.bottomAvoidAreaHeight - this.statusHeight, curTop)
        console.log('TouchEvent: 移动');
      }
    })
    .onClick(() => {
      if (!this.isShow()) {
        this.onMyShow()
        return
      }
      if (this.onMyClick !== undefined) {
        this.onMyClick();
        if (this.aotoHide) {
          // 点击完，就继续去隐藏
          this.onHide();
        }
      }
    })

  }

  public onMyClick2(onMyClick: () => void) {
    this.onMyClick = onMyClick
  }

  /**
   * 隐藏
   */
  onHide() {

    // 如果已经是隐藏，就退出
    if (!this.isShow()) {
      return
    }

    // 如果开启了自动贴边，就先判断是否贴边
    if (this.aotoEdging && !this.ifEdging()) {
      // 先执行贴边
      console.log(TAG, "开启了自动贴边, 当前未贴边")
      this.onEdging()
      return
    }

    // 先取消上一个定时器，在搞新的
    if (this.time != 0) {
      console.log(TAG, "清除上次未执行的目标")
      clearTimeout(this.time);
    }
    console.log(TAG, "创建目标: 隐藏")
    this.time = setTimeout(() => {
      console.log(TAG, "进入执行目标: 隐藏")
      this.onMyHideDo()
    }, this.aotoHideTime)
  }

  /**
   * 贴边
   */
  onEdging() {
    if (this.time != 0) {
      console.log(TAG, "清除上次未执行的目标")
      clearTimeout(this.time)
    }
    console.log(TAG, "创建目标: 贴边")
    this.time = setTimeout(() => {
      console.log(TAG, "进入执行目标: 贴边")
      this.onEdgingDo()
    }, this.aotoEdgingTime)
  }

  /**
   * 执行贴边
   */
  onEdgingDo() {
    if (this.isTouc) {
      // 如果还在触摸中，就往后延时执行
      console.log(TAG, "推后执行目标:在触摸中 贴边")
      this.onEdging()
    } else {
      // 隐藏动画
      console.log(TAG, "执行目标:贴边")
      animateTo({
        duration: 1000,
        onFinish: (() => {
          console.log(TAG, "贴边动画结束")
          // 贴边动画结束 开始准备隐藏
          if (this.aotoHide) {
            clearTimeout(this.time) // 记得清除定时器资源
            this.time = 0
            this.onHide()
          }
        })
      }, () => {
        if (this.curLeft > this.winWidth / 2) {
          this.curLeft = this.winWidth - this.radius * 2
        } else {
          this.curLeft = 0
        }
      })
      // 取消定时器
      if (this.time != 0) {
        clearTimeout(this.time);
        this.time = 0
      }
    }
  }

  /**
   * 执行隐藏动作
   */
  onMyHideDo() {
    if (this.isTouc) {
      // 如果还在触摸中，就往后延时执行
      console.log(TAG, "推后执行目标:在触摸中 隐藏")
      this.onHide()
    } else {
      // 隐藏动画
      console.log(TAG, "执行目标:隐藏")
      animateTo({
        duration: 1000,
        onFinish: (() => {
          console.log(TAG, "隐藏动画结束")
          // 记得清除定时器资源
          clearTimeout(this.time)
          this.time = 0
        })
      }, () => {
        if (this.curLeft > this.winWidth / 2) {
          this.curLeft = this.winWidth - this.radius
        } else {
          this.curLeft = 0 - this.radius
        }
      })
      // 取消定时器
      if (this.time != 0) {
        clearTimeout(this.time);
        this.time = 0
      }
    }
  }

  /**
   * 显示
   */
  onMyShow() {
    // 显示动画
    console.log(TAG, "执行目标:显示")
    animateTo({
      duration: 500, onFinish: (() => {
        console.log(TAG, "显示动画结束")
        // 记得清除定时器资源
        clearTimeout(this.time)
        this.time = 0
        // 重新加载隐藏
        this.onHide()
      })
    }, () => {
      if (this.curLeft > this.winWidth / 2) {
        this.curLeft = this.winWidth - this.radius * 2 - this.marginSart
      } else {
        this.curLeft = this.marginSart
      }
    })
    // 显示后，就取消定时器
    if (this.time != 0) {
      clearTimeout(this.time);
      this.time = 0
    }
  }

  /**
   * 判断是否是隐藏状态
   * @returns
   */
  isShow() {
    if (this.curLeft < 0) {
      return false
    } else if (this.curLeft >= this.winWidth - this.radius) {
      return false
    }
    return true
  }

  /**
   * 判断是否贴边
   * @returns
   */
  ifEdging() {
    if (this.curLeft == 0) {
      return true
    } else if (this.curLeft == this.winWidth - this.radius * 2) {
      return true
    }
    return false
  }
}
