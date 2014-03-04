{$$, Point, SelectListView} = require 'atom'
_ = require 'underscore-plus'
commands = require './commands'
PhpCheckstyleBaseView = require './php-checkstyle-base-view'

# View for the sniffer commands
class PhpCheckstyleView extends PhpCheckstyleBaseView

  @checkstyleList = []

  # Initialise the view and register the sniffer command
  initialize: () ->
    atom.workspaceView.command "php-checkstyle:sniff-this-file", => @sniffThisFile()
    super
    @addClass('php-checkstyle-error-view overlay from-top')

  # Sniff the open file with all of the commands we have
  sniffThisFile: ->
    editor = atom.workspace.getActiveEditor()
    editorView = atom.workspaceView.getActiveView()

    unless editor.getGrammar().scopeName is 'text.html.php' or editor.getGrammar().scopeName is 'source.php'
      console.warn "Cannot run for non php files"
      return

    shellCommands = []

    if atom.config.get("php-checkstyle.shouldExecuteLinter") is true
      linter = new commands.CommandLinter(editor.getPath(), {
        'executablePath': atom.config.get "php-checkstyle.phpPath"
      })
      shellCommands.push(linter)

    if atom.config.get("php-checkstyle.shouldExecutePhpcs") is true
      phpcs = new commands.CommandPhpcs(editor.getPath(), {
        'executablePath': atom.config.get("php-checkstyle.phpcsExecutablePath"),
        'standard': atom.config.get("php-checkstyle.phpcsStandard"),
        'warnings': atom.config.get("php-checkstyle.phpcsDisplayWarnings")
      })
      shellCommands.push(phpcs)

    if atom.config.get("php-checkstyle.shouldExecutePhpmd") is true
      messDetector= new commands.CommandMessDetector(editor.getPath(), {
        'executablePath': atom.config.get("php-checkstyle.phpmdExecutablePath"),
        'ruleSets': atom.config.get("php-checkstyle.phpmdRuleSets")
      })
      shellCommands.push(messDetector)

    shell = new commands.Shell(shellCommands)
    self = this
    shell.execute (err, stdout, stderr) ->
      self.display err, stdout, stderr, shellCommands

    editorView.on 'editor:display-updated', ->
      self.renderGutter self.gutter

  # Get the error list from the command and display the result
  #
  # err           Any errors occured via exec
  # stdout        Overall standard output
  # stderr        Overall standard errors
  # shellCommands The command objects we will interrogate for data
  display: (err, stdout, stderr, shellCommands) ->
    reportList = []
    for command in shellCommands
      commandReportList = command.process(err, stdout, stderr)

      for listItem in commandReportList
        reportList.push listItem

    editorView = atom.workspaceView.getActiveView()
    @checkstyleList = []
    fileList = []
    for row in reportList
      line = row[0]
      message = '(' + line + ') ' + _.unescape(row[1])
      checkstyleError = {line, message}
      fileList.push(checkstyleError)

    @checkstyleList[editorView.id] = fileList
    @renderGutter()
    @setItems(fileList)
    @storeFocusedElement()
    atom.workspaceView.append(this)
    @focusFilterEditor()

  # Render items into the gutter
  renderGutter: () ->
    return unless atom.config.get "php-checkstyle.renderGutterMarks"
    editorView = atom.workspaceView.getActiveView()
    return unless @checkstyleList[editorView.id]

    gutter = editorView.gutter
    gutter.removeClassFromAllLines('php-checkstyle-sniff-error')
    for error in @checkstyleList[editorView.id]
      gutter.addClassToLine(error.line - 1, 'php-checkstyle-sniff-error')

module.exports = PhpCheckstyleView
