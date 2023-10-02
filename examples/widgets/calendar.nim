# MIT License
# 
# Copyright (c) 2023 Can Joshua Lehmann
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

import std/[times]
import owlkettle, owlkettle/[adw, autoform]

viewable App:
  date: DateTime = now()
  markedDays: seq[int] = @[]
  showDayNames: bool = true
  showHeading: bool = true
  showWeekNumbers: bool = true

method view(app: AppState): Widget =
  let form: Widget = app.toAutoForm()

  result = gui:
    Window:
      defaultSize = (600, 400)
      
      HeaderBar {.addTitlebar.}:
        WindowTitle {.addTitle.}:
          title = "Calendar Example"
          subtitle = $app.date.inZone(local())
        
        Button {.addLeft.}:
          icon = "go-previous"
          style = [ButtonFlat]
          tooltip = "Previous Day"
          
          proc clicked() =
            app.date -= 1.days
        
        Button {.addLeft.}:
          icon = "go-next"
          style = [ButtonFlat]
          tooltip = "Next Day"
          
          proc clicked() =
            app.date += 1.days
      
      Box(orient = OrientY, spacing = 6, margin = 12):
        Calendar:
          date = app.date
          markedDays = app.markedDays
          showDayNames = app.showDayNames
          showHeading = app.showHeading
          showWeekNumbers = app.showWeekNumbers
          
          proc select(date: DateTime) =
            ## Shortcut for handling all calendar events (daySelected,
            ## nextMonth, prevMonth, nextYear, prevYear)
            app.date = date
      
        Box(orient = OrientY) {.expand: false.}:
          Label(text = "Widget Fields")
          insert form

adw.brew(gui(App()), stylesheets=[
  loadStylesheet("calendar.css")
])
