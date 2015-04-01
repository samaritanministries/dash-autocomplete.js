describe 'Rendering search results', ->
  class CollectionView extends Backbone.View
    render: ->
      @$el.html('Collection View Template')
      @

    showNoResults: ->
    showError: ->
    showResults: (data) ->
      collection = new Backbone.Collection(data)
      collection.each((model) => @$el.append(model.get('task_name')))

  it 'renders search results, and toggles spinner before request completes', ->
    jasmine.clock().install()
    setFixtures('<div data-id="test"></div>')

    sandboxUrl = 'https://sandbox.smchcn.net/smi/api/TaskItems/search'
    server = sinon.fakeServer.create()
    taskJson = [{"id": "1", "task_name": "First Task"}, {"id": "2", "task_name": "Second Task"}]
    server.respondWith("POST", sandboxUrl, [200, { "Content-Type": "application/json" }, JSON.stringify(taskJson)])

    configs = new DashAutocomplete.ContainerConfiguration
      token: 'asdfdsf'
      el: $('[data-id=test]')
      url: sandboxUrl
      resultsView: new CollectionView()
    .configuration()

    containerView = new DashAutocomplete.ContainerView(configs).render()

    expect(containerView.$el).toContainText('Collection View Template')

    $('[data-id=text-input]').val('test').keyup()
    jasmine.clock().tick(111111000000) #this is ridiculous, but I can't get the debounce to time properly

    expect(containerView.$('[data-id=spinner-container]')).not.toBeEmpty()
    server.respond()
    expect(containerView.$('[data-id=spinner-container]')).toBeEmpty()

    expect(containerView.$el).toContainText('First Task')
    expect(containerView.$el).toContainText('Second Task')

    jasmine.clock().uninstall()

