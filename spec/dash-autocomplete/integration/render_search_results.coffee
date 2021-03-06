describe 'Rendering search results', ->
  class CollectionView extends Backbone.View
    render: ->
      @$el.html('Collection View Template')
      @

    showNoResults: ->
    showError: ->
    showResults: (data) ->
      @render()
      collection = new Backbone.Collection(data)
      collection.each((model) => @$el.append(model.get('task_name')))
    searchCriteriaCleared: ->

  beforeEach ->
    jasmine.clock().install()
    setFixtures('<div data-id="test"></div>')
    @sandboxUrl = 'https://sandbox.smchcn.net/smi/api/TaskItems/search'
    @server = sinon.fakeServer.create()

    configs = new DashAutocomplete.ContainerConfiguration
      token: 'asdfdsf'
      el: $('[data-id=test]')
      url: @sandboxUrl
      resultsView: new CollectionView()
    .configuration()

    @containerView = new DashAutocomplete.ContainerView(configs).render()

  stubSearchResults = (server, response) ->
    server.respondWith(
      'POST',
      'https://sandbox.smchcn.net/smi/api/TaskItems/search',
      [200, { 'Content-Type': 'application/json' }, JSON.stringify(response)]
    )

  waitForSearchToFinish = ->
    jasmine.clock().tick(111111000000) #this is ridiculous, but I can't get the debounce to time properly

  afterEach ->
    jasmine.clock().uninstall()

  it 'renders the container view', ->
    expect(@containerView.$el).toContainText('Collection View Template')

  it 'renders search results', ->
    stubSearchResults(@server, [{
      'id': '1',
      'task_name': 'First Task'
    }, {
      'id': '2',
      'task_name': 'Second Task'
    }])

    $('[data-id=text-input]').val('test').keyup()
    waitForSearchToFinish()
    @server.respond()

    expect(@containerView.$el).toContainText('First Task')
    expect(@containerView.$el).toContainText('Second Task')

  it 'renders search results, and toggles spinner before request completes', ->
    stubSearchResults(@server, [])

    $('[data-id=text-input]').val('test').keyup()
    waitForSearchToFinish()

    spinnerContainer = @containerView.$('[data-id=spinner-container]')
    expect(spinnerContainer).toHaveClass("dash-spinner")
    @server.respond()
    expect(spinnerContainer).not.toHaveClass("dash-spinner")
