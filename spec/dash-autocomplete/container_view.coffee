describe 'DashAutocomplete.ContainerView', ->
  class CollectionView extends Backbone.View
    template: 'collection view template'
    render: ->
      @$el.html(@template)
      @

  containerView = (opts) ->
    defaultedOpts = _.extend(resultsView: new CollectionView(), opts)
    new DashAutocomplete.ContainerView(defaultedOpts)

  it 'renders itself inside of the el', ->
    setFixtures("<div id='test'></div>")
    view = containerView(el: $('#test'))

    view.render()

    expect($('#test')).not.toBeEmpty()

  it 'renders the resultsView', ->
    resultsView = new CollectionView()
    view = containerView(resultsView: resultsView)

    view.render()

    expect(view.$el).toContainHtml(resultsView.template)

  it 'renders the search input', ->
    view = containerView()

    view.render()

    expect(view.$el).toContainHtml(new DashAutocomplete.SearchInput.View().render().el)

