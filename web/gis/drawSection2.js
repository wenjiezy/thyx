//dojo.require("esri.map");
//dojo.require("esri.toolbars.draw");
dojo.require("dijit.layout.BorderContainer");
dojo.require("dijit.layout.ContentPane");
dojo.require("dojox.charting.widget.Chart2D");
dojo.require("dojox.charting.themes.Claro");
//var map, toolbar, symbol;
//var imageservicelayer;
//var pointcountexp, pointcountact;
//var anchorgeometry, thegraphic;
//var op = "", theCon;
var thegraphic;
var samplegeometryType = "esriGeometryPolyline";
var maxheight = 0 ;
var maxheights = [];
var aa = 0;
var graphic1='';
var layerUrl = "http://192.168.1.20:6080/arcgis/rest/services/hatc/GC02/ImageServer";

/*对外接口,根据点集合画剖面图.
 *参数points: 剖面图的线所使用的点集合
 *参数planHeight：计划中的飞行高度.
 *参数drawChart：0-不画刨面图，仅高度报警；else-画刨面图并高度报警
 */
function gis_drawSection2(points, planHeight, points2,k,drawChart) {
	
	//graphic1=executeDrawLine( points , 'STYLE_SOLID', '#0000FF', 1,null,1);
	var myJsonStr = '{"points":' + points + '}';
	mpJson = JSON.parse(myJsonStr);
	var multipoint = new esri.geometry.Multipoint(mpJson);
	polyline = new esri.geometry.Polyline(map.spatialReference);
	polyline.addPath(multipoint.points);
	doGetSamples2(polyline, planHeight, points2, k,drawChart);

}

function addPointToMap(geometry) {
	//toolbar.deactivate();
	//map.showZoomSlider();
	switch (geometry.type) {
		case "point":
			//samplegeometryType = "esriGeometryPoint";
			var symbol = new esri.symbol.SimpleMarkerSymbol(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE, 10, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([0, 0, 255]), 1), new dojo.Color([0, 255, 0, 1]));
			break;
		case "polyline":
			samplegeometryType = "esriGeometryPolyline";
			var symbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255, 0, 0]), 5);
			break;
		case "polygon":
			samplegeometryType = "esriGeometryPolygon";
			var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_DASHDOT, new dojo.Color([255, 0, 0]), 2), new dojo.Color([255, 255, 0, 0.25]));
			break;
		case "extent":
			samplegeometryType = "esriGeometryEnvelope";
			var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_DASHDOT, new dojo.Color([255, 0, 0]), 2), new dojo.Color([255, 255, 0, 0.25]));
			break;
		case "multipoint":
			samplegeometryType = "esriGeometryMultipoint";
			var symbol = new esri.symbol.SimpleMarkerSymbol(esri.symbol.SimpleMarkerSymbol.STYLE_DIAMOND, 20, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([0, 0, 0]), 1), new dojo.Color([255, 255, 0, 0.5]));
			break;
		default:
			var symbol = new esri.symbol.SimpleMarkerSymbol(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE, 30, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([0, 0, 255]), 1), new dojo.Color([0, 255, 0, 1]));
			break;
	}
	var graphic = new esri.Graphic(geometry, symbol);
	if (geometry.type == null || geometry.type == "point") {
		thegraphic = graphic;
	}
	map.graphics.add(graphic);
/*
	if (geometry.type == "polyline" || geometry.type == "multipoint") {
		anchorgeometry = geometry;
		doGetSamples(anchorgeometry);
	}
*/
}

