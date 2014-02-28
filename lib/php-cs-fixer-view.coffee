{View} = require 'atom'
commands = require './commands'

class PhpCsFixerView extends View
    @content: ->
        @div class: 'php-checkstyle-php-cs-fixer overlay from-top', =>

    initialize: (serializeState) ->
        atom.workspaceView.command "php-checkstyle:fix-this-file", => @fixThisFile()

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @detach()

    # Fix the open file
    fixThisFile: ->
        editor = atom.workspace.getActiveEditor()

        unless editor.getGrammar().scopeName is 'text.html.php'
            console.warn "Cannot run for non php files"
            return

        executablePath = atom.config.get "php-checkstyle.phpcsFixerExecutablePath"
        level =  atom.config.get "php-checkstyle.phpcsFixerLevel"

        config = {
                'executablePath': executablePath,
                'level': level
            }

        fixer = new commands.CommandPhpcsFixer(editor.getPath(), config)
        command = new commands.Shell([fixer])
        self = this
        command.execute (err, stdout, stderr) ->
            self.display err, stdout, stderr, fixer

    # Get the error list from the command and display the result
    display: (err, stdout, stderr, command) ->
        report = command.process(err, stdout, stderr)
        # for row in report
            # console.log row

module.exports = PhpCsFixerView
