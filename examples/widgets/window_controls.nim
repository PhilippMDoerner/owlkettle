# MIT License
# 
# Copyright (c) 2022 Can Joshua Lehmann
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import std/[sequtils]
import owlkettle, owlkettle/[dataentries, playground, adw]

viewable App:
  side1: PackType = PackStart
  side2: PackType = PackEnd
  buttons1: seq[WindowControlButton] = @[WindowControlMenu, WindowControlMinimize, WindowControlMaximize]
  buttons2: seq[WindowControlButton] = @[WindowControlClose, WindowControlIcon]
  sensitive: bool = true
  tooltip: string = ""
  sizeRequest: tuple[x, y: int] = (-1, -1)

method view(app: AppState): Widget =
  result = gui:
    Window():
      title = "WindowControls Example"
      defaultSize = (600, 100)
      iconName = "go-home-symbolic" # Used by WindowControlIcon
      
      HeaderBar() {.addTitlebar.}:
        insert(app.toAutoFormMenu(sizeRequest = (400, 400))) {.addRight.}
      
        WindowControls() {.addLeft.}:
          side = app.side1
          buttons = (app.buttons1, app.buttons2)
            
          
        # WindowControls() {.addRight.}:
        #   side = app.side2
        #   buttons = (app.buttons1, app.buttons2)
        
adw.brew(gui(App()))
