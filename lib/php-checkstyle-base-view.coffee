{$$, Point, SelectListView} = require 'atom'

# Base view for all list based views for the plugin
class PhpCheckstyleBaseView extends SelectListView

  # Renderer for each item in the select list
  # @param item The item in the list view
  viewForItem: (item) ->
    lineText = item.message

    $$ ->
      if lineText
        @li class: 'php-checkstyle-error two-lines', =>
          @div item, class: 'primary-line'
          @div lineText, class: 'secondary-line line-text'
      else
        @li class: 'php-checkstyle-error', =>
          @div item, class: 'primary-line'

  # Confirmed location
  # @param item The item that has been selected by the user
  confirmed: (item) ->
    editorView = atom.workspaceView.getActiveView()
    position = new Point(parseInt(item.line - 1))
    editorView.scrollToBufferPosition(position, center: true)
    editorView.editor.setCursorBufferPosition(position)
    editorView.editor.moveCursorToFirstCharacterOfLine()

  # Get the filter key for filtering the select list
  getFilterKey: ->
    'message'

module.exports = PhpCheckstyleBaseView
