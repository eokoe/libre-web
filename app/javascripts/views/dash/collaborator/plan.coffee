#@model.update @planParams  requires
ViewBase = require 'views/base.coffee'
Loading = require 'views/loading.coffee'
PlanModel = require 'models/donor/plan.coffee'
Message = require 'lib/message.coffee'
Alert = require 'views/message.coffee'


module.exports = class extends ViewBase
  el: "section#dash-main"

  template: 'templates/dash/collaborator/plan.eco'

  model: new PlanModel

  ui:
    form: '#form-plan'

  events:
    'submit @ui.form': 'submitForm'
    'click #btn-plan-cancel': 'clickCancelPlan'

  initialize: ->
    @loading = new Loading
    @loading.show()


  submitForm: (event) ->
    event.preventDefault()

    oldValue = @model.get 'amount'
    @model.set 'amount', ($ 'input[name=amount]:checked').val()

    @model.save()
      .done (res) ->
        Message.show
          type: 'success'
          title: 'Sucesso'
          message: 'Seu plano acaba de ser atualizado!'

        setTimeout ->
          document.location = '/app'
        , 500


      .fail (res) ->
        Message.show
          type: 'danger'
          title: 'Ops!'
          message: 'Não foi possível atualizar seu plano!'

    return false


  clickCancelPlan: (event) ->
    event.preventDefault()

    Alert.confirm
      content: 'Tem ceteza que deseja cancelar seu plano?'
      confirm: (event) =>
        event.preventDefault()
        @model.cancelPlan()
          .done (res) =>
            @loading.show()
            @model = new PlanModel
            Alert.success content: 'Plano cancelado!'
            setTimeout ->
              document.location = '/app'
            , 1000

          .fail (res) ->
            Alert.show content: 'Erro - Não foi possível cancelar seu plano no momento!'
        return false

    return false

  render: ->
    @model.set @planParams()
    @model.fetch()
      .done (res) =>
        plan = _.first (plan for plan in (res.user_plan ? []) when plan.canceled is 0)
        if plan? and plan.canceled is 0
          @model.set plan
        super()

      .fail (res) ->
        super {}


  onRender: ->
    setTimeout =>
      @loading.hide()
    , 500


  planParams: (params = {}) ->
    data =
      user_id: @session.get 'user_id'
      api_key: @session.get 'api_key'
      amount:  params.amount ? 0
    return data


  amountParams: (params = {}) ->
    data =
      user_id: @session.get 'user_id'
      api_key: @session.get 'api_key'
      amount:  ($ 'input[name=amount]').val()
    return data


