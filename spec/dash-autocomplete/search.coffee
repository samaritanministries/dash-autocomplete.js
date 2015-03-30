describe 'DashAutocomplete.Search', ->
  class CollectionView
    showResults: (data) ->
    showNoResults: ->
    showError: (result) ->

  createSearch = (options) ->
    optionsWithDefaults = _.extend({startSpinner: (->), stopSpinner: (->), collectionView: new CollectionView}, options)
    new DashAutocomplete.Search(optionsWithDefaults)

  describe 'searching', ->
    it 'requests with the token in the headers', ->
      ajaxSpy = spyOn(jQuery, 'ajax')
      token = '6ybnjsd83nsdi'
      search = createSearch(token: token)

      search.search()

      expect(ajaxSpy.calls.argsFor(0)[0].headers).toEqual(authorization: "Bearer #{token}")

    it 'changes the data into a query string', ->
      ajaxSpy = spyOn(jQuery, 'ajax')
      search = createSearch()

      search.search('test value')

      expect(ajaxSpy.calls.argsFor(0)[0].data).toEqual('{"search_string":"test value","current_page":1,"items_per_page":10,"sort_order":{},"filters":{}}')

    it 'starts the spinner before the request is made', ->
      startSpinnerSpy = jasmine.createSpy('startSpinner')
      spyOn(jQuery, 'ajax')
      search = createSearch(startSpinner: startSpinnerSpy)

      search.search()

      expect(startSpinnerSpy).toHaveBeenCalled()

    it 'stops the spinner on success', ->
      server = sinon.fakeServer.create()
      stopSpinnerSpy = jasmine.createSpy('stopSpinner')
      search = createSearch(stopSpinner: stopSpinnerSpy)
      server.respondWith("POST", search.url, [200, { "Content-Type": "application/json" }, '[]'])

      search.search()
      server.respond()

      expect(stopSpinnerSpy).toHaveBeenCalled()

    it 'stops the spinner on error', ->
      server = sinon.fakeServer.create()
      stopSpinnerSpy = jasmine.createSpy('stopSpinner')
      search = createSearch(stopSpinner: stopSpinnerSpy)
      server.respondWith("POST", search.url, [500, { "Content-Type": "application/json" }, '[]'])

      search.search()
      server.respond()

      expect(stopSpinnerSpy).toHaveBeenCalled()

    it 'has the collection view render the results', ->
      server = sinon.fakeServer.create()
      collectionView = new CollectionView()
      showResultsSpy = spyOn(collectionView, 'showResults')
      search = createSearch(collectionView: collectionView)
      taskJson = [{"task_id": "1"}, {"task_id": "2"}]
      server.respondWith("POST", search.url, [200, { "Content-Type": "application/json" }, JSON.stringify(taskJson)])

      search.search()
      server.respond()

      expect(showResultsSpy).toHaveBeenCalledWith(taskJson)

    it 'has the collection view render a no results found screen', ->
      server = sinon.fakeServer.create()
      collectionView = new CollectionView()
      showNoResultsSpy = spyOn(collectionView, 'showNoResults')
      search = createSearch(collectionView: collectionView)
      server.respondWith("POST", search.url, [200, { "Content-Type": "application/json" }, '[]'])

      search.search()
      server.respond()

      expect(showNoResultsSpy).toHaveBeenCalled()

    it 'has the collection view render an error screen', ->
      server = sinon.fakeServer.create()
      collectionView = new CollectionView()
      showErrorSpy = spyOn(collectionView, 'showError')
      search = createSearch(collectionView: collectionView)
      server.respondWith("POST", search.url, [500, { "Content-Type": "application/json" }, '[]'])

      search.search()
      server.respond()

      expect(showErrorSpy).toHaveBeenCalled()

