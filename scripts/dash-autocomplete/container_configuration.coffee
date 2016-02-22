namespace('DashAutocomplete')

class DashAutocomplete.ContainerConfiguration
  constructor: (@options, @window=window) ->

  configuration: ->
    @alertValidationErrors()

    token: @options.token
    resultsView: @options.resultsView
    url: @options.url
    el: @options.el

  alertValidationErrors: ->
    errors = []
    if _.isUndefined @options.el
      errors.push('the "el" parameter must be present.')
    if _.isUndefined @options.token
      errors.push('the "token" parameter must be present.')
    if _.isUndefined @options.url
      errors.push('the "url" parameter must be present.')
    if !@doesResultsViewImplement('render')
      errors.push('the "resultsView" must implement "render".')
    if !@doesResultsViewImplement('showResults')
      errors.push('the "resultsView" must implement "showResults".')
    if !@doesResultsViewImplement('showNoResults')
      errors.push('the "resultsView" must implement "showNoResults".')
    if !@doesResultsViewImplement('searchCriteriaCleared')
      errors.push('the "resultsView" must implement "searchCriteriaCleared".')
    if !@doesResultsViewImplement('showError')
      errors.push('the "resultsView" must implement "showError".')

    @window.alert(errors.join(' ')) unless _.isEmpty errors

  doesResultsViewImplement: (functionName) ->
    !_.isUndefined @options.resultsView[functionName]
