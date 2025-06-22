function scrcpy_control
    nohup scrcpy -Sw --keyboard=uhid --power-off-on-close > /dev/null 2>&1 &
end

