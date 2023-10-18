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

import owlkettle, owlkettle/[playground, adw]
import std/sequtils

viewable App:
  # PreferencesWindow
  searchEnabled: bool = false
  
  # PreferencesWindow.Toast
  toastTitle: string
  actionName: string
  detailedActionName: string
  actionTarget: string
  buttonLabel: string = "Btn Label"
  priority: ToastPriority = ToastPriorityNormal
  timeout: int = 3
  useMarkup: bool = true ## Enables using markup in title. Only available for Adwaita version 1.4 or higher. Compile for Adwaita version 1.4 or higher with -d:adwMinor=4.
  
  showToast: bool = false

  # Preference Page
  iconName: string = "weather-clear-symbolic"
  pageTitle: string = "Some Title"
  name: string = "Page Name"
  description: string = "An example of a Preferences Page"
  useUnderline: bool = false
  
  likeLevel: string 
  reasonForLikingExample: string
  
  likeOptions: seq[string] = @["A bit", "A lot", "very much", "Fantastic!",  "I love it!"]
  

proc buildToast(state: AppState): AdwToast =
  result = newToast(state.toastTitle)
  if state.actionName != "":
    result.actionName = state.actionName
    
  if state.actionTarget != "":
    result.actionTarget = state.actionTarget

  if state.buttonLabel != "":
    result.buttonLabel = state.buttonLabel

  if state.detailedActionName != "":
    result.detailedActionName = state.detailedActionName

  result.priority = state.priority
  result.timeout = state.timeout
  result.titleMarkup = state.useMarkup

  result.dismissalHandler = proc(toast: AdwToast) = 
    echo "Dismissed: ", toast.title
    state.showToast = false
  # result.clickedHandler = proc() = echo "Click" # Comment in if you compile with -d:adwminor=2 or higher

proc buildPreferencesPage(state: AppState, index: int): Widget =
  let name = state.name & " " & $index
  echo "Name: ", name
  gui:
    PreferencesPage():
      iconName = state.iconName
      title = state.pageTitle
      name = name
      description = state.description
      useUnderline = state.useUnderline
      
      PreferencesGroup:
        title = "First group setting"
        description = "Figuring out how cool this example is"

        ComboRow():
          title = "How much do you like this example?"
          items = state.likeOptions
          
          proc select(selectedIndex: int) =
            state.likeLevel = state.likeOptions[selectedIndex]
      
      PreferencesGroup:
        title = "Second group settings"
        description = "Justifying why this example is so cool"

        EntryRow():
          title = "This example is so cool because:"
          subtitle = "Truly, just show your thoughts"
          text = state.reasonForLikingExample
          
          proc changed(newText: string) =
            state.reasonForLikingExample = newText


method view(app: AppState): Widget =
  let toast: AdwToast = buildToast(app)
  let pages: seq[Widget] = (1..1).mapIt(app.buildPreferencesPage(it))
  
  result = gui:
    Window():
      defaultSize = (800, 600)
      title = "Status Page Example"
      HeaderBar {.addTitlebar.}:
        insert(app.toAutoFormMenu(sizeRequest = (400, 250))){.addRight.}
            
        Button() {.addRight.}:
          style = [ButtonFlat]
          text = "Urgent"
          proc clicked() = 
            app.showToast = true
            app.priority = ToastPriorityHigh
            app.toastTitle = "Urgent Toast Title !!!"
            
        Button() {.addRight.}:
          style = [ButtonFlat]
          text = "Notify"
          proc clicked() = 
            app.showToast = true
            app.priority = ToastPriorityNormal
            app.toastTitle = "Toast title"

      PreferencesWindow():
        searchEnabled = app.searchEnabled
        # visiblePageName =  app.name & " 1"
        if app.showToast:
          toast = toast
          
        for index, page in pages:
          # if index == 0:
          #   insert(page) {.addVisible.}
          # else:
          insert(page) {.addVisible.}

adw.brew(gui(App()))
