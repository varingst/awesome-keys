# Awesome Keys


A tiny module for Awesome WM, solely to make keybindings in rc.lua more
concise and readable (for me):

- keys with shared `group` and `modifier keys` can be grouped together
- keys are defined in the order of
  - _intent_ (description)
  - keypress
  - _implementation_ (function)

## From rc.lua:

```
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    ....
)
```

## With this module:
```
local keys = require("keys")
globalkeys = keys.join(
    keys.tag({ modkey },
        "view previous",       "Left",      awful.tag.viewprev,
        "view next",           "Right",     awful.tag.viewnext,
        "go back",             "Escape",    awful.tag.history.restore),

    keys.awesome({ modkey },
        "show help",           "s",         hotkeys_popup.show_help,
        "show main menu",      "w",         function() mymainmenu:show() end),

    keys.client({ modkey },
        "focus next by index",     "j", function() awful.client.focus.byidx(1) end,
        "focus previous by index", "k", function() awful.client.focus.byidx(-1) end),
    ....
)
```


# Usage

Functions provided by the module:
```
-- group by modifiers
keys(<modifier table>,
     <desc1>, <key1>, <func1>,
     <desc2>, <key2>, <func2>,
     ...
)
-- group by group and modifiers
keys.<group>(<modfier table>, <desc1>, <key1>, <func1>, ...)

keys.join(<keys() or awful.key()>, ...)

keys.only_if(<bool>,
  <keys() or awful.key()>,
  <keys() or awful.key()>,
  ....
)
```

In use:

```
local keys = require("keys")

joined_keys = keys.join(

  -- shared group and modifiers
  keys.tag({ modkey },
      <description>,   <key>,   <function>,
      <description>,   <key>,   <function>,
      <description>,   <key>,   <function>,
  ),

  -- key with no group and no modifiers
  keys({}, "quit", "F12", awesome.quit),


  -- slip an awful.key() in here too
  awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
            { description = "open a terminal", group = "launcher" }),


  -- keys.only_if() only returns keys if the first parameter evaluates true
  keys.only_if(awesome.hostname == "deep_blue",
      keys.chess({ "Control", "Alt" },
          "flip table", "Delete", awful.spawn("/sbin/shutdown -r now"),
      )
  )
)
```
