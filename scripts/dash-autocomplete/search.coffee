namespace('DashAutocomplete')

class DashAutocomplete.Search
  constructor: (@options={}) ->
    @resultsView = @options.resultsView

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
        @successCallback(tasksJson, searchValue)
      error: (response, statusCode) =>
        @stopSpinner()
        @resultsView.showError(response, statusCode)

  startSpinner: ->
    @options.startSpinner()

  stopSpinner: ->
    @options.stopSpinner()

  parameterize: (searchValue) ->
    new DashAutocomplete.SearchParameters(searchValue: searchValue).toJSON()

  successCallback: (tasksJson, searchValue) ->
    @stopSpinner()
    if tasksJson.length > 0
      @resultsView.showResults(tasksJson)
    else if searchValue == ""
      @resultsView.searchCriteriaCleared()
    else
      @resultsView.showNoResults()
