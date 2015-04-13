describe 'DashAutocomplete.SearchParameters', ->

  searchParameters = (options) ->
    new DashAutocomplete.SearchParameters(options)

  it 'parameterizes the query', ->
    params = searchParameters
      searchValue: 'Hello'
      currentPage: 10
      itemsPerPage: 25

    expect(JSON.parse(params.toJSON()).items_per_page).toEqual(25)

  it 'has a search_string', ->
    params = searchParameters
      searchValue: 'Hello'

    data = params.paramData()

    expect(data.search_string).toEqual('Hello')

  it 'defaults the search_string to an empty string', ->
    params = searchParameters({})

    data = params.paramData()
    expect(data.search_string).toEqual('')

  it 'has a current_page', ->
    params = searchParameters
      currentPage: 3

    data = params.paramData()
    expect(data.current_page).toEqual(3)

  it 'defaults the current_page to 1', ->
    params = searchParameters({})

    data = params.paramData()
    expect(data.current_page).toEqual(1)

  it 'has items_per_page', ->
    params = searchParameters
      itemsPerPage: 40

    data = params.paramData()
    expect(data.items_per_page).toEqual(40)

  it 'defaults items_per_page to 10', ->
    params = searchParameters({})

    data = params.paramData()
    expect(data.items_per_page).toEqual(10)

  it 'defaults sort_order to an empty object', ->
    params = searchParameters({})

    data = params.paramData()
    expect(data.sort_order).toEqual([])

  it 'defaults filters to an empty object', ->
    params = searchParameters({})

    data = params.paramData()
    expect(data.filters).toEqual([])

  it 'has a filter string', ->
    params = searchParameters
      filterValue: "123"
      filterName: "thename"

    data = params.paramData()
    expect(data.filters[0].thename).toEqual("123")

  it 'does not include the filter if the value is missing', ->
    params = searchParameters
      filterName: "thename"

    data = params.paramData()
    expect(data.filters.thename).not.toBeDefined()

