import Shell from 'gi://Shell';
import Clutter from 'gi://Clutter';
import GObject from 'gi://GObject';
import Gio from 'gi://Gio';
import St from 'gi://St';
import Meta from 'gi://Meta';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

const Indicator = GObject.registerClass({
    Signals: {
        'toggle-transparency': {},
    },
}, class Indicator extends PanelMenu.Button {
    _init(metadataPath) {
        super._init(0.0, 'Transparent Window');
        
        // Create icon using custom asset
        this._icon = new St.Icon({
            gicon: Gio.icon_new_for_string(metadataPath + '/transparent-window-icon.png'),
            style_class: 'system-status-icon',
        });
        this.add_child(this._icon);
        
        // NOTE: removed the click handler; triggering will be done via keybinding
    }
    
});

export default class TransparentWindowExtension extends Extension {
    enable() {
        // Load GSettings first
        this._settings = this.getSettings();
        
        this._debug('TransparentWindow: Enabling extension');
        
        // Create and add panel indicator
        this._indicator = new Indicator(this.metadata.path);
        Main.panel.addToStatusArea(this.uuid, this._indicator);
        
        // Initialize state
        this._originalOpacity = null;
        
        // Connect toggle signal (keeps the same flow as before)
        this._indicator.connect('toggle-transparency', () => {
            this._toggleWindowTransparency();
        });
        
        // // Hardcoded keybinding configuration
        // const KEYBIND_NAME = 'toggle-hotkey';
        // const KEYBIND_STR = '<Alt>8'; // Change this to your preferred shortcut
        //
        // // Register the keybinding directly to the display
        // global.display.add_keybinding(
        //     KEYBIND_NAME,
        //     this._settings,
        //     Meta.KeyBindingFlags.NONE,
        //     () => {
        //         this._toggleWindowTransparency();
        //     }
        // );

        Main.wm.addKeybinding("toggle-hotkey",
          this._settings,
          Meta.KeyBindingFlags.NONE,
          Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
          this._toggleWindowTransparency.bind(this));

        Main.wm.addKeybinding("increase-window-opacity",
          this._settings,
          Meta.KeyBindingFlags.NONE,
          Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
          this._increaseWindowOpacity.bind(this));

        Main.wm.addKeybinding("decrease-window-opacity",
          this._settings,
          Meta.KeyBindingFlags.NONE,
          Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
          this._decreaseWindowOpacity.bind(this));


        // // Register keybinding (must be declared in your gschema)
        try {
            Main.wm.addKeybinding(
                'toggle-hotkey',           // key name in your schema
                this._settings,            // Gio.Settings instance
                Meta.KeyBindingFlags.NONE, // flags
                Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
                this._toggleWindowTransparency.bind(this)
            );

            Main.wm.addKeybinding("increase-window-opacity",
              this._settings,
              Meta.KeyBindingFlags.IGNORE_AUTOREPEAT,
              Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
              this._increaseWindowOpacity.bind(this));

            Main.wm.addKeybinding("decrease-window-opacity",
              this._settings,
              Meta.KeyBindingFlags.IGNORE_AUTOREPEAT,
              Shell.ActionMode.NORMAL | Shell.ActionMode.OVERVIEW,
              this._decreaseWindowOpacity.bind(this));

            this._debug('TransparentWindow: Keybindings registered (toggle-hotkey, increase-window-opacity, decrease-window-opacity)');
        } catch (e) {
            this._debug('TransparentWindow: Failed to add keybinding for (toggle-hotkey, increase-window-opacity, decrease-window-opacity)', e);
        }


        this._debug('TransparentWindow: Extension enabled successfully');
    }

    disable() {
        this._debug('TransparentWindow: Disabling extension');
        
        // Remove keybinding
        try {
            Main.wm.removeKeybinding('toggle-hotkey');
            Main.wm.removeKeybinding('increase-window-opacity');
            Main.wm.removeKeybinding('decrease-window-opacity');
            this._debug('TransparentWindow: Keybinding removed (toggle-hotkey)');
        } catch (e) {
            this._debug('TransparentWindow: Failed to remove keybinding:', e);
        }
        
        if (this._indicator) {
            this._indicator.destroy();
            this._indicator = null;
        }
        
        this._settings = null;
        
        this._debug('TransparentWindow: Extension disabled successfully');
    }
    
    _toggleWindowTransparency() {
        // Get the currently focused window
        const focusWindow = global.display.get_focus_window();
        if (!focusWindow) {
            this._debug('TransparentWindow: No focused window found');
            return;
        }
        
        const windowActor = focusWindow.get_compositor_private();
        if (!windowActor) {
            this._debug('TransparentWindow: No window actor found');
            return;
        }
        
        // Toggle transparency based on current state
        if (windowActor.opacity < 255) {
            // Window is transparent, restore original opacity
            const opacity = this._originalOpacity || 255;
            windowActor.opacity = opacity;
            this._debug('TransparentWindow: Restored window opacity:', focusWindow.get_title());
            this._originalOpacity = null;
        } else {
            // Window is opaque, make it transparent
            if (!this._originalOpacity) {
                this._originalOpacity = windowActor.opacity;
            }
            const opacityPercent = this._settings.get_int('opacity-level');
            const opacityValue = Math.round((opacityPercent / 100) * 255);
            windowActor.opacity = opacityValue;
            this._debug('TransparentWindow: Made window transparent:', focusWindow.get_title(), 'opacity:', opacityValue, '(' + opacityPercent + '%)');
        }
    }

    _increaseWindowOpacity() {
        const focusWindow = global.display.get_focus_window();
        if (!focusWindow) {
            this._debug('TransparentWindow: No focused window found');
            return;
        }
        
        const windowActor = focusWindow.get_compositor_private();
        if (!windowActor) {
            this._debug('TransparentWindow: No window actor found');
            return;
        }
        let opacityValue = this._originalOpacity || windowActor.opacity;

        if (Math.min(opacityValue + 20, 255) == 255) {
          this._debug('TransparentWindow: Maximum opacity reached');
        }else{
          opacityValue = (opacityValue + 20) % 255;
          windowActor.opacity = opacityValue; 
        }
    }

    _decreaseWindowOpacity() {
        const focusWindow = global.display.get_focus_window();
        if (!focusWindow) {
            this._debug('TransparentWindow: No focused window found');
            return;
        }
        
        const windowActor = focusWindow.get_compositor_private();
        if (!windowActor) {
            this._debug('TransparentWindow: No window actor found');
            return;
        }
        let opacityValue = this._originalOpacity || windowActor.opacity;
        opacityValue = (opacityValue - 20) % 255;
        windowActor.opacity = opacityValue; 
    }



    _debug(...args) {
        if (this._settings && this._settings.get_boolean('debug-mode')) {
            console.log(...args);
        }
    }
}
