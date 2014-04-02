# Gutter view for the plugin
class PhpCheckstyleGutterView

  # Instantiation
  constructor: ->
    @checkstyleList = []
    @gutterStyles = ['php-checkstyle-sniff-error', 'php-checkstyle-sniff-warning', 'php-checkstyle-report-phpcs', 'php-checkstyle-report-phpmd', 'php-checkstyle-report-lint']

  # Process the report data
  #
  # reportList The list of errors from the reports
  process: (reportList) ->
    return unless atom.config.get "php-checkstyle.renderGutterMarks"

    editorView = atom.workspaceView.getActiveView()

    @checkstyleList[editorView.id] = reportList
    @render()

  # Render said gutter
  render: ->
    return unless atom.config.get "php-checkstyle.renderGutterMarks"

    editorView = atom.workspaceView.getActiveView()
    return unless @checkstyleList[editorView.id]

    gutter = editorView.gutter

    for gutterStyle in @gutterStyles
      gutter.removeClassFromAllLines(gutterStyle)

    for line in @checkstyleList[editorView.id]
      gutter.addClassToLine(line[0] - 1, line[2])

module.exports = PhpCheckstyleGutterView
