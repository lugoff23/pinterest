$(window).resize -> 
  PinTiles.alignTiles($('.tiles'))

window.PinTiles = 
  alignTiles : (container) ->
    heights = []
    cols = parseInt(container.width() / container.find('.tile').first().outerWidth(true))
    rows = 0
    container.find('.tile').each (index) ->
      col = index % cols
      left = col * $(this).outerWidth(true)
      heights[col] = 0 if heights[col] == undefined
      $(this).css({
        'position': 'absolute',
        'left': left + 'px',
        'top': heights[col] + 'px'
      })
      heights[col] = heights[col] + $(this).outerHeight(true)
    container.css({
      'position': 'relative',
      'height': Math.max.apply(Math, heights)
    })
    true
  preview : (path) ->
    $('#previewer').load path
