<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.accounts.database.model.HotelSupplierMap"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.ui.SessionManager"%>
<%
	User user = SessionManager.getUser(request);
	List<HotelSupplierMap> hotels = (List<HotelSupplierMap>)request.getAttribute("products");
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
		<h5 class="widget-name"><i class="icon-th"></i>Manage your properties</h5>
		<div class="widget">
			<% if(user.getRoleType() == RoleType.GUEST_HOUSE && (hotels == null || hotels.isEmpty())) { %>
			<form class="form-horizontal" name="packageForm" class="packageForm" action="<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PARTNER, PartnerAction.ADD_FRESH_HOTEL)%>" method="post">
			<input type="hidden" name="destid" value="-1" />
			<div class="control-group">
				<label class="control-label">Select City:</label>
				<div class="controls">
					<input type="text" name="city" id="city" class="span12" autocomplete="off" style="width:100%" value="" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Name:</label>
				<div class="controls"><input type="text" name="name" id="name" class="span12" style="width:100%"></div>
			</div>
			<div class="control-group">
				<label class="control-label">Address</label>
				<div class="controls">
					<input type="text" name="address" class="span12" id="address" class="span12" style="width:100%"/>
				</div>
			</div>
			<div class="form-actions align-right">
				<button type="submit" class="btn btn-primary">Add My Property</button>
			</div>
			</form>
			<% } else if(user.getRoleType() == RoleType.HOTELIER) { %>
			<form class="form-horizontal" name="packageForm" class="packageForm" action="<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PARTNER, PartnerAction.MAP_HOTEL)%>" method="post">
				<input type="hidden" name="destid" value="-1" />
				<input type="hidden" name="hotelid" value="-1" />
			</form>
			<div style="margin-bottom:10px">
				Add hotels by selecting the city and property name and add it to your account to manage them further. 
			</div>
			<div class="control-group" style="padding:10px 0">
				<div class="controls">
					<div class="u_floatL" style="margin-top:6px">Select City</div>
					<div class="u_floatL" style="margin-left:15px"><input type="text" size="30" value="" name="city" id="city" class="ui-autocomplete-input span12" autocomplete="off"></div>
					<div class="u_floatL" style="margin-left:10px;margin-top:6px">Select Hotel</div>
					<div class="u_floatL" style="margin-left:10px"><input size="40" type="text" value="" name="hotel" id="hotel" class="span12 ui-autocomplete-input" autocomplete="off"><span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span></div>
					<div class="u_floatL" style="margin-left:10px"><button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Add Hotel To Manage</button></div>
					<div class="u_clear"></div>
				</div>
			</div>
			<% } %>
			<div class="table-overflow">
				<table class="table table-striped table-bordered" id="data-table">
					<thead>
						<tr>
							<th>#</th>
							<th>Your Hotel</th>
							<th class="actions-column">More Actions</th>
							<th class="actions-column">Delete</th>
						</tr>
					</thead>
					<tbody>
						<%
							int index = 1;
							if(hotels != null && !hotels.isEmpty()) { 
								for (HotelSupplierMap hotel : hotels) {
						%>
						<td><%=index++%></td>
						<td><a href="/partner/hotel-packages?hotelid=<%=hotel.getHotelId()%>" title=""><%=MarketPlaceHotel.getHotelById(hotel.getHotelId()).getName()%></a></td>
						<td>
							<ul class="navbar-icons">
								<li><a href="/partner/manage-hotel?hotelid=<%=hotel.getHotelId()%>" class="tip" title="Edit Property Details"><i class="icon-pencil"></i></a></li>
								<li><a href="/partner/hotel-packages?hotelid=<%=hotel.getHotelId()%>" class="tip" title="View Dashboard"><i class="icon-signal"></i></a></li>
							</ul>
						</td>
						<td>
							<a href="/partner/delete-hotel-map?hotelid=<%=hotel.getHotelId()%>" class="tip" title="Delete Hotel Manage">Delete</a>
						</td>
						</tr>
						<% } } %>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<div class="u_clear"></div>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
<script type="text/javascript">
function submitHotel() {
	$jQ('#selectHotelForm').submit();
	return false;
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
