using Toybox.WatchUi as Ui;
using Toybox.System;

class ECEuropaWatchFaceView extends Ui.View {    	
	// Math
	var TWO_PI = Math.PI * 2;
	var ANGLE_ADJUST = Math.PI / 2.0;
    	
    	// Sizes and coordinates
    var center_x;
    var center_y;
	var height;
	var width;
	
	// Assets
    	var logo;
    	var logo_width = 200;
    	
    	// Watch elements
    	var hand_minute;
    var hand_hour;
    var screenShape;

    function initialize() {
        View.initialize();
        screenShape = System.getDeviceSettings().screenShape;
    }

    // Load your resources here
    function onLayout(dc) {
    		logo = Ui.loadResource(Rez.Drawables.Eu);
    }

    function onUpdate(dc) {
    		height = dc.getHeight();
    		width = dc.getWidth();
    		center_x = width / 2;
    		center_y = height / 2;
    		
        var now = System.getClockTime();
        var hour = now.hour;
        var minute = now.min;
        
        var hour_fraction = minute / 60.0;
        var minute_angle = hour_fraction * TWO_PI;
        var hour_angle = (((hour % 12) / 12.0) + (hour_fraction / 12.0)) * TWO_PI;
        
        // compensate the starting position
        minute_angle -= ANGLE_ADJUST;
        hour_angle -= ANGLE_ADJUST;
    		
    		hand_minute = 6/8.0 * center_x;
    		hand_hour = 2/3.0 * hand_minute;
    		
    		// Draw the background
	    dc.setColor(0x004494, Graphics.COLOR_BLACK);
   		dc.fillRectangle(0, 0, width, height);
   		
   		// Draw hours' divisions
   		// drawDivisions(dc);
   		
   		// Draw logo
   		dc.setColor(0x004494, Graphics.COLOR_BLACK);
   		dc.drawBitmap(center_x - logo_width / 2, center_x - logo_width / 2, logo);
   		
   		// Draw the hands
   		dc.setColor(0xf9cc46,Graphics.COLOR_BLACK);
   		
   		// Draw the minute
        dc.drawLine(center_x, center_y,
            (center_x + hand_minute * Math.cos(minute_angle)),
            (center_y + hand_minute * Math.sin(minute_angle)));

        // Draw the hour
        dc.drawLine(center_x, center_y,
            (center_x + hand_hour * Math.cos(hour_angle)),
            (center_y + hand_hour * Math.sin(hour_angle)));
    }
    
    // Draws the clock tick marks around the outside edges of the screen.
    function drawDivisions(dc) {
    		dc.setColor(0xf9cc46,Graphics.COLOR_BLACK);
    		
        var sX, sY;
        var eX, eY;
        var outerRad = width / 2;
        var innerRad = outerRad - 10;
        var division = Math.PI / 6;

        for (var i = division; i <= 11 * division; i += division) {
            // Partially unrolled loop to draw two tickmarks in 15 minute block.
            sY = outerRad + innerRad * Math.sin(i);
            eY = outerRad + outerRad * Math.sin(i);
            sX = outerRad + innerRad * Math.cos(i);
            eX = outerRad + outerRad * Math.cos(i);
            dc.drawLine(sX, sY, eX, eY);
            i += division;
            sY = outerRad + innerRad * Math.sin(i);
            eY = outerRad + outerRad * Math.sin(i);
            sX = outerRad + innerRad * Math.cos(i);
            eX = outerRad + outerRad * Math.cos(i);
            dc.drawLine(sX, sY, eX, eY);
        }
    }
}
