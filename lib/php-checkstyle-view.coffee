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
  # reportList The list of errors from the reports
  process: (reportList) ->
    editorView = atom.workspaceView.getActiveView()
    @checkstyleList = []
    fileList = []
    for row in reportList
      line = row[0]
      message = '(' + line + ') ' + _.unescape(row[1])
      checkstyleError = {line, message}
      fileList.push(checkstyleError)

    @checkstyleList[editorView.id] = fileList
    @setItems(fileList)

    if fileList.length == 0
      console.log "[php-checkstyle] File is clean"
      return

    @storeFocusedElement()
    atom.workspaceView.append(this)
    @focusFilterEditor()

module.exports = PhpCheckstyleView
