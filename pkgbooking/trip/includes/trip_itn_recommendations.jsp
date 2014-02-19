<%@page import="com.eos.b2c.content.relationship.ContentRelationshipRecommendation"%>
<%@page import="com.eos.b2c.content.DestinationRecommendationType"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%
	Destination recommendationForPlace = (Destination) request.getAttribute(Attributes.DESTINATION.toString());
	Map<DestinationRecommendationType, ContentRelationshipRecommendation> nearbyRecommendationsMap = (Map<DestinationRecommendationType, ContentRelationshipRecommendation>) request.getAttribute(Attributes.NEARBY_CONTENT_RECOMMENDATIONS.toString());
	Integer cityId = (Integer) request.getAttribute(Attributes.CITY_ID.toString());
	boolean showSearchBox = false;//UIHelper.isSystemUser(request);

	DestinationLocation recommendationForPlaceLoc = (recommendationForPlace != null) ? recommendationForPlace.getLocation(): null;
%>
<% if (showSearchBox) { %>
	<%@page import="com.eos.b2c.content.DestinationLocation"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<div class="mrgnB clearfix">
		<form id="plcSearchForm" name="plcSearchForm" class="def-form booking wideL">
			<input type="hidden" name="cId" value="<%=cityId%>"/>
			<input type="text" name="q" value=""/>
			<button type="submit">Search</button>
		</form>
	</div>
	<div class="placeRsltCtr"></div>
<% } %>
<% 
	for (DestinationRecommendationType recommendationType: DestinationRecommendationType.getValidRecommendationTypes()) { 
	    ContentRelationshipRecommendation contentRecommendation = nearbyRecommendationsMap.get(recommendationType);
	    if (contentRecommendation == null || !contentRecommendation.hasRecommendation()) {
	        continue;
	    }
%>
	<div class="placeRecCtr clearfix">
		<h4 style="font-weight:bold; font-size:14px; margin:5px 0px; padding:0;"><%=recommendationType.getDisplayText()%></h4>
		<% for (Destination place: contentRecommendation.getRecommendedPlaces()) { %>
			<div class="clearfix details" style="width:100%">
				<div class="left">
					<a class="productUrl" href="<%=DestinationContentBean.getDestinationContentURL(request, place)%>" target="_blank"><%=StringUtility.truncateAtWord(place.getName(), 27, true)%></a>
					<div style="font-size:1.0em;color:#333;">
						<%=place.getDestinationType().getSingularTitle()%><% if (DestinationLocation.isValid(recommendationForPlaceLoc) && DestinationLocation.isValid(place.getLocation())) { %>, <%=UIHelper.getDistanceDisplayText(request, recommendationForPlaceLoc, place.getLocation(), false)%><% } %>
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
<% } %>