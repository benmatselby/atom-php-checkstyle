{View} = require 'atom'

# Status Bar View
# It's actually just above the status bar, as the status bar
# would end up being too crowded
class PhpCheckstyleStatusBarView extends View
  # UI markup
  @content: ->
    @div class: 'tool-panel panel-bottom text-smaller', =>
      @div outlet: 'error', class: 'php-checkstyle-statusbar text-smaller text-error'

  # Initialise the view, registering the cursor moved callback
  initialize: ->
    @checkstyleList = []
    editorView = atom.workspaceView.getActiveView()

  # Process the report data
  #
  # reportList All of the data that has been give, array of {line, message}
  process: (reportList) ->
    atom.workspaceView.prependToBottom(this)
    editorView = atom.workspaceView.getActiveView()
    editorView.on 'cursor:moved', =>
      @render()

    list = []
    for row in reportList
      line = row[0]
      message = row[1]
      list.push({line, message})

    @checkstyleList[editorView.id] = list
    @render()

  # Render the view
  render: () ->
    return unless atom.config.get "php-checkstyle.renderStatusBar"

    editorView = atom.workspaceView.getActiveView()
    return unless @checkstyleList[editorView.id]

    paneItem = atom.workspaceView.getActivePaneItem()
    currentLine = undefined
    if position = paneItem?.getCursorBufferPosition?()
      currentLine = position.row + 1

    @hide()
    for item in @checkstyleList[editorView.id]
      if parseInt(item.line) is currentLine
        @error.text(item.message).show()
        @show()

module.exports = PhpCheckstyleStatusBarView
