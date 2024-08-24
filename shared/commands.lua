Commands = {}

Commands.help = function()
    return "Available commands: help, clear, exit"
end

Commands.clear = function()
    return ""
end

Commands.exit = function()
    return "Exiting ..."
end

Commands.execute = function(command, args, args2)
    if Commands[command] then
        return Commands[command](args, args2)
    else
        return "Command not found: " .. command
    end
end