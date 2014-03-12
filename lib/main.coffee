PhpCheckstyle = require './php-checkstyle'
PhpCheckstyleView = require './php-checkstyle-view'
PhpCsFixerView = require './php-cs-fixer-view'
PhpCheckstyleGutterView = require './php-checkstyle-gutter-view'
PhpCheckstyleStatusBarView = require './php-checkstyle-statusbar-view'

module.exports =

  configDefaults:
    phpcsExecutablePath: '/usr/bin/phpcs'
    phpcsStandard: 'PSR2'
    phpcsDisplayWarnings: false
    phpcsFixerExecutablePath: '/usr/bin/php-cs-fixer'
    phpcsFixerLevel: 'all'
    phpPath: '/usr/bin/php'
    phpmdExecutablePath: '/usr/bin/phpmd'
    phpmdRuleSets: 'codesize,cleancode,controversial,naming,unusedcode'
    renderGutterMarks: true
    renderStatusBar: true
    renderListView: true
    shouldExecutePhpcs: true
    shouldExecutePhpmd: true
    shouldExecuteLinter: true
    shouldExecuteOnSave: true

  # Activate the plugin
  activate: ->
    listView = new PhpCheckstyleView()
    fixerView = new PhpCsFixerView()
    gutterView = new PhpCheckstyleGutterView()
    statusbarView = new PhpCheckstyleStatusBarView()

    app = new PhpCheckstyle listView, fixerView, gutterView, statusbarView
