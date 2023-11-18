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

viewable Preferences:
  useUnderline: bool = true
  visiblePageName: string = "network"
  searchEnabled: bool = true

  resolutionOptions: seq[string] =  @["1024x768", "1280x720", "1920x1080", "2560x1440"]
  selectedResolution: string
  highDPIEnabled: bool = false
  colorOptions: seq[string] = @["Red", "Green", "Blue", "Yellow", "Purple"]
  selectedColorTheme: string
  backgroundColor: string
  fontOptions: seq[string] = @["Arial", "Times New Roman", "Helvetica", "Courier New", "Verdana"]
  selectedFont: string
  fontSize: string
  connectionOptions: seq[string] = @["Wi-Fi", "Ethernet", "Bluetooth", "Cellular"]
  selectedConnectionType: string
  proxyEnabled: bool = false
  firewallEnabled: bool = true
  vpnServer: string
  portForwardingEnabled: bool = false
  password: string
  passwordMismatch: bool

method view(app: PreferencesState): Widget =
  result = gui:
    PreferencesWindow():
      visiblePageName = app.visiblePageName
      searchEnabled = app.searchEnabled
      
      PreferencesPage():
        iconName = "display-symbolic"
        title = "Display"
        name = "display"
        description = "Configure display settings"
        useUnderline = true

        PreferencesGroup:
          title = "Resolution"
          description = "Adjust display resolution settings"

          ComboRow():
            title = "Select Resolution"
            items = app.resolutionOptions

            proc select(selectedIndex: int) =
              app.selectedResolution = app.resolutionOptions[selectedIndex]

          SwitchRow():
            title = "Enable High DPI Mode"
            active = app.highDPIEnabled

            proc activated(isActive: bool) =
              app.highDPIEnabled = isActive

        PreferencesGroup:
          title = "Color Settings"
          description = "Customize display color options"

          ComboRow():
            title = "Choose Theme Color"
            items = app.colorOptions

            proc select(selectedIndex: int) =
              app.selectedColorTheme = app.colorOptions[selectedIndex]

          EntryRow():
            title = "Background Color"
            text = app.backgroundColor

            proc changed(newColor: string) =
              app.backgroundColor = newColor

        PreferencesGroup:
          title = "Font Settings"
          description = "Set preferences for text fonts"

          ComboRow():
            title = "Select Font"
            items = app.fontOptions

            proc select(selectedIndex: int) =
              app.selectedFont = app.fontOptions[selectedIndex]

          EntryRow():
            title = "Font Size"
            text = app.fontSize

            proc changed(newSize: string) =
              app.fontSize = newSize

      PreferencesPage():
        iconName = "network-wired-symbolic"
        title = "Network"
        name = "network"
        description = "Configure network settings"
        useUnderline = true

        PreferencesGroup:
          title = "Connection Type"
          description = "Choose the type of network connection"

          ComboRow():
            title = "Select Connection Type"
            items = app.connectionOptions

            proc select(selectedIndex: int) =
              app.selectedConnectionType = app.connectionOptions[selectedIndex]

          SwitchRow():
            title = "Enable Proxy"
            active = app.proxyEnabled

            proc activated(isActive: bool) =
              app.proxyEnabled = isActive

        PreferencesGroup:
          title = "Security Settings"
          description = "Adjust network security preferences"

          SwitchRow():
            title = "Enable Firewall"
            active = app.firewallEnabled

            proc activated(isActive: bool) =
              app.firewallEnabled = isActive

          EntryRow():
            title = "VPN Server"
            text = app.vpnServer

            proc changed(newServer: string) =
              app.vpnServer = newServer

        PreferencesGroup:
          title = "Advanced Options"
          description = "Explore advanced network settings"

          ActionRow():
            title = "Run Diagnostics"
            Button() {.addSuffix.}:
              icon = "utilities-terminal-symbolic"
              proc clicked() = 
                echo "Do Diagnostics"

          SwitchRow():
            title = "Enable Port Forwarding"
            active = app.portForwardingEnabled

            proc activated(isActive: bool) =
              app.portForwardingEnabled = isActive

      PreferencesPage():
        iconName = "security-high-symbolic"
        title = "Security"
        name = "security"
        description = "Configure security settings"
        useUnderline = true

        PreferencesGroup:
          title = "Security Settings"
          description = "Configure security preferences"

          PasswordEntryRow():
            title = "Set Password"
            text = app.password

            proc changed(newPassword: string) =
              app.password = newPassword

          PasswordEntryRow():
            title = "Confirm Password"

            proc changed(confirmPassword: string) =
              app.passwordMismatch = app.password != confirmPassword 
                    
          if app.passwordMismatch:
            ListBoxRow():
              Label(text = "Passwords don't match")

viewable App:
  iconName: string = "weather-clear-symbolic"
  title: string = "Title"
  name: string = "Page "
  description: string = "An example of a Preferences Page"
  
  likeLevel: string 
  reasonForLikingExample: string
  

method view(app: AppState): Widget =
  result = gui:
    Window:
      title = "PreferencesWindow Example"
      defaultSize = (800, 700)

      HeaderBar {.addTitlebar.}:
        insert(app.toAutoFormMenu(sizeRequest = (400, 250))){.addRight.}

        Button {.addRight.}:
          style = [ButtonFlat]
          icon = "emblem-system-symbolic"
          
          proc clicked() =
            discard app.open(gui(Preferences()))
      
      Box():
        Label(text = "Click on the gear icon in the headerbar")
        Icon(name = "emblem-system-symbolic")
adw.brew(gui(App()))
