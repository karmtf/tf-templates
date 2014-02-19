<%@page import="org.apache.commons.lang.WordUtils"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="com.poc.server.tracking.database.model.PageMetaInfo"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.user.wall.UserWallBean"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.secondary.database.model.Contribution"%>
<%
	List<Contribution> contributions  = (List<Contribution>) request.getAttribute(Attributes.CONTRIBUTIONS.toString());
	if(contributions != null && !contributions.isEmpty()) {	
%>
<article class="default clearfix sideBlock mrgn10T" id="rcmndCltCtr">
	<div class="deals">
		<h2 class="mrgn10B sideHeading">Top Contributing Experts</h2>
		<% 
			for (Contribution contribution : contributions) {
		%>
		<article class="full-width" style="padding:0px 5px 5px 0px">
			<% if(StringUtils.isNotBlank(contribution.getUser().getProfilePicURL())) { %>
			<figure style="border:5px solid #eee"><img src="<%=UIHelper.getProfileImageURLForDataType(contribution.getUser(), FileDataType.U_SMALL)%>" /></figure>
			<% } else { %>
			<figure style="border:5px solid #eee"><img src="https://irs2.4sqi.net/img/user/30x30/blank_girl.png" /></figure>
			<% } %>
			<div class="description" style="padding-top:0px">
				<h3 style="font-size:1.0em"><a href="<%=UserWallBean.getUserWallURL(request, contribution.getUserId())%>"><%=contribution.getUser().getName()%></a></h3>
				<% if(contribution.getUser().getCityId() > 0) { %>
				<p style="font-size:11px;width:100%">Based in <%=LocationData.getCityNameFromId(contribution.getUser().getCityId())%></p>
				<% } %>
				<p style="font-size:11px;width:100%;color:#777"><%=contribution.getReviewCount()%> Contributions</p>
			</div>
		</article>
		<% } %>	
		<div class="clearfix">
			<a href="/partner/list-product" style="font-size:12px">Sign up as an expert</a>
		</div>			
	</div>
</article>
<%  } %>
