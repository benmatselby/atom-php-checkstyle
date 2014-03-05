{Subscriber} = require 'emissary'
commands = require './commands'

# Main controller class
class PhpCheckstyle

  Subscriber.includeInto(this)

  # Instantiate the views
  constructor: (listView, fixerView)->
    @listView = listView
    @fixerView = fixerView
    atom.workspaceView.command "php-checkstyle:sniff-this-file", => @sniffFile()
    atom.workspaceView.command "php-checkstyle:fix-this-file", => @fixFile()

    if atom.config.get("php-checkstyle.shouldExecuteOnSave") is true
      atom.project.eachBuffer (buffer) =>
        @subscribe buffer, 'saved', => @sniffFile()

  # Sniff the open file with all of the commands we have
  sniffFile: ->
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

    shell.execute (err, stdout, stderr) =>
      @listView.display err, stdout, stderr, shellCommands

    editorView.on 'editor:display-updated', =>
      @listView.renderGutter self.gutter

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

    fixer = new commands.CommandPhpcsFixer(editor.getPath(), config)
    command = new commands.Shell([fixer])

    command.execute (err, stdout, stderr) =>
      @fixerView.display err, stdout, stderr, fixer

module.exports = PhpCheckstyle
