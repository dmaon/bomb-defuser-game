import "graphics" for Canvas
import "dome" for Window
import "input" for Keyboard

import "nokia" for Display, Palette, Font, Sound, FPS, Keymap

import "random" for Random


class Lock {
  static frame {
    if (!__frame) {
      __frame = 0
    }
    return __frame
  }
  static score {
    if (!__score) {
      __score = 0
    }
    return __score
  }
  static maxTime {
    if (!__maxTime) {
      __maxTime = 200
    }
    return __maxTime
  }
  static timer {
    if (!__timer) {
      __timer = maxTime
    }
    return __timer
  }
  static min {
    if (!__min) {
      __min = 0
    }
    return __min
  }
  static max {
    if (!__max) {
      __max = 6
      if (__max < 3) {
        __max = 3
      }
    }
    return __max
  }
  static nums {
    if (!__nums) {
      __nums = (min..max).toList
    }
    return __nums
  }
  static pos {
    if (!__pos) {
      __pos = 0
    }
    return __pos
  }
  static axis_y {
    if (!__axis_y) {
      __axis_y = 27
    }
    return __axis_y
  }
  static axis_x {
    if (!__axis_x) {
      __axis_x = 32
    }
    return __axis_x
  }
  static correct {
    if (!__correct) {
      __correct = 0
    }
    return __correct
  }
  static nearCorrect {
    if (!__nearCorrect) {
      __nearCorrect = 0
    }
    return __nearCorrect
  }
  static status {
    if (!__status) {
      __status = "playing" // win, game over, playing
    }
    return __status
  }
  static key_flag {
    if (!__key_flag) {
      __key_flag = false
    }
    return __key_flag
  }
  static space {
    if (!__space) {
      __space = 5
    }
    return __space
  }
  static frame_rate {
    if (!__frame_rate) {
      __frame_rate = 64
    }
    return __frame_rate
  }
  static levels{
    if (!__levels) {
      __levels = ["F","E","D","C","B","A","S"]
    }
    return __levels
  }
  static currentLevel {
    if (!__currentLevel) {
      __currentLevel = 0
    }
    return __currentLevel
  }
  static secret {
    if (!__secret) {
      __secret = []
      __secret.add(getRandom())
      __secret.add(getRandom())
      __secret.add(getRandom())
      __secret.add(getRandom())
    }
    return __secret
  }
  static num_list {
    if (!__num_list) {
      __num_list = [0, 0, 0, 0]
    }
    return __num_list
  }

  static getRandom() {
    var random = Random.new()
    random.shuffle(nums)
    var ret = nums[0]
    nums.removeAt(0)
    return ret
  }

  static make() {
    // print score
    System.print("Your score is : %(score)")

    // reset everything
    __status = "playing"
    __num_list = [0, 0, 0, 0]
    __nums = (min..max).toList
    __secret = []
    __secret.add(getRandom())
    __secret.add(getRandom())
    __secret.add(getRandom())
    __secret.add(getRandom())
    __currentLevel = currentLevel + 1
    if (currentLevel >= levels.count) {
      __currentLevel = levels.count - 1
    }
    __key_flag = false
    __correct = 0
    __nearCorrect = 0
    __timer = (maxTime - (currentLevel * 20)) 
    System.print("__timer : %(__timer)")
    __score = score + 100
  }

