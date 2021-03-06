# requires
ViewBase = require 'views/base.coffee'
LoadingView = require 'views/loading.coffee'


module.exports = class UserFormView extends ViewBase
  el: "section#dash-main"

  # setting template
  template: 'templates/dash/journalist/form.eco'

  # loading component
  loading: new LoadingView

  # event on render
  onRender: ->
    # FIXME: fadein()
    @loading.hide()
