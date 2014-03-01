{$$, Point, SelectListView} = require 'atom'

# Base view for all list based views for the plugin
class PhpCheckstyleBaseView extends SelectListView

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

    # Confirmed location
    # @param item The item that has been selected by the user
    confirmed: (item) ->
        editorView = atom.workspaceView.getActiveView()
        position = new Point(parseInt(item.line - 1))
        editorView.scrollToBufferPosition(position, center: true)
        editorView.editor.setCursorBufferPosition(position)
        editorView.editor.moveCursorToFirstCharacterOfLine()

module.exports = PhpCheckstyleBaseView
