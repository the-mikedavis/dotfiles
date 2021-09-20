{ pkgs }:
{
  package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    forceWayland = true;
  };
  profiles = {
    default = {
      id = 0;
      isDefault = true;
      name = "default";
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "gfx.webrender.enabled" = true;
        "layout.css.backdrop-filter.enabled" = true;
        "svg.context-properties.content.enabled" = true;
      };
      # NOTE this is the blurredfox theme of
      # https://github.com/manilarome/blurredfox
      # LICENSE is as follows:
      #
      # MIT License
      #
      # Copyright (c) 2020 Gerome Matilla
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

      userChrome = ''
        /* colors/blurred.css */
        :root {
          /* All the CSS variables here are global */
          /* These applies to all colorschemes */

          /* If windows - `-moz-win-glass`, if macOS - `-moz-mac-vibrancy-dark` */
          --bf-moz-appearance: -moz-win-glass !important;

          --bf-backdrop-blur: 6px;

          --bf-sidebar-searchbar-radius: 6px;

          --bf-accent-bg: #4C5FF9CC;
          --bf-blank-page-bg: #252525;

          --bf-urlbar-hightlight-bg: var(--bf-accent-bg);
          --bf-urlbar-radius: 9px;
          --bf-urlbar-results-font-size: 12pt;
          --bf-urlbar-results-font-weight: 550;
          --bf-urlbar-font-size: 12pt;
          --bf-urlbar-font-weight: 500;
          --bf-urlbar-switch-tab-color: #6498EF;
          --bf-urlbar-bookmark-color: #53E2AE;

          --bf-navbar-padding: 6px;

          --bf-tab-selected-bg: #77777788;
          --bf-tab-font-size: 11pt;
          --bf-tab-font-weight: 400;
          --bf-tab-height: 36px;
          --bf-tab-border-radius: 6px;
          --bf-tab-soundplaying-bg: #985EFFCC;

          --toolbar-bgcolor: transparent !important;
          --urlbar-separator-color: transparent !important;
        }

        /* Light Mode */
        :root:-moz-lwtheme-darktext {
          --bf-main-window: transparent;
          --bf-bg: #F2F2F266;
          --bf-color: #0A0A0A;

          --bf-hover-bg: #1A1A1A33;
          --bf-active-bg: #1A1A1A66;

          --bf-icon-color: #0A0A0A;
          --bf-tab-toolbar-bg: #F2F2F2AA;
          --bf-tab-selected-bg: #00000022;
          --bf-navbar-bg: var(--bf-bg);
          --bf-urlbar-bg: var(--bf-bg);
          --bf-urlbar-active-bg: var(--bf-bg);
          --bf-urlbar-focused-color: var(--bf-color);

          --bf-sidebar-bg: var(--bf-bg);
          --bf-sidebar-color: var(--bf-color);

          --bf-menupopup-bg: #F2F2F2AA;
          --bf-menupopup-color: var(--bf-color);
        }

        /* Dark Mode */
        :root:-moz-lwtheme-brighttext {
          --bf-main-window: transparent;
          --bf-bg: #00000066;
          --bf-color: #F2F2F2;

          --bf-hover-bg: #F2F2F233;
          --bf-active-bg: #F2F2F266;

          --bf-icon-color: #F2F2F2;
          --bf-tab-toolbar-bg: #000000AA;
          --bf-tab-selected-bg: #F2F2F210;
          --bf-navbar-bg: var(--bf-bg);
          --bf-urlbar-bg: var(--bf-bg);
          --bf-urlbar-active-bg: var(--bf-bg);
          --bf-urlbar-focused-color: var(--bf-color);

          --bf-sidebar-bg: var(--bf-bg);
          --bf-sidebar-color: var(--bf-color);

          --bf-menupopup-bg: #000000AA;
          --bf-menupopup-color: var(--bf-color);
        }

        /* parts/arrow-panel.css */
        /*
        ░█▀█░█▀▄░█▀▄░█▀█░█░█░█▀█░█▀█░█▀█░█▀▀░█░░
        ░█▀█░█▀▄░█▀▄░█░█░█▄█░█▀▀░█▀█░█░█░█▀▀░█░░
        ░▀░▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░░░▀░▀░▀░▀░▀▀▀░▀▀▀

        The dropdown menus
        */

        .panel-arrowcontent {
          padding: 0 !important;
          margin: 0 !important;
        }

        toolbarseparator {
          display: none !important;
        }

        box.panel-arrowbox {
          display: none;
        }

        box.panel-arrowcontent {
          border-radius: 8px !important;
          border: none !important;
        }

        /* parts/context-menu.css */
        /*
        ░█▀▀░█▀█░█▀█░▀█▀░█▀▀░█░█░▀█▀░█▄█░█▀▀░█▀█░█░█
        ░█░░░█░█░█░█░░█░░█▀▀░▄▀▄░░█░░█░█░█▀▀░█░█░█░█
        ░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░▀░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀

        Right-click menu
        */

        menupopup,
        popup,
        popup > menu > menupopup,
        menupopup > menu > menupopup {
          border: 0 !important;
          border-radius: 4px !important;
          padding: 2px 0 2px 0  !important;
        }

        menupopup:-moz-lwtheme-darktext,
        menupopup:-moz-lwtheme-brighttext,
        popup:-moz-lwtheme-darktext,
        popup:-moz-lwtheme-brighttext,
        popup > menu > menupopup:-moz-lwtheme-darktext,
        popup > menu > menupopup:-moz-lwtheme-brighttext,
        menupopup > menu > menupopup:-moz-lwtheme-darktext,
        menupopup > menu > menupopup:-moz-lwtheme-brighttext {
          -moz-appearance: none !important;
          background: var(--bf-menupopup-bg) !important;
          color: var(--bf-menupopup-color) !important;
        }

        menupopup menuseparator {
        /*   -moz-appearance: none !important; */
          margin: 2px 0 2px 0 !important;
          padding: 0 !important;
          border-top: none !important;
          border-color: transparent !important;
        }

        menupopup menuseparator:-moz-lwtheme-darktext,
        menupopup menuseparator:-moz-lwtheme-brighttext {
          -moz-appearance: none !important;
          background: #525A6D  !important;
        }

        /* parts/customization-window.css */
        /*
        ░█▀▀░█░█░█▀▀░▀█▀░█▀█░█▄█░▀█▀░▀▀█░█▀█░▀█▀░▀█▀░█▀█░█▀█░█░█░▀█▀░█▀█░█▀▄░█▀█░█░█
        ░█░░░█░█░▀▀█░░█░░█░█░█░█░░█░░▄▀░░█▀█░░█░░░█░░█░█░█░█░█▄█░░█░░█░█░█░█░█░█░█▄█
        ░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀

        The customization window
        */

        #customization-container {
        }

        #customization-container:-moz-lwtheme-darktext,
        #customization-container:-moz-lwtheme-brighttext {
          background: var(--bf-bg) !important;
        }

        .customizationmode-button {
          padding: 5px !important;
          border-radius: 6px !important;
        }

        .customizationmode-button:-moz-lwtheme-darktext,
        .customizationmode-button:-moz-lwtheme-brighttext {
          color: var(--bf-color) !important;;
        }

        .customizationmode-button:hover {
          padding: 5px !important;
          border-radius: 6px !important;
        }

        .customizationmode-button label {
        }

        /* parts/findbar.css */
        /*
        ░█▀▀░▀█▀░█▀█░█▀▄░█▀▄░█▀█░█▀▄
        ░█▀▀░░█░░█░█░█░█░█▀▄░█▀█░█▀▄
        ░▀░░░▀▀▀░▀░▀░▀▀░░▀▀░░▀░▀░▀░▀

        The findbar
        */

        #browser #appcontent #tabbrowser-tabbox findbar,
        #browser #appcontent #tabbrowser-tabbox tabpanels {
          -moz-appearance: none !important;
          border: none !important;
        }

        #browser #appcontent #tabbrowser-tabbox findbar:-moz-lwtheme-darktext,
        #browser #appcontent #tabbrowser-tabbox findbar:-moz-lwtheme-brighttext,
        #browser #appcontent #tabbrowser-tabbox tabpanels:-moz-lwtheme-darktext,
        #browser #appcontent #tabbrowser-tabbox tabpanels:-moz-lwtheme-brighttext {
          background: transparent !important;
        }

        #browser #appcontent #tabbrowser-tabbox findbar {
        }

        #browser #appcontent #tabbrowser-tabbox findbar:-moz-lwtheme-darktext,
        #browser #appcontent #tabbrowser-tabbox findbar:-moz-lwtheme-brighttext {
          background-color: var(--bf-bg) !important;
        }

        .findbar-find-previous,
        .findbar-find-next {
          margin: 0 !important;
          border: none !important;
        }

        #browser #appcontent #tabbrowser-tabbox .findbar-find-fast {
        }

        #browser #appcontent #tabbrowser-tabbox .findbar-find-fast:not([status="notfound"]):-moz-lwtheme-darktext,
        #browser #appcontent #tabbrowser-tabbox .findbar-find-fast:not([status="notfound"]):-moz-lwtheme-brighttext {
          background-color: var(--bf-bg) !important;
        }

        /* parts/main-window.css */
        /*
        ░▀█▀░█▀▄░█▀█░█▀█░█▀▀░█▀█░█▀█░█▀▄░█▀▀░█▀█░█▀▀░█░█
        ░░█░░█▀▄░█▀█░█░█░▀▀█░█▀▀░█▀█░█▀▄░█▀▀░█░█░█░░░░█░
        ░░▀░░▀░▀░▀░▀░▀░▀░▀▀▀░▀░░░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀▀░░▀░

        Main window
        */
        #main-window {
          font-kerning: normal;
          border: none !important;
        }

        /* Add transparency to light and dark color schemes */
        #main-window:-moz-lwtheme-brighttext,
        #main-window:-moz-lwtheme-darktext {
          background: var(--bf-main-window) !important;
          -moz-appearance: var(--bf-moz-appearance) !important;
        }

        /*
        ░█▀▀░█▀█░█▀█░▀█▀
        ░█▀▀░█░█░█░█░░█░
        ░▀░░░▀▀▀░▀░▀░░▀░

        I'm not sure if this does something
        */

        * {
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
          text-rendering: optimizeLegibility;
          font-variant-ligatures: none;
          font-kerning: normal;
        }


        /* parts/sidebar.css */
        /*
        ░█▀▀░▀█▀░█▀▄░█▀▀░█▀▄░█▀█░█▀▄
        ░▀▀█░░█░░█░█░█▀▀░█▀▄░█▀█░█▀▄
        ░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀▀░░▀░▀░▀░▀

        Sidebar
        */

        #sidebar-box {
        }

        #sidebar-box:-moz-lwtheme-darktext,
        #sidebar-box:-moz-lwtheme-brighttext {
          --sidebar-background-color: var(--bf-sidebar-bg) !important;
          --sidebar-text-color: var(--bf-sidebar-color) !important;
        }

        #sidebar,
        .sidebar-panel {
          background: transparent !important;
        }

        /* Sidebar searchbar */
        #sidebar-search-container #search-box {
          border: none !important;
          padding: 6px !important;
          border-radius: var(--bf-sidebar-searchbar-radius) !important;
        }


        /* parts/tabbar.css */
        /*
        ░▀█▀░█▀█░█▀▄░█▀▄░█▀█░█▀▄
        ░░█░░█▀█░█▀▄░█▀▄░█▀█░█▀▄
        ░░▀░░▀░▀░▀▀░░▀▀░░▀░▀░▀░▀

        The tabs container
        */

        /* Move tab bar beneath the url bar */
        #titlebar {
          /*
          Set the value to 3 to move the tabbar below the navbar
          */
          -moz-box-ordinal-group: 1 !important;
        }

        #titlebar::after {
          border-bottom: 0 !important;
        }

        .toolbar-items {
        }

        /* Transparent tabs */
        .toolbar-items:-moz-lwtheme-darktext,
        .toolbar-items:-moz-lwtheme-brighttext {
          background-color: transparent !important;
          -moz-appearance: var(--bf-moz-appearance) !important;
        }

        /*   Set minimum height for tab bar */
        #tabbrowser-tabs {
          /* --tab-min-height: 0; */
          margin: 6px 5px 6px 5px;
        }

        /* Compact mode */
        :root[uidensity="compact"] #tabbrowser-tabs {
          margin: 0 !important;
        }

        /* Hide solo tab */
        /*
        #tabbrowser-tabs tab[first-visible-tab="true"][last-visible-tab="true"]:only-of-type {
          visibility: collapse;
        }
        */

        /* Hide New Tab Button immediately next to solo tab */
        /*
        #tabbrowser-tabs tab[first-visible-tab="true"][last-visible-tab="true"]:only-of-type + toolbarbutton {
          visibility: collapse;
        }
        */

          /* Stretch Tabs */
        .tabbrowser-tab[fadein]:not([pinned]) {
          max-width: none !important;
        }

        .tab-background {
          border: none !important;
        }

        .tab-background:-moz-lwtheme-darktext,
        .tab-background:-moz-lwtheme-brighttext {
          background: transparent !important;
          -moz-appearance: var(--bf-moz-appearance) !important;
        }

        .tab-background[selected="true"] {
          background: var(--bf-tab-selected-bg) !important;
        }

        .tab-background:not[visuallyselected] {
          background: var(--bf-tab-selected-bg) !important;
          opacity: 0.5 !important;
        }

        /* Remove the all the "lines" in tab sides */
        /*
        .tabbrowser-tab::after,
        .tabbrowser-tab::before {
          border-left: none !important;
        }
        */

        /* Remove the lines on the side of the selected tab */
        .tabbrowser-tab[beforeselected-visible="true"]::after,
        .tabbrowser-tab[beforeselected-visible="true"]::before,
        .tabbrowser-tab[selected="true"]::after,
        .tabbrowser-tab[selected="true"]::before {
          border-left: none !important;
        }

        /* Style all the lines before and after selected tab */
        .tabbrowser-tab::after,
        .tabbrowser-tab::before {
          border-width: 1px !important;
        }

        .tabbrowser-arrowscrollbox {
          margin-inline-start: 4px !important;
          margin-inline-end: 0 !important;
        }

        .tab-text {
          font-weight: var(--bf-tab-font-weight);
          font-size: var(--bf-tab-font-size) !important;
        }

        /* Center all content */
        .tab-content {
          justify-content: center;
          align-items: center;
          margin-top: -1px;
          min-width: 100% !important;
          padding: 0 10px !important;
        }

        /* A way to center the label and icon while
        the close button is positioned to the far right */
        .tab-content::before{
          content: "";
          display: -moz-box;
          -moz-box-flex: 1
        }

        /* Tab close button */
        .tab-close-button {
          opacity: 1 !important;
        }

        /* Prevent tab icons size breaking */
        .tab-icon-image, .tab-icon-sound,
        .tab-throbber, .tab-throbber-fallback,
        .tab-close-button {
          min-width: 16px;
        }

        /* Adjust tab label width */
        .tab-label-container {
          min-width: 3px !important;
        }

        /* If tab close button is not present, don't force favicon to the center */
        #tabbrowser-tabs[closebuttons="activetab"] .tabbrowser-tab:not([selected="true"]) .tab-throbber,
        #tabbrowser-tabs[closebuttons="activetab"] .tabbrowser-tab:not([selected="true"]) .tab-throbber-fallback,
        #tabbrowser-tabs[closebuttons="activetab"] .tabbrowser-tab:not([selected="true"]):not([busy]) .tab-icon-image,
        #tabbrowser-tabs[closebuttons="activetab"] .tabbrowser-tab:not([selected="true"]):not([image]) .tab-label-container {
          margin-left: 0 !important;
        }

        /* Tab icon */
        hbox.tab-content .tab-icon-image {
          display: initial !important;
        }

        /* Show the icon of pinned tabs */
        hbox.tab-content[pinned=true] .tab-icon-image {
          display: initial !important;
        }

        /* Hide text of pinned tabs */
        hbox.tab-content[pinned=true] .tab-text {
          display: none !important;
        }

        /*   Hide the blue line on top of tab */
        .tab-line {
          display: none !important;
        }

        .tab-bottom-line {
        }

        .tabbrowser-tab {
          border-radius: var(--bf-tab-border-radius) !important;
          border-width: 0;
          height: var(--bf-tab-height) !important;
          overflow: hidden;
          margin-top: 0 !important;
          margin-bottom: 0 !important;
        }

        :root[uidensity="compact"] .tabbrowser-tab {
          border-radius: 0 !important;
        }

        .tabbrowser-tab:hover {
          box-shadow: 0 1px 4px rgba(0,0,0,.05);
        }

        /* Set color scheme */
        .tabbrowser-tab:hover:-moz-lwtheme-darktext,
        .tabbrowser-tab:hover:-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        /*   Audio playing background */
        .tabbrowser-tab[soundplaying="true"] {
          background-color: var(--bf-tab-soundplaying-bg) !important;
        }

        #tabbrowser-tabs {
        }

        /*   Audio Icon */
        .tab-icon-sound {
        }

        /* Center pinned tab stack(Contains icon) if #tabbrowser-tabs[positionpinnedtabs=true] */
        #tabbrowser-tabs[positionpinnedtabs=true] .tabbrowser-tab[pinned=true] .tab-stack {
          position: relative !important;
          top: 50% !important;
          transform: translateY(-50%) !important;
        }


        .private-browsing-indicator {
          display: block;
          background: transparent;
        }

        /* Remove hover effects on tab bar buttons */
        #TabsToolbar {
          --toolbarbutton-active-background: transparent !important;
          --toolbarbutton-hover-background: transparent !important;
          -moz-appearance: none !important;
        }

        /* Left to Right Alignment of tabs toolbar */
        /* #TabsToolbar {
          direction: rtl;
        }

        #tabbrowser-tabs {
          direction: ltr;
        }
        */

        /* parts/toolbar.css */
        /*
        ░▀█▀░█▀█░█▀█░█░░░█▀▄░█▀█░█▀▄
        ░░█░░█░█░█░█░█░░░█▀▄░█▀█░█▀▄
        ░░▀░░▀▀▀░▀▀▀░▀▀▀░▀▀░░▀░▀░▀░▀

        Contains navbar, urlbar, and etc.
        */

        .browser-toolbar {
        }

        .browser-toolbar:-moz-lwtheme-darktext,
        .browser-toolbar:-moz-lwtheme-brighttext {
          background: var(--bf-tab-toolbar-bg) !important;
        }

        toolbar {
          background-image: none !important;
        }

        toolbar#nav-bar {
          padding: var(--bf-navbar-padding) !important;

          /* Remove horizontal line on navbar */
          box-shadow: none !important;
          border-top: none !important;
        }

        /* Set color schemes for #nav-bar */
        toolbar#nav-bar:-moz-lwtheme-darktext,
        toolbar#nav-bar:-moz-lwtheme-brighttext {
          background: var(--bf-navbar-bg) !important;
        }

        toolbarbutton {
          box-shadow: none !important;
          margin-left: 2px !important;
        }

        .toolbarbutton-1 {
        }

        /* Set color schemes for #nav-bar */
        .toolbarbutton-1:-moz-lwtheme-darktext,
        .toolbarbutton-1:-moz-lwtheme-brighttext {
          --toolbarbutton-hover-background: var(--bf-hover-bg) !important;
          --toolbarbutton-active-background: var(--bf-active-bg) !important;
        }

        #searchbar {
          border: none !important;
        }

        /* Set color scheme */
        #searchbar:-moz-lwtheme-darktext,
        #searchbar:-moz-lwtheme-brighttext {
          background: var(--bf-bg) !important;
        }

        .searchbar-textbox {
          font-weight: 700 !important;
        }

        #navigator-toolbox,
        toolbaritem {
          border: none !important;
        }

        #navigator-toolbox::after {
          border-bottom: 0 !important;
        }

        .toolbarbutton-text {
        }

        /* Set color scheme */
        .toolbarbutton-text:-moz-lwtheme-darktext,
        .toolbarbutton-text:-moz-lwtheme-brighttext {
          color: var(--bf-icon-color)  !important;
        }

        /* Back button */
        #back-button > .toolbarbutton-icon {
          --backbutton-background: transparent !important;
          border: none !important;
          -moz-appearance: var(--bf-moz-appearance) !important;
        }

        /* parts/urlbar.css */
        /*
        ░█░█░█▀▄░█░░░█▀▄░█▀█░█▀▄
        ░█░█░█▀▄░█░░░█▀▄░█▀█░█▀▄
        ░▀▀▀░▀░▀░▀▀▀░▀▀░░▀░▀░▀░▀

        URL bar
        */

        /* URL bar max-width and centered hack */
        #urlbar {
          max-width: 70% !important;
          margin: 0 15% !important;

          /* URL bar and toolbar height */
          --urlbar-height: 36px !important;
          --urlbar-toolbar-height: 40px !important;
        }

        /* URL bar and toolbar height if compact mode */
        :root[uidensity="compact"] #urlbar {
          --urlbar-height: 30px !important;
          --urlbar-toolbar-height: 34px !important;
        }

        #urlbar-input:focus {
        }

        /* Set color scheme */
        #urlbar-input:focus:-moz-lwtheme-darktext,
        #urlbar-input:focus:-moz-lwtheme-brighttext {
          color: var(--bf-urlbar-focused-color) !important;
        }

        #urlbar-background {
          border-radius: var(--bf-urlbar-radius) !important;
          border: none !important
        }

        /* Set color scheme */
        #urlbar-background:-moz-lwtheme-darktext,
        #urlbar-background:-moz-lwtheme-brighttext {
          background: var(--bf-urlbar-bg) !important;
        }

        .urlbar-icon:not([disabled]):hover,
        .urlbar-icon-wrapper:not([disabled]):hover {
        }

        /* Set color scheme */
        .urlbar-icon:not([disabled]):hover:-moz-lwtheme-darktext,
        .urlbar-icon:not([disabled]):hover:-moz-lwtheme-brighttext,
        .urlbar-icon-wrapper:not([disabled]):hover:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper:not([disabled]):hover:-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        .urlbar-icon[open],
        .urlbar-icon-wrapper[open],
        .urlbar-icon:not([disabled]):hover:active,
        .urlbar-icon-wrapper:hover:active {
        }

        /* Set color scheme */
        .urlbar-icon[open]:-moz-lwtheme-darktext,
        .urlbar-icon[open]:-moz-lwtheme-brighttext,
        .urlbar-icon-wrapper[open]:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper[open]:-moz-lwtheme-brighttext,
        .urlbar-icon:not([disabled]):hover:active:-moz-lwtheme-darktext,
        .urlbar-icon:not([disabled]):hover:active:-moz-lwtheme-brighttext,
        .urlbar-icon-wrapper:hover:active:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper:hover:active:-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        .urlbar-icon-wrapper[open] > .urlbar-icon,
        .urlbar-icon-wrapper > .urlbar-icon:hover,
        .urlbar-icon-wrapper > .urlbar-icon:hover:active {
        }

        /* Set color scheme */
        .urlbar-icon-wrapper[open] > .urlbar-icon:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper[open] > .urlbar-icon:-moz-lwtheme-brighttext,
        .urlbar-icon-wrapper > .urlbar-icon:hover:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper > .urlbar-icon:hover:-moz-lwtheme-brighttext,
        .urlbar-icon-wrapper > .urlbar-icon:hover:active:-moz-lwtheme-darktext,
        .urlbar-icon-wrapper > .urlbar-icon:hover:active:-moz-lwtheme-brighttext{
          background: var(--bf-hover-bg) !important;
        }

        #urlbar[breakout-extend="true"]:not([open="true"]) > #urlbar-background {
          box-shadow: none !important;
          display: none !important;
          -moz-appearance: var(--bf-moz-appearance) !important;
        }

        #urlbar[open="true"] > #urlbar-background {
        }

        /* Set color scheme */
        #urlbar[open="true"] > #urlbar-background:-moz-lwtheme-darktext,
        #urlbar[open="true"] > #urlbar-background:-moz-lwtheme-brighttext {
          background: var(--bf-urlbar-active-bg) !important;
          backdrop-filter: blur(var(--bf-backdrop-blur)) !important;
        }

        .urlbar-icon {
        }

        /* Set color scheme */
        .urlbar-icon:-moz-lwtheme-darktext,
        .urlbar-icon:-moz-lwtheme-brighttext {
          color: var(--bf-icon-color) !important;
        }

        .urlbar-icon > image {
          fill: #ff00ff !important;
          color: #ff00ff !important;
        }

        .urlbarView-favicon,
        .urlbarView-type-icon {
          display: none !important;
        }

        .urlbarView-row[type="bookmark"] > span {
          color: var(--bf-urlbar-bookmark-color) !important;
        }

        .urlbarView-row[type="switchtab"] > span .urlbarView-url {
          color: var(--bf-urlbar-switch-tab-color) !important;
        }

        #urlbar-results {
          font-weight: var(--bf-urlbar-results-font-weight);
          font-size: var(--bf-urlbar-results-font-size) !important;
        }

        /* Hover background color */
        .urlbarView-row-inner:hover {
          background: var(--bf-accent-bg) !important;
        }

        .urlbarView-url, .search-panel-one-offs-container {
          font-weight: var(--bf-urlbar-results-font-weight);
          font-size: var(--bf-urlbar-font-size) !important;
        }

        #urlbar-input {
          font-size: var(--bf-urlbar-font-size) !important;
          font-weight: var(--bf-urlbar-font-weight)!important;
          text-align: center !important;
        }

        /* Urlbar buttons */
        .urlbar-icon,
        .urlbar-page-action {
          border-radius: 6px;
        }

        /* URL bar hightlight color */
        ::-moz-selection {
          background-color: var(--bf-urlbar-hightlight-bg) !important;
        }

        /* Bookmark button - Star button */
        #star-button {
        }

        #star-button:hover:not(.no-hover):not([open=true]) {
        }

        /* Set color scheme */
        #star-button:hover:not(.no-hover):not([open=true]):-moz-lwtheme-darktext,
        #star-button:hover:not(.no-hover):not([open=true]):-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        #star-button:hover:active:not(.no-hover),
        #star-button[open=true] {
        }

        /* Set color scheme */
        #star-button:hover:active:not(.no-hover):-moz-lwtheme-darktext,
        #star-button:hover:active:not(.no-hover):-moz-lwtheme-brighttext,
        #star-button[open=true]:-moz-lwtheme-darktext,
        #star-button[open=true]:-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        /* Tracking */
        #tracking-protection-icon-container {
          border-radius: 6px;
          margin: 2px;
        }

        /* Identity */
        #identity-box {
          border-radius: 6px;
          margin: 2px;
        }

        #identity-box:hover:not(.no-hover):not([open=true]),
        #tracking-protection-icon-container:hover:not(.no-hover):not([open=true]) {
        }

        #identity-box:hover:not(.no-hover):not([open=true]):-moz-lwtheme-darktext,
        #identity-box:hover:not(.no-hover):not([open=true]):-moz-lwtheme-brighttext,
        #tracking-protection-icon-container:hover:not(.no-hover):not([open=true]):-moz-lwtheme-darktext,
        #tracking-protection-icon-container:hover:not(.no-hover):not([open=true]):-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        #identity-box:hover:active:not(.no-hover),
        #identity-box[open=true],
        #tracking-protection-icon-container:hover:active:not(.no-hover),
        #tracking-protection-icon-container[open=true] {
        }

        #identity-box:hover:active:not(.no-hover):-moz-lwtheme-darktext,
        #identity-box:hover:active:not(.no-hover):-moz-lwtheme-brighttext,
        #identity-box[open=true]:-moz-lwtheme-darktext,
        #identity-box[open=true]:-moz-lwtheme-brighttext,
        #tracking-protection-icon-container:hover:active:not(.no-hover):-moz-lwtheme-darktext,
        #tracking-protection-icon-container:hover:active:not(.no-hover):-moz-lwtheme-brighttext,
        #tracking-protection-icon-container[open=true]:-moz-lwtheme-darktext,
        #tracking-protection-icon-container[open=true]:-moz-lwtheme-brighttext {
          background: var(--bf-hover-bg) !important;
        }

        /* parts/window-controls.css */
        /*
        ░█░█░▀█▀░█▀█░█▀▄░█▀█░█░█░█▀▄░█░█░▀█▀░▀█▀░█▀█░█▀█░█▀▀
        ░█▄█░░█░░█░█░█░█░█░█░█▄█░█▀▄░█░█░░█░░░█░░█░█░█░█░▀▀█
        ░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀░▀▀░░▀▀▀░░▀░░░▀░░▀▀▀░▀░▀░▀▀▀

        The control buttons. Contains, close, minimize, and maximize buttons
        */

        #autohide-context {
          display: none !important;
        }

        #window-controls[hidden="true"] {
          display: none !important;
        }

        #window-controls[hidden="false"] {
          display: inline-flex !important;
        }

        /* Hide titlebar-buttonbox if there's single tab */
        /*
        :root[tabsintitlebar][sizemode="maximized"] #titlebar .titlebar-buttonbox-container {
          display: none !important;
        }
        */
      '';
      userContent = ''
        @import url('userChrome.css');

        /* Removes the white loading page */
        /* url(about:newtab), url(about:home) */
        @-moz-document url(about:blank) {
          html:not(#ublock0-epicker), html:not(#ublock0-epicker) body, #newtab-customize-overlay {
            background: var(--bf-bg) !important;
          }
        }

        /* Sets up minimal scrollbar */
        :root {
          scrollbar-width: thin !important;
          scrollbar-color: rgb(161, 161, 161) transparent !important;
        }

        /*  Sets up minimal incognito scrollbar */
        @-moz-document url(about:privatebrowsing) {
          :root{
            scrollbar-width: thin !important;
            scrollbar-color: rgb(161, 161, 161) transparent !important;
          }
        }
      '';
      extraConfig = ''
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        user_pref("layers.acceleration.force-enabled", true);
        user_pref("gfx.webrender.all", true);
        user_pref("gfx.webrender.enabled", true);
        user_pref("svg.context-properties.content.enabled", true);
        user_pref("layout.css.backdrop-filter.enabled", true);
      '';
    };
  };
}
