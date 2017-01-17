-- LuaMacros: https://github.com/me2d13/luamacros
-- Forum    : http://www.hidmacros.eu/forum/viewforum.php?f=9

clear() -- Clear the console.
-- lmc_say('Hello world')  -- Text-to-Speech, nice?

print('Version: ' .. lmc.version)
lmc.minimizeToTray = true
-- lmc_minimize()
-- print(lmc_get_window_title())

-- List the devices (HID) on this computer
lmc_print_devices()
print('------------')
-- Take an Xbox360 controller and a cheap usb numpad and give them symbolic names.
print(lmc_device_set_name('XboxBlack', '9BC97B50:BD8'));
print(lmc_device_set_name('NumPad', 'VID_13BA&PID_0001'))

-- Function to use as a callback
-- Log the button events from a gamepad.
gamepad_log_handler = function(button, direction, ts)
  print('Callback for device: button ' .. button .. ', direction '..direction..', ts '..ts)
--  lmc_send_keys(tostring(button))
end

-- Function to use as a callback
-- Log the button events from a keyboard.
keyboard_log_handler = function(button, direction)
  print('Callback for keyboard: button ' .. button .. ', direction '..direction)
end

lmc_set_handler('XboxBlack', gamepad_log_handler)

-- args: 
--   Symbolic Name of the device
--   Offset (don't know what it does exactly)
--   Delay (in milisecond) between the callbacks
--   Minimum delta between the last value to trigger the callback.
--
-- ts means "timestamp", which is the machine time, not unix-time.
lmc_set_axis_handler('XboxBlack', 0, 15, 1000, function(val, ts) 
  print('Callback for axis - value ' .. val..', ts '..ts)
end)
-- There seems to be a problem with the "axis handler": we can't distinguish up and down.
-- Left: 0
-- Right: 65536
-- Up: about 32 000
-- Down: about 32 000

lmc_set_handler('NumPad',keyboard_log_handler)
