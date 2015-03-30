namespace('DashAutocomplete')

class DashAutocomplete.SearchParameters
  constructor: (@options) ->

  paramData: ->
    search_string: @options.searchValue   || ''
    current_page: @options.currentPage    || 1
    items_per_page: @options.itemsPerPage || 10
    sort_order: {}
    filters: @filters()

  toJSON: ->
    JSON.stringify(@paramData())

  filters: ->
    _filters = {}
    if @hasFilter()
      _filters[@options.filterName] = @options.filterValue
    _filters

  hasFilter: ->
    !!@options.filterName && !! @options.filterValue
