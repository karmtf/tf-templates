<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.itinerary.PackageItinerary"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.itinerary.PackageDayItinerary"%>
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryBean"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	PackageItinerary pkgItinerary = (PackageItinerary) request.getAttribute(Attributes.PACKAGE_ITINERARY.toString());
	boolean showItnEditControls = ItineraryBean.isItineraryEditAllowed(request, pkgConfig);

	String addItnItemURL = ItineraryBean.getItinearyItemAddURL(request, pkgConfig);
%>
<% 
	if (pkgItinerary != null) {
	for (int day = 1; day <= pkgConfig.getNumberOfNights() + 1; day++) {
	    PackageDayItinerary pkgDayItn = pkgItinerary.getPackageDayItinerary(day);
	    request.setAttribute(Attributes.PACKAGE_DAY_ITINERARY.toString(), pkgDayItn);
%>
	<div class="u_block itinerary" style="margin-left:14px">
		<jsp:include page="pkg_day_itinerary_view.jsp"/>
	</div>
<% } }%>
<script type="text/javascript">
function toggle(day) {
	$jQ('.' + day + 'day').slideToggle('slow');
	if($jQ('.' + day + 'exp a').text() == 'Expand') {
		$jQ('.' + day + 'exp a').text('Collapse');
	} else {
		$jQ('.' + day + 'exp a').text('Expand');
	}
}
<% if (showItnEditControls) { %>
$jQ(document).ready(function() {
	ITMMKR.init();
});
<% } %>
</script>
<% if (showItnEditControls) { %>
<jsp:include page="/package/includes/package_itn_edit_js.jsp"/>
<% } %>
