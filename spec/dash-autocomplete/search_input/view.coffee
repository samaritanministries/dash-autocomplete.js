describe 'DashAutocomplete.SearchInput.View', ->
  searchBar = (callback) ->
    _s = new DashAutocomplete.SearchInput.View
      callback: callback
    _s

  triggerKeyup = (view, value) ->
    view.$("[data-id=text-input]").val(value).keyup()

  it 'calls the callback with the text value on keyup', ->
    callback = jasmine.createSpy('afterKeyupCallback')
    view = searchBar(callback).render()

    triggerKeyup(view, 'test')

    expect(callback).toHaveBeenCalledWith('test')

  it 'will not call the callback if the value has not changed', ->
    callback = jasmine.createSpy('afterKeyupCallback')
    view = searchBar(callback).render()

    triggerKeyup(view, 'test')
    triggerKeyup(view, 'test')

    expect(callback.calls.count()).toEqual(1)

  it 'will not call the callback if the value is empty', ->
    callback = jasmine.createSpy('afterKeyupCallback')
    view = searchBar(callback).render()

    triggerKeyup(view, '')

    expect(callback).not.toHaveBeenCalled()

