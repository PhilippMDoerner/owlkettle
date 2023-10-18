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

viewable App:
  # PreferencesWindow
  searchEnabled: bool = false
  
  
  # NavigationPage 1
  canPop1: bool = true
  tag1: string = "The first page"
  title1: string = "Page 1"
  
    
  # NavigationPage 2
  canPop2: bool = true
  tag2: string = "The second page"
  title2: string = "Page 2"

method view(app: AppState): Widget =
  result = gui:
    Window():
      defaultSize = (800, 600)
      title = "Status Page Example"
      HeaderBar {.addTitlebar.}:
        insert(app.toAutoFormMenu(sizeRequest = (400, 250))){.addRight.}
      
      PreferencesWindow():
        NavigationPage():
          canPop = app.canPop1
          tag = app.tag1
          title = app.title1
          
          proc hidden() = echo "Hidden1"
          proc hiding() = echo "Hiding1"
          proc showing() = echo "Showing1"
          proc shown() = echo "Shown1"
          
          Label(text = "This is Preferences Page 1!")
        
        NavigationPage():
          canPop = app.canPop2
          tag = app.tag2
          title = app.title2
          
          proc hidden() = echo "Hidden2"
          proc hiding() = echo "Hiding2"
          proc showing() = echo "Showing2"
          proc shown() = echo "Shown2"
          
          Label(text = "This is Preferences Page 2!")
      

adw.brew(gui(App()))
