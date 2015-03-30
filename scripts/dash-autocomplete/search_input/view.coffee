namespace('DashAutocomplete.SearchInput')

class DashAutocomplete.SearchInput.View extends Backbone.View
  template: DashAutocompleteJST['scripts/dash-autocomplete/search_input/template.ejs']

  initialize: (@options) ->

  events:
    'keyup [data-id=text-input]' : 'executeCallbackIfTextInputHasChanged'

  render: ->
    @$el.html(@template)
    @

  executeCallbackIfTextInputHasChanged: ->
    if @hasTextInputChanged()
      @_lastTextInputValue = @getTextInputValue()
      @executeCallback()

  hasTextInputChanged: ->
    @getTextInputValue() != @lastTextInputValue()

  lastTextInputValue: ->
    @_lastTextInputValue || ''

  executeCallback: ->
    @options.callback(@getTextInputValue())

  getTextInputValue: ->
    @$('[data-id=text-input]').val()

