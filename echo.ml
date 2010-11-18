let echo t =
  while true do
    t#send t#read
  done