  static draw () {

    if (status == "playing") {
      makeBombShape()

      // draw lock
      var i = axis_x
      var position
      Font.lightmode()
      for (item in num_list) {
        Font.gizmo.print(item.toString, i, axis_y)
        i = i + space
      }

      // current number
      pointerCurrent(axis_x + (pos*space))
      
      // change lock
      if (Keyboard["down"].justPressed) { 
        changValueOfLock(pos, num_list[pos]-1)
      }
      if (Keyboard["up"].justPressed) { 
        changValueOfLock(pos, num_list[pos]+1)
      }
      if (Keyboard["right"].justPressed) { 
        changePosPointer(pos+1)
      }
      if (Keyboard["left"].justPressed) { 
        changePosPointer(pos-1)
      }
      if (Keyboard["return"].justPressed) { 
        __correct = 0
        __nearCorrect = 0
        var i = 0
        for (item in num_list) {
          if (item == secret[i]) {
            __correct = correct + 1 
          } else {
            if (checkExistInList(item, secret, i)) {
              __nearCorrect = nearCorrect + 1
            }
          }
          i = i + 1
        }
        if (correct == secret.count) {
          gameWin()
        } else {
          __timer = timer - 10 // -10 sec
        }
        System.print(secret)
        // System.print("correct: " + correct.toString)
        // System.print("nearCorrect: " + nearCorrect.toString)
      }

      // draw board
      boardInfo(correct, nearCorrect)

      // show status of answers, __correct and __nearCorrect
      lockStatus()

      // draw timer
      setTimer()
    }
    if (status == "game over") {
      gameOver()
    }
    

  }

  static boardInfo(correct, near_correct) {
    Font.gizmo.print(levels[currentLevel], 1, 2)
  }

  static gameWin() {
    Sound.play("soundtest")
    __status = "win"
    Canvas.cls(Palette.black)
    make()
  }

  static turnOffOne() {
    for (i in 25..28) {
      Canvas.rectfill(29, i, 1, 1, Palette.black)
    }
  }
  static turnOffTwo() {
    turnOffOne()
    for (i in 30..33) {
      Canvas.rectfill(29, i, 1, 1, Palette.black)
    }
  }
  static turnOffThree() {
    turnOffTwo()
    for (i in 25..28) {
      Canvas.rectfill(54, i, 1, 1, Palette.black)
    }
  }
  static turnOffFour() {
    turnOffThree()
    for (i in 30..33) {
      Canvas.rectfill(54, i, 1, 1, Palette.black)
    }
  }

  static blinkOne() {
    if (frame % 5 == 0) {
      for (i in 30..33) {
        Canvas.rectfill(54, i, 1, 1, Palette.black)
      }
    }
  }
  static blinkTwo() {
    if (frame % 5 == 0) {
      blinkOne()
      for (i in 25..28) {
        Canvas.rectfill(54, i, 1, 1, Palette.black)
      }
    }
  }
  static blinkThree() {
    if (frame % 5 == 0) {
      blinkTwo()
      for (i in 30..33) {
        Canvas.rectfill(29, i, 1, 1, Palette.black)
      }
    }
  }
  static blinkFour() {
    if (frame % 5 == 0) {
      blinkThree()
      for (i in 25..28) {
        Canvas.rectfill(29, i, 1, 1, Palette.black)
      }
    }
  }

  static lockStatus() {
    while (1) {

      if (correct==0 && nearCorrect==0) {
        break
      }

      if (correct==1) {
        turnOffOne()
      }   
      if (correct==2) {
        turnOffTwo()
      }     
      if (correct==3) {
        turnOffThree()
      }     
      if (correct==4) {
        turnOffFour()
      }     
         
      if (nearCorrect==1) {
        blinkOne()
      }   
      if (nearCorrect==2) {
        blinkTwo()
      }     
      if (nearCorrect==3) {
        blinkThree()
      }     
      if (nearCorrect==4) {
        blinkFour()
      }        

      break
    }
  }

  static gameOver() {
    if (!key_flag) {
      Sound.play("negative1")
    }
    __status = "game over"
    Canvas.cls(Palette.black)
    Canvas.print("Game over", 4, 18, Palette.white)
    __key_flag = true
  }

  static checkExistInList(value, list, pos) {
    var flag = false
    for (i in pos..(list.count-1)) {
      if (value == list[i]) {
        flag = true
        break
      }
    } 
    return flag
  }

  static changValueOfLock(index, value) {
    num_list[index] = value
    if (value <= 0) {
      num_list[index] = 0
    }
    if (value >= 9) {
      num_list[index] = 9
    }
  }

