# DashAutocomplete

# Releasing a New Version

Steps to release a new version:

1. Update the [change log](/CHANGELOG.md).
2. Run `./bower_deploy.sh`

# Setup
* install node/npm
* npm install
* bower install
* npm install testem -g

# Tests
Run ```testem```

# Run the demo
  * bower install
  * npm install
  * grunt build:demo -- this should open automatically on https://localhost:8000/demo

# Usage
```
var options = new DashAutocomplete.ContainerConfiguration({
  token: 'my app specific token',
  el: $('[data-id=autocomplete-container]'),
  url: 'the-url-to-POST-to.com',
  collectionView: new Demo.CollectionView()
}).configuration();

new DashAutocomplete.ContainerView(options).render();
```

# ContainerConfiguration

The ContainerConfiguration has one function: ```configuration``` that will run validations on the
configuration and alert any that are invalid.  It will return an object that the ContainerView
will use for it's own configuration.

### Arguments
* token (string): this is the access token in order to be allowed to grab task data from the Dash API.
* el (jQuery selector): the autocomplete container will be rendered in this el.  It will be a jQuery selector of where the autocomplete will be rendered into.
* url: This is the url you want the tasks to be fetched from.
* collectionView: A backbone view that will respond to: ```render```, ```showResults```, ```showNoResults```, and ```showError```

# Collection View

The library will provide everything up to how the task list will be displayed.  In future versions we are likely to change this.
For right now, we are assuming that you will pass us an object that responds to these 4 functions:

#### render().el

The instance of the collectionView will be rendered into the container's el.  This is typical Backbone View behavior.

#### showResults(tasks)

```showResults``` will take a list of JSON task data.  It is up to the collectionView to determine how those tasks will be
displayed, and what happens when they are clicked.

#### showNoResults

```showNoResults``` will get called when the request for tasks returns an empty list.  This will allow the collectionView to
customize a no results screen.

#### showError(response, statusCode)

```showError``` is called when the request for tasks fails, and takes the response and status code.  A custom, specific error
screen can be shown from this function.

# License
MIT License
