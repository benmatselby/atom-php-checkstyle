{exec} = require 'child_process'

# Wrapper class for all shell commands
# Provides shelling out commands so it is performed in one place
class Shell

    # Constructor
    # @param @command The shell command we will execute
    constructor: (@command) ->

    # Executor
    # Execute the shell command
    # @param callback The callback once the shell command is complete
    execute: (callback) ->
        console.log "[php-checkstyle]" + @command.getCommand()
        exec @command.getCommand(), callback


# Phpcs command to represent phpcs
class CommandPhpcs

    # Constructor
    # @param @path The path to the file we want to phpcs on
    constructor: (@path) ->

    # Getter for the command to execute
    getCommand: ->
        return "phpcs --standard=PSR2 -n --report=checkstyle " + @path

    # Given the report, now process into workable data
    process: (error, stdout, stderr) ->
        pattern = /.*line="(.+?)" column="(.+?)" severity="(.+?)" message="(.*)" source.*/g
        errorList = []
        while (line = pattern.exec(stdout)) isnt null
            item = [line[1], line[4]]
            errorList.push item
        return errorList

module.exports = {Shell, CommandPhpcs}
