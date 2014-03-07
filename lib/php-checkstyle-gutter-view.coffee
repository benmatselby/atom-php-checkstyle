# Gutter view for the plugin
class PhpCheckstyleGutterView

  # Instantiation
  constructor: ->
    @checkstyleList = []

  # Process the report data
  #
  # reportList The list of errors from the reports
  process: (reportList) ->
    return unless atom.config.get "php-checkstyle.renderGutterMarks"

    editorView = atom.workspaceView.getActiveView()

    gutterList = []
    for row in reportList
      line = row[0]
      gutterList.push(line)

    @checkstyleList[editorView.id] = gutterList
    @render()

  # Render said gutter
  render: ->
    return unless atom.config.get "php-checkstyle.renderGutterMarks"

    editorView = atom.workspaceView.getActiveView()
    return unless @checkstyleList[editorView.id]

    gutter = editorView.gutter
    gutter.removeClassFromAllLines('php-checkstyle-sniff-error')

    for line in @checkstyleList[editorView.id]
      gutter.addClassToLine(line - 1, 'php-checkstyle-sniff-error')

module.exports = PhpCheckstyleGutterView
