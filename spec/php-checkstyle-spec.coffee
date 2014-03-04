{WorkspaceView} = require 'atom'
PhpCheckstyle = require '../lib/php-checkstyle'

describe "PHP Checkstyle", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView

  it 'should register the sniffer command', ->
    spyOn(atom.workspaceView, 'command')
    listView = {}
    fixerView = {}
    app = new PhpCheckstyle listView, fixerView
    expect(atom.workspaceView.command).toHaveBeenCalled()
