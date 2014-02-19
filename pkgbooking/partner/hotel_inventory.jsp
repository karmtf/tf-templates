<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>

<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eos.hotels.data.HotelSearchQuery"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageInventory"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>

<%@page import="java.text.DecimalFormat"%>


<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.constants.DayOfWeek"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.poc.server.model.SellableUnitWrapper"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.constants.PriceAmount"%>

<%
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<HotelRoom> mpRooms = (List<HotelRoom>)request.getAttribute("rooms");
	int roomId = RequestUtil.getIntegerRequestParameter(request, "roomid", -1);
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("dd MMM");
	Date start = (Date)request.getAttribute(Attributes.DATE_START.toString());
	String startDate = dt.format(start);
	Map<String, List<PackageInventory>> inventoryMap = (Map<String, List<PackageInventory>>)request.getAttribute(Attributes.PACKAGE_INVENTORY.toString());
	Calendar endCal = (Calendar)request.getAttribute(Attributes.END_DATE.toString());
	Calendar startCal = Calendar.getInstance();
	startCal.setTime(start);
%>
<html>
<head>
<title>Manage Room Inventory For <%=hotel.getName()%></title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<style type="text/css">
.dateCell {font-size:11px;font-weight:bold;color:#F78C0D;font-family:georgia,serif;border-left:1px solid #DDD;border-bottom:1px solid #DDD;border-right:1px solid #DDD;width:30px;padding:0 5px;text-align:center;height:30px;}
.roomCell {font-size:11px;font-weight:bold;color:#333;border-left:1px solid #DDD;border-bottom:1px solid #DDD;border-right:1px solid #DDD;width:30px;padding:5px;text-align:center;}
.invCell {font-size:11px;font-weight:bold;color:#333;border-left:1px solid #DDD;border-bottom:1px solid #DDD;border-right:1px solid #DDD;width:30px;padding:5px;text-align:center;}
</style>
</head>
<body>
<script>
$jQ(document).ready(function() {
	$jQ(".datepicker").datepicker({
		defaultDate: +7,
		showOtherMonths:true,
		autoSize: true,
		dateFormat:'dd/mm/yy'
	});
});
</script>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<h5 class="widget-name">Add Inventory for <%=hotel.getName()%></h5>	
	<form name="dealsForm" action="/partner/manage-inventory" method="post">
		<input type="hidden" name="hotelid" value="<%=request.getParameter("hotelid")%>" />
		<input type="hidden" name="startDate" value="<%=startDate%>" />
	</form>
	<% if(!StringUtils.isBlank(statusMessage)) { %>
	<div class="alert" style="margin:0"><%=statusMessage%></div>
	<% } %>
	<form name="packageForm" action="/partner/add-inventory" method="post">
	<input type="hidden" name="hotelid" value="<%=request.getParameter("hotelid")%>" />
	<div style="margin:20px 0">
		<div class="u_floatL" style="line-height:18px;margin:5px 0">
			<b>Select Start Date:</b>
			<input type="text" placeholder="Starting Date" id="startDate" name="startDate" value="<%=startDate%>" class="datepicker" size="10"><span class="ui-datepicker-append"></span>
		</div>
		<div class="u_floatL" style="margin-left:5px">
			<a href="#" onclick="loadDeals();return false;" class="btn btn-primary">Show Inventory Position</a>
		</div>
		<div class="u_clear"></div>
	</div>
	<div class="mrgn10T">
		<div class="u_floatL">
			<b>Select Room:</b><br>
			<% if(mpRooms != null && !mpRooms.isEmpty()) { %>
			<select name="roomid" id="roomid">
				<% for (HotelRoom room : mpRooms) { %>
				<option value="<%=room.getId()%>" <%=(roomId > 0 && roomId == room.getId())?"selected":""%>><%=room.getRoomName()%></option>
				<% } %>
			</select>
			<% } %>
		</div>
		<div style="line-height:18px;margin-left:20px;" class="u_floatL">
			<b>From Date:</b><br>
			<input type="text" placeholder="Start Travel Date" id="date" name="fromDate" class="datepicker" size="10"><span class="ui-datepicker-append"></span>
		</div>
		<div style="line-height:18px;margin-left:20px;" class="u_floatL">
			<b>To Date:</b><br>
			<input type="text" placeholder="End Travel Date" id="date2" name="toDate" class="datepicker" size="10"><span class="ui-datepicker-append"></span>
		</div>
		<div style="line-height:18px;margin-left:20px;" class="u_floatL">
			<b>Rooms:</b><br>
			<select name="numRooms" style="width:100px">
				<option value="0">0</option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
			</select>
		</div>
		<div class="u_floatL" style="margin-left:20px">
			<a href="#" onclick="packageForm.submit()" style="margin-top:15px" class="btn btn-primary">Update Allocation</a>
		</div>
		<div class="u_clear"></div>
	</div>
	</form>
	<div class="spacer"></div>
	<h5 class="widget-name">Inventory Calendar</h5>
	<table class="table">
		<tr>
		<th style="width:90px;">Room</th>
		<%
			while(startCal.before(endCal)) { 
		%>
		<th><%=df.format(startCal.getTime())%></th>
		<%     
			startCal.add(Calendar.DAY_OF_YEAR, 1);
		} 
		%>
		</tr>
		<% if(mpRooms != null && !mpRooms.isEmpty()) { %>
			<% 
				boolean isOdd = true;
				for (HotelRoom room : mpRooms) { 
					isOdd = !isOdd;
			%>
			<tr class="<%=isOdd?"odd":"even"%>">
			<td style="width:90px;"><%=room.getRoomName()%></td>
			<%
				startCal.setTime(start);
				while(startCal.before(endCal)) { 
					List<PackageInventory> inventoryList = inventoryMap.get(dt.format(startCal.getTime()));
					PackageInventory inventory = null;
					if(inventoryList != null) {
						for(PackageInventory inv : inventoryList) {
							if(inv.getProductId() == room.getId()) {
								inventory = inv;
								break;
							}
						}
					}
					if(inventory != null) {
			%>
			<td style="font-weight:bold;font-size:12px">
				<%=inventory.getAllocated()%>
			</td>
			<% } else { %>
			<td>0</td>
			<% } %>
			<%     
				startCal.add(Calendar.DAY_OF_YEAR, 1);
			} 
			%>
			</tr>
			<%isOdd = !isOdd;%>
			<tr class="<%=isOdd?"odd":"even"%>">
			<td>Booked Status</td>
			<%
				startCal.setTime(start);
				while(startCal.before(endCal)) { 
					List<PackageInventory> inventoryList = inventoryMap.get(dt.format(startCal.getTime()));
					PackageInventory inventory = null;
					if(inventoryList != null) {
						for(PackageInventory inv : inventoryList) {
							if(inv.getProductId() == room.getId()) {
								inventory = inv;
								break;
							}
						}
					}
					if(inventory != null) {
			%>
			<% if(inventory.getBooked() > 0) { %>
			<td style="color:green;font-weight:bold;font-size:12px">
				<%=inventory.getBooked()%>
			</td>
			<% } else { %>
			<td style="color:red;font-weight:bold;font-size:12px">
				<%=inventory.getBooked()%>
			</td>
			<% } %>
			<% } else { %>
			<td style="color:red;font-weight:bold;font-size:12px">0</td>
			<% } %>
			<%     
				startCal.add(Calendar.DAY_OF_YEAR, 1);
			} 
			%>
			</tr>
			<% } %>
		<% } %>
	</table>
	<div class="spacer"></div>
	<div class="spacer"></div>
</div>
</div>
<div class="u_clear">
<script type="text/javascript">
$jQ(document).ready(function() {
var dateCal = new DatePick({fromInp:document.packageForm.fromDate, toInp:document.packageForm.toDate, calO:{minDate:null}});
var dateCal2 = new DatePick({fromInp:document.packageForm.startDate, calO:{minDate:null}});
});
function loadDeals() {
document.dealsForm.startDate.value = $jQ('#startDate').val();
document.dealsForm.submit();
}
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
