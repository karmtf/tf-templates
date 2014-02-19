<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.accounts.database.model.WegoHotel"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="java.util.Map"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	Map<MarketPlaceHotel, String> hotels = (Map<MarketPlaceHotel, String>)request.getAttribute("products");
	int city = RequestUtil.getIntegerRequestParameter(request, "destid", -1);
	User loggedInUser = SessionManager.getUser(request);
%>
<html>
<head>
<title>Select Your Hotel</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
</head>
<body>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<div class="partnerBlk">
		<form class="form-horizontal" name="packageForm" class="packageForm" action="<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PARTNER, PartnerAction.LOAD_ALL_HOTELS)%>" method="post">
		<input type="hidden" name="destid" value="<%=city%>" />
		<input type="hidden" name="hotelid" value="-1" />
		<h5 class="widget-name"><i class="icon-th"></i>Manage your hotels</h5>
		<div class="widget">
			<% if(!StringUtils.isBlank(statusMessage)) { %>
			<div class="alert margin">
				<button type="button" class="close" data-dismiss="alert">◊</button>
				<%=statusMessage%>
			</div>
			<% } %>
			<div class="control-group" style="padding:10px 0">
				<div class="controls" style="margin-left:0">
					<div class="u_floatL" style="margin-top:6px">Select City</div>
					<div class="u_floatL" style="margin-left:15px"><input type="text" size="20" name="city" id="city" class="ui-autocomplete-input span12" autocomplete="off" value="<%=(city > 0)?LocationData.getCityNameFromId(city):""%>"></div>
					<div class="u_floatL" style="margin-left:10px;margin-top:6px">Select Hotel</div>
					<div class="u_floatL" style="margin-left:10px"><input size="40" type="text" value="" name="hotel" id="hotel" class="span12 ui-autocomplete-input" autocomplete="off"><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span></div>
					<div class="u_clear"></div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Hotel Name:</label>
				<div class="controls"><input type="text" name="name" id="name" class="span12" style="width:100%"></div>
			</div>
			<div class="control-group">
				<label class="control-label">Address</label>
				<div class="controls">
					<input type="text" name="address" class="span12" id="address" class="span12" style="width:100%"/>
				</div>
			</div>
			<div class="form-actions align-right">
				<div class="u_floatL" style="margin-left:10px"><button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Load Hotels</button></div>
				<% if(loggedInUser.getRoleType() == RoleType.ADMIN || loggedInUser.getUserId() == 1645133) { %>
				<button type="button" class="btn btn-primary" onclick="addFreshHotel()">Add This</button>
				<% } %>
			</div>		
			<div id="itinerary" class="control-group">
			</div>
			<div class="table-overflow" style="height:500px;overflow-y:scroll">
				<table class="table table-striped table-bordered" id="data-table">
					<thead>
						<tr>
							<th>#</th>
							<th style="width:500px">Hotel</th>
							<th>Mapped</th>
							<th>Manage</th>
						</tr>
					</thead>
					<tbody>
						<%
							int index = 1;
							if(hotels != null && !hotels.isEmpty()) { 
								for (MarketPlaceHotel hotel : hotels.keySet()) {
									String mappedId = hotels.get(hotel);
									if(hotel != null) { 
						%>
						<% if(mappedId != null && !mappedId.equals("")) { %>
						<td></td>
						<% } else { %>
						<td><input type="radio" name="maphotelid" value="<%=hotel.getId()%>" /></td>
						<% } %>
						<td><%=hotel.getName()%></td>
						<% if(mappedId != null && !mappedId.equals("")) { %>
						<td><a target="_blank" href="<%=HotelDataBean.getHotelDetailsURL(request, hotel)%>">Details</a></td>
						<% } else { %>
						<td>No</td>
						<% } %>
						<td>
							<% if(mappedId != null && !mappedId.equals("")) { %>
							<a href="/partner/manage-hotel?hotelid=<%=hotel.getId()%>" class="tip" title="Edit Property Details">Edit</a>
							<% } %>
						</td>
						</tr>
						<% } } } %>
					</tbody>
				</table>
			</div>
		</div>
		</form>
	</div>
</div>
<div class="u_clear"></div>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
<script type="text/javascript">
function submitHotel() {
	document.packageForm.action ='<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PARTNER, PartnerAction.MAP_WEGO_HOTEL)%>';
	document.packageForm.submit();
}

function downloadHotels() {
	document.packageForm.action ='<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PARTNER, PartnerAction.DOWNLOAD_HOTELS)%>';
	document.packageForm.submit();
}

function addFreshHotel() {
	document.packageForm.action ='<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PARTNER, PartnerAction.ADD_FRESH_HOTEL)%>';
	document.packageForm.submit();
}
var counter = 1;
$jQ("#city").autocomplete({
	minLength: 2,
	source: function(request, response) {
		$jQ.ajax({
		 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.CITY_SUGGEST)%>",
		 dataType: "json",
		 data: {
			q: request.term
		 },
		 success: function(data) {
			response(data);
		 }
	  });
   },
   select: function(event, ui) {
	  var id = $jQ(this).attr("id");
	  document.packageForm.destid.value = ui.item.data.id;
   }
});
$jQ("#hotel").autocomplete({
	minLength: 2,
	source: function(request, response) {
		$jQ.ajax({
		 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.HOTEL_SUGGEST)%>",
		 dataType: "json",
		 data: {
			q: request.term,
			city : document.packageForm.destid.value
		 },
		 success: function(data) {
			response(data);
		 }
	  });
   },
   select: function(event, ui) {
	  var id = $jQ(this).attr("id");
	  document.packageForm.hotelid.value = ui.item.id;
   }
});
</script>
</body>
</html>
