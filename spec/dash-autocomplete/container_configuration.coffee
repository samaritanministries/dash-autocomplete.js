describe 'DashAutocomplete.ContainerConfiguration', ->
  class MockWindow
    alert: ->

  class MockCollectionView
    render: ->
    showResults: ->
    showNoResults: ->
    showError: ->
    searchCriteriaCleared: ->

  createContainerConfiguration = (options, mockWindow=new MockWindow()) ->
    defaultedOptions = _.extend({
      el:    'some-el',
      token: 'jnsd8suhnd',
      url: 'https://www.example.com',
      resultsView: new MockCollectionView()
    }, options)

    new DashAutocomplete.ContainerConfiguration(defaultedOptions, mockWindow)

  describe 'accessing the data', ->
    it 'returns the token', ->
      token = '6hfnms9s7sbsdfii3'
      containerParameters = createContainerConfiguration(token: token)

      params = containerParameters.configuration()

      expect(params.token).toEqual(token)

    it 'returns the resultsView', ->
      resultsView = {}

      containerParameters = createContainerConfiguration(resultsView: resultsView)

      params = containerParameters.configuration()

      expect(params.resultsView).toEqual(resultsView)

    it 'returns the url', ->
      url = 'https://www.example-api.com'

      containerParameters = createContainerConfiguration(url: url)

      params = containerParameters.configuration()

      expect(params.url).toEqual(url)

    it 'returns the el', ->
      setFixtures('<div id="my-test-el"></div>')
      el = $('#my-test-el')

      containerParameters = createContainerConfiguration(el: el)

      params = containerParameters.configuration()

      expect(params.el).toEqual(el)

  describe 'validating the parameters', ->
    it 'alerts the user that the el is required', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')

      containerParameters = createContainerConfiguration(el: undefined, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "el" parameter must be present.')

    it 'validates the presence of the token', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')

      containerParameters = createContainerConfiguration(token: undefined, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "token" parameter must be present.')

    it 'validates the presence of the url', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')

      containerParameters = createContainerConfiguration(url: undefined, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "url" parameter must be present.')

    it 'validates that the resultsView responds to render', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')
      resultsView = new MockCollectionView()
      resultsView.render = undefined

      containerParameters = createContainerConfiguration(resultsView: resultsView, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "resultsView" must implement "render".')

    it 'validates that the resultsView responds to showResults', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')
      resultsView = new MockCollectionView()
      resultsView.showResults = undefined

      containerParameters = createContainerConfiguration(resultsView: resultsView, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "resultsView" must implement "showResults".')

    it 'validates that the resultsView responds to searchCriteriaCleared', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')
      resultsView = new MockCollectionView()
      resultsView.searchCriteriaCleared = undefined

      containerParameters = createContainerConfiguration(resultsView: resultsView, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "resultsView" must implement "searchCriteriaCleared".')

    it 'validates that the resultsView responds to showNoResults', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')
      resultsView = new MockCollectionView()
      resultsView.showNoResults = undefined

      containerParameters = createContainerConfiguration(resultsView: resultsView, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "resultsView" must implement "showNoResults".')

    it 'validates that the resultsView responds to showError', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')
      resultsView = new MockCollectionView()
      resultsView.showError = undefined

      containerParameters = createContainerConfiguration(resultsView: resultsView, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "resultsView" must implement "showError".')
