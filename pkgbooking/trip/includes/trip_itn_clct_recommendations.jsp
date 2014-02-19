<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<%
	List<Destination> places = (List<Destination>) request.getAttribute(Attributes.COLLECTED_PRODUCTS.toString());
%>
<% 
	if (places != null && !places.isEmpty()) {
%>
	<div class="placeRecCtr clearfix">
	<% for (Destination place: places) { %>
		<div class="clearfix details" style="width:100%">
			<div class="left">
				<a class="productUrl" href="<%=DestinationContentBean.getDestinationContentURL(request, place)%>" target="_blank"><%=StringUtility.truncateAtWord(place.getName(), 27, true)%></a>
				<div style="font-size:1.0em;color:#333;">
					<%=place.getDestinationType().getSingularTitle()%>
				</div>
			</div>
			<div class="right">
				<div class="plcTrpAddAct">
					<div class="add left hover-link tf-anim-fast-active" style="text-decoration:none">Add in</div>
					<% for (ActivityTimeSlot timeSlot: place.getAvailableTimeSlots()) { %>
					<div class="add hover-link tf-anim-fast active" data-product-id="<%=place.getId()%>" data-product-slot="<%=timeSlot.name()%>"><%=timeSlot.getDisplayText()%></div>
					<% } %>
				</div>
			</div>
		</div>
	<% } %>
	</div>
<% } else { %>
	<div>You have no places in your shortlist.</div>
<% } %>