PhpCheckstyleView = require './php-checkstyle-view'

module.exports =
    phpCheckstyleView: null

    activate: (state) ->
        @phpCheckstyleView = new PhpCheckstyleView(state.phpCheckstyleViewState)

    deactivate: ->
        @phpCheckstyleView.destroy()

    serialize: ->
        phpCheckstyleViewState: @phpCheckstyleView.serialize()
