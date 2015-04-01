namespace('DashAutocomplete')

class DashAutocomplete.ContainerView extends Backbone.View
  initialize: (@options) ->

  template: DashAutocompleteJST['scripts/dash-autocomplete/container_view_template.ejs']

  render: ->
    @$el.html(@template)
    @$('[data-id=collection-view-container]').html(@options.resultsView.render().el)
    @$('[data-id=search-view-container]').html(@searchInput().render().el)
    @

  searchInput: ->
    options = _.extend({
      startSpinner: @startSpinner,
      stopSpinner: @stopSpinner
    }, @options)
    new DashAutocomplete.SearchInput.View
      callback: new DashAutocomplete.Search(options).debouncedSearch()

  spinner: ->
    @s ?= new DashSpinner.Spinner(target: @$('[data-id=spinner-container]'))

  startSpinner: =>
    @spinner().spin()
    @$('[data-id=collection-view-container]').hide()

  stopSpinner: =>
    @spinner().stop()
    @$('[data-id=collection-view-container]').show()

