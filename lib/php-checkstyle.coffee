PhpCheckstyleView = require './php-checkstyle-view'

module.exports =

    configDefaults:
        phpcsExecutablePath: '/usr/bin/phpcs'
        phpcsStandard: 'PSR2'
        phpcsDisplayWarnings: false

    phpCheckstyleView: null

    activate: (state) ->
        @phpCheckstyleView = new PhpCheckstyleView(state.phpCheckstyleViewState)

    deactivate: ->
        @phpCheckstyleView.destroy()

    serialize: ->
        phpCheckstyleViewState: @phpCheckstyleView.serialize()
