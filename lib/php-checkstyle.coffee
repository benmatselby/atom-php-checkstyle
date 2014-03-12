{Subscriber} = require 'emissary'
commands = require './commands'

# Main controller class
class PhpCheckstyle

  Subscriber.includeInto(this)

  # Instantiate the views
  #
  # listView      The basic sniffer view
  # fixerView     The PHP-CS-Fixer view
  # gutterView    The gutter view
  # statusbarView The status bar view
  constructor: (listView, fixerView, gutterView, statusbarView)->
    @listView = listView
    @fixerView = fixerView
    @gutterView = gutterView
    @statusbarView = statusbarView

    atom.workspaceView.command "php-checkstyle:sniff-this-file", => @sniffFile()
    atom.workspaceView.command "php-checkstyle:fix-this-file", => @fixFile()

    if atom.config.get("php-checkstyle.shouldExecuteOnSave") is true
      atom.project.eachBuffer (buffer) =>
        @subscribe buffer, 'saved', => @sniffFile()

  # Sniff the open file with all of the commands we have
  sniffFile: ->
    editor = atom.workspace.getActiveEditor()
    editorView = atom.workspaceView.getActiveView()
    @checkstyleList= []

    unless editor.getGrammar().scopeName is 'text.html.php' or editor.getGrammar().scopeName is 'source.php'
      console.warn "Cannot run for non php files"
      return

    shellCommands = []

    filePath = editor.getPath().replace(/([\'\s])/g, "\\$1")

    if atom.config.get("php-checkstyle.shouldExecuteLinter") is true
      linter = new commands.CommandLinter(filePath, {
        'executablePath': atom.config.get "php-checkstyle.phpPath"
      })
      shellCommands.push(linter)

    if atom.config.get("php-checkstyle.shouldExecutePhpcs") is true
      phpcs = new commands.CommandPhpcs(filePath, {
        'executablePath': atom.config.get("php-checkstyle.phpcsExecutablePath"),
        'standard': atom.config.get("php-checkstyle.phpcsStandard"),
        'warnings': atom.config.get("php-checkstyle.phpcsDisplayWarnings")
      })
      shellCommands.push(phpcs)

    if atom.config.get("php-checkstyle.shouldExecutePhpmd") is true
      messDetector= new commands.CommandMessDetector(filePath, {
        'executablePath': atom.config.get("php-checkstyle.phpmdExecutablePath"),
        'ruleSets': atom.config.get("php-checkstyle.phpmdRuleSets")
      })
      shellCommands.push(messDetector)

    shell = new commands.Shell(shellCommands)

    shell.execute (err, stdout, stderr) =>
      reportList = []
      for command in shellCommands
        commandReportList = command.process(err, stdout, stderr)

        for listItem in commandReportList
          reportList.push listItem

      @checkstyleList[editorView.id] = reportList

      @listView.process reportList
      @gutterView.process reportList
      @statusbarView.process reportList

    editorView.on 'editor:display-updated', =>
      @gutterView.render()

  # Fix the open file
  fixFile: ->
    editor = atom.workspace.getActiveEditor()

    unless editor.getGrammar().scopeName is 'text.html.php' or editor.getGrammar().scopeName is 'source.php'
      console.warn "Cannot run for non php files"
      return

    executablePath = atom.config.get "php-checkstyle.phpcsFixerExecutablePath"
    level =  atom.config.get "php-checkstyle.phpcsFixerLevel"

    config = {
      'executablePath': executablePath,
      'level': level
    }

    filePath = editor.getPath().replace(/([\'\s])/g, "\\$1")

    fixer = new commands.CommandPhpcsFixer(filePath, config)
    command = new commands.Shell([fixer])

    command.execute (err, stdout, stderr) =>
      report = fixer.process(err, stdout, stderr)
      @fixerView.process report

module.exports = PhpCheckstyle