  static changePosPointer(value) {
    var end = num_list.count - 1
    if (value <= end && value >= 0 ) {
      __pos = value
    }
    if (value <= 0) {
      __pos = 0
    }
    if (value >= end) {
      __pos = end
    }
  }
  
  static setTimer() {
    var minute = (timer/60).floor
    var second = (timer%60).floor
    
    if (minute.toString.count == 1) {
      minute = "0" + minute.toString
    }
    if (second.toString.count == 1) {
      second = "0" + second.toString
    }

    Font.gizmo.print(minute.toString + ":" + second.toString, 33, 12)
    __frame = frame + 1

    if (frame % frame_rate == 0) {
    __timer = timer - 1
      Sound.play("blip11")
    }

    if (timer<=0) {
      __timer = 0
      __status = "game over"
      gameOver()
    }
  }

  static pointerCurrent(position) {
    for (i in 1..5) {
      Canvas.rectfill(i+(position-1), axis_y+6, 1, 1, Palette.white)
      Canvas.rectfill(i+(position-1), axis_y-2, 1, 1, Palette.white)
    }
  }

  static makeBombShape() {
    // horizontal
    for (i in 14..69) {
      Canvas.rectfill(i, 17, 1, 1, Palette.white)
      Canvas.rectfill(i, 40, 1, 1, Palette.white)
    }
    for (i in 14..17) {
      Canvas.rectfill(i, 22, 1, 1, Palette.white)
      Canvas.rectfill(i, 30, 1, 1, Palette.white)
    }
    for (i in 66..70) {
      Canvas.rectfill(i, 22, 1, 1, Palette.white)
      Canvas.rectfill(i, 30, 1, 1, Palette.white)
    }
    
    // vertical
    for (i in 18..39) {
      Canvas.rectfill(13, i, 1, 1, Palette.white)
      Canvas.rectfill(70, i, 1, 1, Palette.white)
      Canvas.rectfill(17, i, 1, 1, Palette.white)
      Canvas.rectfill(66, i, 1, 1, Palette.white)
    }

    // center
      // horizontal
    for (i in 28..54) {
      Canvas.rectfill(i, 24, 1, 1, Palette.white)
      Canvas.rectfill(i, 34, 1, 1, Palette.white)
    }
    for (i in 18..27) {
      Canvas.rectfill(i, 26, 1, 1, Palette.white)
      Canvas.rectfill(i, 32, 1, 1, Palette.white)
    }
    for (i in 56..65) {
      Canvas.rectfill(i, 26, 1, 1, Palette.white)
      Canvas.rectfill(i, 32, 1, 1, Palette.white)
    }
    
      // vertical
    for (i in 24..34) {
      Canvas.rectfill(53, i, 1, 1, Palette.white)
      Canvas.rectfill(30, i, 1, 1, Palette.white)
      Canvas.rectfill(28, i, 1, 1, Palette.white)
      Canvas.rectfill(55, i, 1, 1, Palette.white)
    }

    // defuse
    for (i in 25..28) {
      Canvas.rectfill(29, i, 1, 1, Palette.white)
    }
    for (i in 30..33) {
      Canvas.rectfill(29, i, 1, 1, Palette.white)
    }
    for (i in 25..28) {
      Canvas.rectfill(54, i, 1, 1, Palette.white)
    }
    for (i in 30..33) {
      Canvas.rectfill(54, i, 1, 1, Palette.white)
    }

    // cable 1
    Canvas.rectfill(37, 9, 1, 1, Palette.white)
    Canvas.rectfill(37, 8, 1, 1, Palette.white)
    Canvas.rectfill(37, 7, 1, 1, Palette.white)
    Canvas.rectfill(36, 6, 1, 1, Palette.white)
    Canvas.rectfill(36, 6, 1, 1, Palette.white)
    Canvas.rectfill(36, 5, 1, 1, Palette.white)
    Canvas.rectfill(35, 4, 1, 1, Palette.white)
    Canvas.rectfill(35, 3, 1, 1, Palette.white)
    Canvas.rectfill(34, 3, 1, 1, Palette.white)
    Canvas.rectfill(34, 2, 1, 1, Palette.white)
    Canvas.rectfill(34, 2, 1, 1, Palette.white)
    Canvas.rectfill(33, 2, 1, 1, Palette.white)
    Canvas.rectfill(32, 2, 1, 1, Palette.white)
    Canvas.rectfill(31, 2, 1, 1, Palette.white)
    Canvas.rectfill(31, 3, 1, 1, Palette.white)
    Canvas.rectfill(30, 4, 1, 1, Palette.white)
    Canvas.rectfill(29, 5, 1, 1, Palette.white)
    Canvas.rectfill(28, 6, 1, 1, Palette.white)
    Canvas.rectfill(27, 7, 1, 1, Palette.white)
    Canvas.rectfill(27, 8, 1, 1, Palette.white)
    Canvas.rectfill(26, 9, 1, 1, Palette.white)
    Canvas.rectfill(26, 10, 1, 1, Palette.white)
    Canvas.rectfill(25, 11, 1, 1, Palette.white)
    Canvas.rectfill(25, 12, 1, 1, Palette.white)
    Canvas.rectfill(25, 13, 1, 1, Palette.white)
    Canvas.rectfill(24, 14, 1, 1, Palette.white)
    Canvas.rectfill(24, 15, 1, 1, Palette.white)
    Canvas.rectfill(24, 16, 1, 1, Palette.white)

    // cable 2
    Canvas.rectfill(34, 9, 1, 1, Palette.white)
    Canvas.rectfill(34, 8, 1, 1, Palette.white)
    Canvas.rectfill(33, 7, 1, 1, Palette.white)
    Canvas.rectfill(33, 6, 1, 1, Palette.white)
    Canvas.rectfill(32, 6, 1, 1, Palette.white)
    Canvas.rectfill(31, 7, 1, 1, Palette.white)
    Canvas.rectfill(30, 8, 1, 1, Palette.white)
    Canvas.rectfill(29, 9, 1, 1, Palette.white)
    Canvas.rectfill(29, 10, 1, 1, Palette.white)
    Canvas.rectfill(29, 11, 1, 1, Palette.white)
    Canvas.rectfill(28, 12, 1, 1, Palette.white)
    Canvas.rectfill(28, 13, 1, 1, Palette.white)
    Canvas.rectfill(28, 14, 1, 1, Palette.white)
    Canvas.rectfill(27, 15, 1, 1, Palette.white)
    Canvas.rectfill(27, 16, 1, 1, Palette.white)

    // alone
    Canvas.rectfill(27, 25, 1, 1, Palette.white)
    Canvas.rectfill(27, 27, 1, 1, Palette.white)
    Canvas.rectfill(27, 31, 1, 1, Palette.white)
    Canvas.rectfill(27, 33, 1, 1, Palette.white)
    
    Canvas.rectfill(56, 25, 1, 1, Palette.white)
    Canvas.rectfill(56, 27, 1, 1, Palette.white)
    Canvas.rectfill(56, 31, 1, 1, Palette.white)
    Canvas.rectfill(56, 33, 1, 1, Palette.white)

    Canvas.rectfill(29, 29, 1, 1, Palette.white)
    Canvas.rectfill(54, 29, 1, 1, Palette.white)

    // timer
    for (i in 32..59) {
      Canvas.rectfill(i, 10, 1, 1, Palette.white)
    }
    for (i in 11..16) {
      Canvas.rectfill(31, i, 1, 1, Palette.white)
      Canvas.rectfill(60, i, 1, 1, Palette.white)
    }
  }
  
}


class Game {

  static init() {
    Display.init()
    Window.title = "Hello Nokia"
    Font.darkmode()
  }

  static update() {
    if (FPS.canUpdate()) {
      nokiaUpdate()
    }
  }

  static nokiaUpdate() {
    // Lock.draw()
  }

  static draw(dt) {
    Canvas.cls(Palette.black)
    Lock.draw()
    

    
  }
}
