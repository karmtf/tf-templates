<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryStep"%>
<%@page import="com.poc.server.trip.TripBean"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%
	String cityKey = request.getParameter("cKy");
	String dayStr = request.getParameter("day");
	ItineraryStep dayActivity = (ItineraryStep) request.getAttribute(Attributes.PACKAGE_DAY_ACTIVITY.toString());
	ActivityTimeSlot timeSlot = dayActivity.getTimeSlot();
	Destination place = DestinationContentManager.getDestinationFromId(dayActivity.getPlaceId());

	String destinationURL = DestinationContentBean.getDestinationContentURL(request, place);
	if(place != null) {
	String imageURL = UIHelper.getDestinationImageURLForDataType(request, place.getMainImage(), FileDataType.I200X100);
%> 
<div id="itnStp<%=dayStr%><%=timeSlot.name()%><%=place.getId()%>" class="itnPlcStp">
<article class="full-width" style="padding:0 0 10px 0px;width:98%">
	<% if(StringUtils.isNotBlank(imageURL) && imageURL.indexOf("coming") == -1) { %>
	<figure>
		<a href="<%=destinationURL%>">
			<img class="shot" src="<%=imageURL%>" style="width:100px;height:80px;border:1px solid rgba(0,0,0,.2);border-radius:3px"/>
		</a>
	</figure>
	<% } %>
	<div class="details" style="padding-top:0;font-size:12px">
	<% if (place != null) { %>
		<h2 style="padding-bottom:2px;margin-bottom:2px;border-bottom:0px;text-align:left"><a class="title productUrl" <%=TripBean.getProductDescriptionHtmlParams(ViaProductType.DESTINATION, place)%> href="<%=DestinationContentBean.getDestinationContentURL(request, place)%>" style="font-weight:normal;font-size:14px"><%=StringUtility.truncateAtWord(place.getName(),27,true)%></a></h2>
		<div class="clearfix"></div>
		<div style="font-size:1.0em;color:#333;"><%=place.getDestinationType().getSingularTitle()%></div>
		<div class="description" style="padding-bottom:5px">
			<%=StringUtility.truncateAtWord(UIHelper.extractRenderTextFromHTML(dayActivity.getComment()), 300, true)%>
		</div>
		<% if (place.getDurationHours() > 0) { %>
		<div class="description">
			<p><b>Maximum Duration of Visit:</b> <%=place.getDurationStr()%></p>
		</div>
		<% } %>
		<div style="position:absolute;right:0;top:0;"><a href="#" onclick="ITMMKR.removeItem('<%=cityKey%>', <%=dayStr%>, <%=place.getId()%>, '<%=timeSlot.name()%>'); return false;" class="hover-link tf-anim-fast active">Remove</a></div>
	<% } else { %>
		<p style="padding-bottom:10px">
		<%=UIHelper.extractRenderTextFromHTML(dayActivity.getComment())%>
		</p>
	<% } %>
	</div>
</article>
</div>
<% } %>