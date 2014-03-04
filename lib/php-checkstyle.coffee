PhpCheckstyleView = require './php-checkstyle-view'
PhpCsFixerView = require './php-cs-fixer-view'

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

  activate: ->
        new PhpCheckstyleView()
        new PhpCsFixerView()
