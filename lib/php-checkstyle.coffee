PhpCheckstyleView = require './php-checkstyle-view'

module.exports =

	configDefaults:
	    csExecutablePath: '/usr/bin/phpcs'
	    csStandard: 'PSR-2'

    phpCheckstyleView: null

    activate: (state) ->
        @phpCheckstyleView = new PhpCheckstyleView(state.phpCheckstyleViewState)

    deactivate: ->
        @phpCheckstyleView.destroy()

    serialize: ->
        phpCheckstyleViewState: @phpCheckstyleView.serialize()
