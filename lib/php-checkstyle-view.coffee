{$$, Point, SelectListView} = require 'atom'
commands = require './commands'

# Sniffer view
class PhpCheckstyleView extends SelectListView

    # Initialise the view and register the sniffer command
    initialize: (serializeState) ->
        atom.workspaceView.command "php-checkstyle:sniff-this-file", => @sniffThisFile()
        super
        @addClass('php-checkstyle-error-view overlay from-top')

    #
    getFilterKey: ->
        'filterText'

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

    # Sniff the open file with all of the commands we have
    sniffThisFile: ->
        editor = atom.workspace.getActiveEditor()

        unless editor.getGrammar().scopeName is 'text.html.php'
            console.warn "Cannot run for non php files"
            return

        linter = new commands.CommandLinter(editor.getPath(), {
            'executablePath': atom.config.get "php-checkstyle.phpPath"
        })
        phpcs = new commands.CommandPhpcs(editor.getPath(), {
            'executablePath': atom.config.get("php-checkstyle.phpcsExecutablePath"),
            'standard': atom.config.get("php-checkstyle.phpcsStandard"),
            'warnings': atom.config.get("php-checkstyle.phpcsDisplayWarnings")
        })
        messDetector= new commands.CommandMessDetector(editor.getPath(), {
            'executablePath': atom.config.get("php-checkstyle.phpmdExecutablePath"),
            'ruleSets': atom.config.get("php-checkstyle.phpmdRuleSets")
        })

        shellCommands = [linter, phpcs, messDetector]
        shell = new commands.Shell(shellCommands)
        self = this
        shell.execute (err, stdout, stderr) ->
            self.display err, stdout, stderr, shellCommands

    # Get the error list from the command and display the result
    # @param err           Any errors occured via exec
    # @param stdout        Overall standard output
    # @param stderr        Overall standard errors
    # @param shellCommands The command objects we will interrogate for data
    display: (err, stdout, stderr, shellCommands) ->
        editor = atom.workspace.getActiveEditor()

        reportList = []
        for command in shellCommands
            commandReportList = command.process(err, stdout, stderr)

            for listItem in commandReportList
                reportList.push listItem

        attributes = class: 'php-checkstyle-error'
        checkstyleList = []
        for row in reportList
            line = row[0]
            message = '(' + line + ') ' + row[1]
            range = [[line, 0], [line, 0]]

            checkstyleError = {line, message}
            checkstyleList.push(checkstyleError)

        @setItems(checkstyleList)
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

module.exports = PhpCheckstyleView
