describe 'DashAutocomplete.ContainerView', ->
  class CollectionView extends Backbone.View
    template: 'collection view template'
    render: ->
      @$el.html(@template)
      @

  containerView = (opts) ->
    defaultedOpts = _.extend(collectionView: new CollectionView(), opts)
    new DashAutocomplete.ContainerView(defaultedOpts)

  it 'renders itself inside of the el', ->
    setFixtures("<div id='test'></div>")
    view = containerView(el: $('#test'))

    view.render()

    expect($('#test')).not.toBeEmpty()

  it 'renders the collectionView', ->
    collectionView = new CollectionView()
    view = containerView(collectionView: collectionView)

    view.render()

    expect(view.$el).toContainHtml(collectionView.template)

  it 'renders the search input', ->
    view = containerView()

    view.render()

    expect(view.$el).toContainHtml(new DashAutocomplete.SearchInput.View().render().el)