function doGetSamples2(pline, planHeight,points,k,drawChart) {
	if (planHeight == null) planHeight = 0;
	if(!(drawChart == 0)) {
		dojo.empty("chartNode");
		map.infoWindow.hide();
	}
	var callbackfunc0 = {
		chartit : function(response) {
			if (response.samples && response.samples.length > 0)
				showChart2(response.samples,planHeight,points,k);
		}
	};
	
	var errorbackfunc = {
		chartit : function(error) {
			console.log(error.message);
		}
	};
	var layersRequest = esri.request({
		url : layerUrl + "/getSamples",
		content : {
			geometry : JSON.stringify(pline.toJson())
			,geometryType : samplegeometryType
			,sampleCount : 20
			//,returnFirstValueOnly : false
			,f : "json"
		},
		handleAs : "json",
		callbackParamName : "callback"
	});

	layersRequest.then(dojo.hitch(callbackfunc0, "chartit"), dojo.hitch(errorbackfunc, "chartit"))


	function showChart2(samples2,planHeight,samples,m) {

		var maxpixelvalue2 = -9999;
		var tempval2 = 0;
		
		for (var i = 0; i < samples2.length; i++) {	
			tempval2 = parseFloat(samples2[i].value);
			maxpixelvalue2 = tempval2 > maxpixelvalue2 ? tempval2 : maxpixelvalue2;
		}
		//planHeight = maxpixelvalue2;
		console.log(m);
		console.log(maxpixelvalue2);
		maxheights[m]=maxpixelvalue2;
		var d1 = 0;
		var d2 = 0;
		//if(m==99 && maxheights.length >99){
		if(m == (samples.length-1) && maxheights.length > (samples.length-1)){
			
			var chartData1 = [], chartData2 = [];
			chartX = [];
			chartPoints = [];
			minpixelvalue = 9999;
			maxpixelvalue = -9999;
			var tempval = 0;
			var tempdist = 0, maxK;
			d1 = new Date().getTime();
            console.log('d1='+d1);
			for (var k = 0; k < samples.length; k++) {
				if (samplegeometryType == "esriGeometryMultipoint") {
					tempdist = k;
				} else if (k == 0) {
					tempdist = 0;
				} else {
					//tempdist = tempdist + Math.pow((Math.pow((samples[k].location.x - samples[k - 1].location.x), 2) + Math.pow((samples[k].location.y - samples[k - 1].location.y), 2)), 0.5);
					//tempdist = tempdist + getDistance(samples[k].location.x, samples[k].location.y, samples[k - 1].location.x, samples[k - 1].location.y)/1000;
					tempdist = tempdist + getDistance(samples[k].location.y, samples[k].location.x,samples[k - 1].location.y,samples[k - 1].location.x)/1000;
				}
				chartX.push({
					value : k + 1,
					text : (parseInt(tempdist)).toString()
				});
				chartPoints.push({
					value : k + 1,
					loc : samples[k].location
				});
				//tempval = parseFloat(maxheights[k]);
				if(maxheights[k] == undefined){
					tempval = maxheights[k-1];
				}else{
					tempval = maxheights[k];
				}
				minpixelvalue = tempval < minpixelvalue ? tempval : minpixelvalue;
				//maxpixelvalue = tempval > maxpixelvalue ? tempval : maxpixelvalue;
				if(tempval > maxpixelvalue) {
					maxpixelvalue = tempval;
					maxK = k;
				} 
				chartData1.push({
					y : tempval
					//,tooltip : samples[k].value
					,tooltip : tempval
				});
				if (k == 0 || k == samples.length-1) { // 起点和终点
					chartData2.push({
						y : tempval
						//,tooltip : "飞行高度"
					});
				} else {
					chartData2.push({
						y : planHeight
						//,tooltip : "飞行高度"
					});
				}
			}
			if(planHeight > 0 && planHeight - maxpixelvalue < 600) { // 当飞行高度低于最高障碍600米时，报警
				addAreaSpaceConflictData("rs_ob",planHeight - maxpixelvalue,samples[maxK].location);
			}
			if( drawChart == 0 ) return ;
			maxpixelvalue = planHeight > maxpixelvalue ? planHeight : maxpixelvalue;
			var chart = new dojox.charting.Chart2D("chartNode");
			chart.setTheme(dojox.charting.themes.Claro);
			chart.addPlot("default", {
				type : "Areas"
				//,markers : true
			});
			chart.addPlot("ElevationProfile", {
				type : "Lines",
				color: "blue",
				markers : true
			});
			if (samplegeometryType == "esriGeometryPolyline")
				chart.title = "距离-高程 (千米-米)";
			else
				chart.title = "离散位置的高程 (米)";
			// Add axes
			chart.addAxis("x", {
				labels : chartX
				,natural: false
				,fixed: true
				//,title: "千米"
				//,minorTicks : false
			});
			minval = parseInt(minpixelvalue) - 100;
			maxval = parseInt(maxpixelvalue) + 100;
			chart.addAxis("y", {
				min : minval
				,max : maxval
				,vertical : true
				//,title: "米"
				,fixLower : "None"
				,fixUpper : "None"
			});
	
			var tooltip = new dojox.charting.action2d.Tooltip(chart, "default");
			// Add the series of data
			chart.addSeries("default", chartData1,  {fill: "lightpink"});
			// 画高度线
			if(planHeight > 0) {
				chart.addSeries("ElevationProfile", chartData2);
			}
			// Render the chart!
			chart.render();
	
			chart.connectToPlot("default", function(evt) {
				if (evt.element == "marker") {
//					if(evt.x == 1) {
//						evt.element = "";
//						alert(evt.chart.plots);
//						evt.chart.removePlot("ElevationProfile");
//						evt.chart.removePlot("default");
//					}
					if (evt.type == "onmouseover") {
						for (var j = 0; j < chartPoints.length; j++) {
							if (chartPoints[j].value == evt.x) {
								addPointToMap(new esri.geometry.Point(chartPoints[j].loc));
								break;
							}
						}
					} else if (evt.type == "onmouseout") {
						map.graphics.remove(thegraphic);
					}
				}
			});
			d2 = new Date().getTime();
			console.log('d2='+d2);
            console.log('haoshi2='+(d2-d1));
		}
        
            
	}

}

