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

import owlkettle, owlkettle/[dataentries, adw, autoform]
import std/[options, sequtils]

viewable App:
  climbRate: float = 0.0
  digits: uint = 0
  numeric: bool = false
  min: float = 0.0
  max: float = 100.0
  snapToTicks: bool = false
  updatePolicy: SpinButtonUpdatePolicy = SpinButtonUpdateAlways
  value: float = 0.0
  wrap: bool = false
  
method view(app: AppState): Widget =
  result = gui:
    WindowSurface:
      defaultSize = (800, 600)
      Box(orient = OrientX):
        insert app.toAutoForm()

        Separator() {.expand: false.}

        Box(orient = OrientY):
          HeaderBar {.expand: false.}:
            WindowTitle {.addTitle.}:
              title = "SpinRow Example"
              
          SpinRow():
            climbRate = app.climbRate
            digits = app.digits
            numeric = app.numeric
            snapToTicks = app.snapToTicks
            updatePolicy = app.updatePolicy
            value = app.value
            wrap = app.wrap
            
            proc input(newValue: float) =
              echo "New Value was input: ", newValue
              app.value = newValue
              
adw.brew(gui(App()))
