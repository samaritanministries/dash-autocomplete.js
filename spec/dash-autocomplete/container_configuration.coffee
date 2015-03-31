describe 'DashAutocomplete.ContainerConfiguration', ->
  class MockWindow
    alert: ->

  class MockCollectionView
    render: ->
    showResults: ->
    showNoResults: ->
    showError: ->

  createContainerConfiguration = (options, mockWindow=new MockWindow()) ->
    defaultedOptions = _.extend({
      el:    'some-el',
      token: 'jnsd8suhnd',
      url: 'https://www.example.com',
      collectionView: new MockCollectionView()
    }, options)

    new DashAutocomplete.ContainerConfiguration(defaultedOptions, mockWindow)

  describe 'accessing the data', ->
    it 'returns the token', ->
      token = '6hfnms9s7sbsdfii3'
      containerParameters = createContainerConfiguration(token: token)

      params = containerParameters.configuration()

      expect(params.token).toEqual(token)

    it 'returns the collectionView', ->
      collectionView = {}

      containerParameters = createContainerConfiguration(collectionView: collectionView)

      params = containerParameters.configuration()

      expect(params.collectionView).toEqual(collectionView)

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

    it 'validates that the collection view responds to render', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')
      collectionView = new MockCollectionView()
      collectionView.render = undefined

      containerParameters = createContainerConfiguration(collectionView: collectionView, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "collectionView" must implement "render".')

    it 'validates that the collection view responds to showResults', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')
      collectionView = new MockCollectionView()
      collectionView.showResults = undefined

      containerParameters = createContainerConfiguration(collectionView: collectionView, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "collectionView" must implement "showResults".')

    it 'validates that the collection view responds to showNoResults', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')
      collectionView = new MockCollectionView()
      collectionView.showNoResults = undefined

      containerParameters = createContainerConfiguration(collectionView: collectionView, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "collectionView" must implement "showNoResults".')

    it 'validates that the collection view responds to showError', ->
      mockWindow = new MockWindow()
      alertSpy = spyOn(mockWindow, 'alert')
      collectionView = new MockCollectionView()
      collectionView.showError = undefined

      containerParameters = createContainerConfiguration(collectionView: collectionView, mockWindow)

      params = containerParameters.configuration()

      expect(alertSpy).toHaveBeenCalledWith('the "collectionView" must implement "showError".')

