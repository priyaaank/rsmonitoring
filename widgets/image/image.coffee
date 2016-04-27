class Dashing.Image extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    classToSet = data.status || 'image'
    $(@node).removeClass('widget-image')
    $(@node).removeClass('widget-failure')
    $(@node).removeClass('widget-success')
    $(@node).removeClass('widget-progress')
    $(@node).addClass('widget-'+classToSet)
    #$(@node).fadeOut().fadeIn()
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
