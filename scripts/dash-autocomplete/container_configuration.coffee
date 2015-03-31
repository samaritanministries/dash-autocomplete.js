namespace('DashAutocomplete')

class DashAutocomplete.ContainerConfiguration
  constructor: (@options, @window=window) ->

  configuration: ->
    @alertValidationErrors()

    token: @options.token
    collectionView: @options.collectionView
    url: @options.url
    el: @options.el

  alertValidationErrors: ->
    errors = []
    if _.isUndefined @options.token
      errors.push('the "token" parameter must be present.')
    if _.isUndefined @options.url
      errors.push('the "url" parameter must be present.')
    if !@doesCollectionViewImplement('render')
      errors.push('the "collectionView" must implement "render".')
    if !@doesCollectionViewImplement('showResults')
      errors.push('the "collectionView" must implement "showResults".')
    if !@doesCollectionViewImplement('showNoResults')
      errors.push('the "collectionView" must implement "showNoResults".')
    if !@doesCollectionViewImplement('showError')
      errors.push('the "collectionView" must implement "showError".')

    @window.alert(errors.join(' ')) unless _.isEmpty errors

  doesCollectionViewImplement: (functionName) ->
    !_.isUndefined @options.collectionView[functionName]

