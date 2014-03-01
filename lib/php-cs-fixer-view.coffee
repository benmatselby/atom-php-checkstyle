{$$, Point, SelectListView} = require 'atom'
commands = require './commands'

class PhpCsFixerView extends SelectListView
    # Initialise the view and register the command we need
    initialize: (serializeState) ->
        atom.workspaceView.command "php-checkstyle:fix-this-file", => @fixThisFile()
        super
        @addClass('php-checkstyle-error-view overlay from-top')

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    #
    viewForItem: (checkstyleError) ->
        checkstyleErrorRow = checkstyleError.line
        checkstyleErrorLocation = "untitled:#{checkstyleErrorRow + 1}"
        lineText = checkstyleError.message

        $$ ->
          if lineText
            @li class: 'php-checkstyle-error two-lines', =>
              @div checkstyleError, class: 'primary-line'
              @div lineText, class: 'secondary-line line-text'
          else
            @li class: 'php-checkstyle-error', =>
              @div checkstyleError, class: 'primary-line'

    # Fix the open file
    fixThisFile: ->
        editor = atom.workspace.getActiveEditor()

        unless editor.getGrammar().scopeName is 'text.html.php' or 'source.php'
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

        list = []
        if report.length > 0
            for reportItem in report
                line = reportItem[0]
                message = reportItem[1]
                listItem = {line, message}
                list.push(listItem)
        else
            line = 0
            message = 'Nothing to fix'
            listItem = {line, message}
            list.push(listItem)

        @setItems(list)
        @storeFocusedElement()
        atom.workspaceView.append(this)
        @focusFilterEditor()

    # Confirmed location
    # @param item The item that has been selected by the user
    confirmed: (item) ->
        editorView = atom.workspaceView.getActiveView()
        position = new Point(parseInt(item.line - 1))
        editorView.scrollToBufferPosition(position, center: true)
        editorView.editor.setCursorBufferPosition(position)
        editorView.editor.moveCursorToFirstCharacterOfLine()


module.exports = PhpCsFixerView
