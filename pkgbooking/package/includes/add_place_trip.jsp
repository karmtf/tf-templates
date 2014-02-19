<%@page import="com.poc.server.trip.TripBean"%>
<script>
var PLCTRIP = new function () {
	this.showTrips = function(typ, plcId, el) {
<%--		var successLoadTrips = function(a, m, x) {
			var rspO = JS_UTIL.parseJSON($jQ(x).text());
			MODAL_PANEL.show('<div>' + rspO.htm + '</div>', {title:'Add to Trip', blockClass:'lgRgBlk2'});
		}
		AJAX_UTIL.asyncCall('<%=TripBean.getAddToTripURL(request)%>', 
			{params: 'plcs='+plcId, scope: this,
				wait: {inDialog: true, msg: 'Please wait...'}, success: {handler: successLoadTrips}
			}); --%>
		var successAdd = function(a, m, x) {
			$jQ(el).replaceWith('<b class="signSmIc tckSmIc">Added</b>');
		}
		AJAX_UTIL.asyncCall('<%=TripBean.getAddEntityToTripURL(request)%>', 
			{params: 'productType='+typ+'&productId='+plcId, scope: this,
				wait: {inDialog:false, msg: 'Please wait...', divEl:$jQ(el)}, success: {handler: successAdd}
			});
	}
	
}
</script>