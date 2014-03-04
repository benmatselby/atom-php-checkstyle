{$$, Point, SelectListView} = require 'atom'
commands = require './commands'
PhpCheckstyleBaseView = require './php-checkstyle-base-view'

# View for the php-cs-fixer commands
class PhpCsFixerView extends PhpCheckstyleBaseView

  # Initialise the view and register the command we need
  initialize: () ->
    super
    @addClass('php-checkstyle-error-view overlay from-top')

  # Get the error list from the command and display the result
  #
  # err      Any errors occured via exec
  # stdout   Overall standard output
  # stderr   Overall standard errors
  # command  The fixer command
  display: (err, stdout, stderr, command) ->
    report = command.process(err, stdout, stderr)

    list = []
    if report.length > 0
      for reportItem in report
        line = reportItem[0]
        message = reportItem[1]
        listItem = {line, message}
        list.push(listItem)
    else
      line = 0
      message = 'Nothing to fix'
      listItem = {line, message}
      list.push(listItem)

    @setItems(list)
    @storeFocusedElement()
    atom.workspaceView.append(this)
    @focusFilterEditor()

module.exports = PhpCsFixerView
