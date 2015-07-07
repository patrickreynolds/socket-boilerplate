var Trace = Trace || {}

$(function() {

	Trace.locations = []

	Trace.canvas = document.getElementById('whiteboard');
	if (Trace.canvas.getContext) {
		Trace.canvasContext = Trace.canvas.getContext('2d')
	}

	Trace.draw = function () {
		Trace.canvasContext.clearRect(0, 0, Trace.canvas.width, Trace.canvas.height)
		Trace.canvasContext.lineCap = 'round'
		Trace.canvasContext.lineWidth = 2
		Trace.currentPath = new Path2D()
		Trace.currentPath.moveTo(Trace.locations[0].x, Trace.locations[0].y)

		var i;
    var locationsLength = Trace.locations.length
		for (i = 1; i < locationsLength; i++) {
			Trace.currentPath.lineTo(Trace.locations[i].x, Trace.locations[i].y)
		}
		
    Trace.canvasContext.stroke(Trace.currentPath)
	}

 	var socket = io();
 	$('#like-button').click(function(ev){
 		ev.preventDefault()
   		socket.emit('web-like-photo', 'Will liked your photo')
  })

	socket.on('web-like-photo-notification', function(notification) {
    var $notificationDiv = $('#notification')
    $notificationDiv.css('left', $(document).width() - 200 - 20).html(notification[0])
    move($notificationDiv.get(0))
      .set('top', '20px')
      .ease('in-out')
      .duration('0.3s')
      .end(function() {
        setTimeout(function() {
          move($notificationDiv.get(0))
            .set('top', '-40px')
            .duration('0.3s')
            .end()
        }, 2000)
      })
	 })

	socket.on('canvas-began-location', function(touchLocation) {
		console.log("Began - " + JSON.stringify(touchLocation))
		Trace.locations = []
		Trace.locations.push(touchLocation)
		Trace.draw()
	})

	socket.on('canvas-changed-location', function(touchLocation) {
		console.log("Changed - " + JSON.stringify(touchLocation))
		Trace.locations.push(touchLocation)
		Trace.draw()
	})

	socket.on('canvas-ended-location', function(touchLocation) {
		console.log("Ended - " + JSON.stringify(touchLocation))
		Trace.locations.push(touchLocation)
		Trace.draw()
	})
})