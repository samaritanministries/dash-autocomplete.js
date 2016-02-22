describe "DashAutocomplete.Search", ->
  class CollectionView
    showResults: (data) ->
    showNoResults: ->
    showError: (result) ->
    searchCriteriaCleared: ->

  createSearch = (options) ->
    optionsWithDefaults = _.extend({
      startSpinner: (->),
      stopSpinner: (->),
      resultsView: new CollectionView
    }, options)
    new DashAutocomplete.Search(optionsWithDefaults)

  describe "searching", ->
    it "requests with the token in the headers", ->
      ajaxSpy = spyOn(jQuery, "ajax")
      token = "6ybnjsd83nsdi"
      search = createSearch(token: token)

      search.search("test value")

      expect(ajaxSpy.calls.argsFor(0)[0].headers).toEqual(authorization: "Bearer #{token}")

    it "changes the data into a query string", ->
      ajaxSpy = spyOn(jQuery, "ajax")
      search = createSearch()

      search.search("test value")

      expect(JSON.parse(ajaxSpy.calls.argsFor(0)[0].data)).toEqual
        current_page: 1
        filters: []
        items_per_page: 10
        search_string: "test value"
        sort_order: []

    it "starts the spinner before the request is made", ->
      startSpinnerSpy = jasmine.createSpy("startSpinner")
      spyOn(jQuery, "ajax")
      search = createSearch(startSpinner: startSpinnerSpy)

      search.search("test value")

      expect(startSpinnerSpy).toHaveBeenCalled()

    it "stops the spinner on success", ->
      server = sinon.fakeServer.create()
      stopSpinnerSpy = jasmine.createSpy("stopSpinner")
      search = createSearch(stopSpinner: stopSpinnerSpy)
      server.respondWith("POST", search.url, [200, { "Content-Type": "application/json" }, "[]"])

      search.search("test value")
      server.respond()

      expect(stopSpinnerSpy).toHaveBeenCalled()

    it "stops the spinner on error", ->
      server = sinon.fakeServer.create()
      stopSpinnerSpy = jasmine.createSpy("stopSpinner")
      search = createSearch(stopSpinner: stopSpinnerSpy)
      server.respondWith("POST", search.url, [500, { "Content-Type": "application/json" }, "[]"])

      search.search("test value")
      server.respond()

      expect(stopSpinnerSpy).toHaveBeenCalled()

    it "has the results view render the results", ->
      server = sinon.fakeServer.create()
      resultsView = new CollectionView()
      showResultsSpy = spyOn(resultsView, "showResults")
      search = createSearch(resultsView: resultsView)
      taskJson = [{"task_id": "1"}, {"task_id": "2"}]
      server.respondWith("POST", search.url, [200, { "Content-Type": "application/json" }, JSON.stringify(taskJson)])

      search.search("test value")
      server.respond()

      expect(showResultsSpy).toHaveBeenCalledWith(taskJson)

    it "has the results view render a no results found screen", ->
      server = sinon.fakeServer.create()
      resultsView = new CollectionView()
      showNoResultsSpy = spyOn(resultsView, "showNoResults")
      search = createSearch(resultsView: resultsView)
      server.respondWith("POST", search.url, [200, { "Content-Type": "application/json" }, "[]"])

      search.search("test value")
      server.respond()

      expect(showNoResultsSpy).toHaveBeenCalled()

    it "lets the collection view know that the search criteria was cleared", ->
      server = sinon.fakeServer.create()
      resultsView = new CollectionView()
      showNoResultsSpy = spyOn(resultsView, "showNoResults")
      searchCriteriaClearedSpy = spyOn(resultsView, "searchCriteriaCleared")
      search = createSearch(resultsView: resultsView)
      server.respondWith("POST", search.url, [200, { "Content-Type": "application/json" }, "[]"])

      search.search("")
      server.respond()

      expect(searchCriteriaClearedSpy).toHaveBeenCalled()

    it "does not trigger an additional callback when the search criteria was cleared", ->
      server = sinon.fakeServer.create()
      resultsView = new CollectionView()
      showNoResultsSpy = spyOn(resultsView, "showNoResults")
      searchCriteriaClearedSpy = spyOn(resultsView, "searchCriteriaCleared")
      search = createSearch(resultsView: resultsView)
      server.respondWith("POST", search.url, [200, { "Content-Type": "application/json" }, "[]"])

      search.search("")
      server.respond()

      expect(showNoResultsSpy).not.toHaveBeenCalled()

    it "shows results when the search criteria was cleared and there are results", ->
      server = sinon.fakeServer.create()
      resultsView = new CollectionView()
      showResultsSpy = spyOn(resultsView, "showResults")
      searchCriteriaClearedSpy = spyOn(resultsView, "searchCriteriaCleared")
      search = createSearch(resultsView: resultsView)
      server.respondWith("POST", search.url, [200, { "Content-Type": "application/json" }, JSON.stringify([{id: 123}])])

      search.search("")
      server.respond()

      expect(showResultsSpy).toHaveBeenCalled()

    it "has the collection view render an error screen", ->
      server = sinon.fakeServer.create()
      resultsView = new CollectionView()
      showErrorSpy = spyOn(resultsView, "showError")
      search = createSearch(resultsView: resultsView)
      server.respondWith("POST", search.url, [500, { "Content-Type": "application/json" }, "[]"])

      search.search("test value")
      server.respond()

      expect(showErrorSpy).toHaveBeenCalled()
