{$$, Point, SelectListView} = require 'atom'
_ = require 'underscore-plus'
PhpCheckstyleBaseView = require './php-checkstyle-base-view'

# View for the sniffer commands
class PhpCheckstyleView extends PhpCheckstyleBaseView

  @checkstyleList = []

  # Initialise the view and register the sniffer command
  initialize: () ->
    super
    @addClass('php-checkstyle-error-view overlay from-top')

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
