namespace('DashAutocomplete')

class DashAutocomplete.Search
  constructor: (@options={}) ->
    @collectionView = @options.collectionView

  debouncedSearch: ->
    _.debounce(
      (
        (searchValue) =>
          @search(searchValue)
      ), 300
    )

  search: (searchValue) ->
    @startSpinner()
    @request(searchValue)

  request: (searchValue) ->
    $.ajax
      url: @options.url
      method: "POST"
      headers:
        "authorization": "Bearer #{@options.token}"
      data: @parameterize(searchValue)
      contentType: "application/json"
      success: (tasksJson) =>
        @successCallback(tasksJson)
      error: (response, statusCode) =>
        @stopSpinner()
        @collectionView.showError(response, statusCode)

  startSpinner: ->
    @options.startSpinner()

  stopSpinner: ->
    @options.stopSpinner()

  parameterize: (searchValue) ->
    new DashAutocomplete.SearchParameters(searchValue: searchValue).toJSON()

  successCallback: (tasksJson) ->
    @stopSpinner()
    if _.isEmpty tasksJson
      @collectionView.showNoResults()
    else
      @collectionView.showResults(tasksJson)

