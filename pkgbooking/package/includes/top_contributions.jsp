<%@page import="org.apache.commons.lang.WordUtils"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="com.poc.server.tracking.database.model.PageMetaInfo"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.user.wall.UserWallBean"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.secondary.database.model.Contribution"%>
<%
	List<PackageConfigData> recentPkgs  = (List<PackageConfigData>) request.getAttribute(Attributes.RECENT_PACKAGE_CONFIGS.toString());
	List<Contribution> contributions  = (List<Contribution>) request.getAttribute(Attributes.CONTRIBUTIONS.toString());
%>
<% 
	if(recentPkgs != null && !recentPkgs.isEmpty()) { 
%>
	<article class="default clearfix sideBlock mrgn10T" id="rcmndCltCtr" style="display:none">
		<div class="deals">
			<h2 class="mrgn10B sideHeading">Recent trips created by travelers</h2>
			<% 
				for (PackageConfigData packageConfiguration : recentPkgs) { 
					User user = packageConfiguration.getCreatorUser();
					String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
					if(user != null) {
			%>
			<article class="full-width" style="padding:5px 5px 5px 0px">
				<% if(StringUtils.isNotBlank(user.getProfilePicURL())) { %>
				<div style="width:14%;float:left"><a href="<%=UserWallBean.getUserWallURL(request, user.getUserId())%>"><img src="<%=UIHelper.getProfileImageURLForDataType(user, FileDataType.U_SMALL)%>" style="height:40px" /></a></div>
				<% } else { %>
				<div style="width:14%;float:left"><a href="<%=UserWallBean.getUserWallURL(request, user.getUserId())%>"><img src="https://irs2.4sqi.net/img/user/30x30/blank_girl.png" style="height:40px" /></a></div>				
				<% } %>
				<div class="description" style="padding-top:0px;padding-left:10px">
					<h3 style="font-size:1.0em"><a class="productUrl" href="<%=pkgDetailUrl%>"><%=packageConfiguration.getPackageName()%></a></h3>
					<p style="font-size:11px;width:100%">
					<%=ListUtility.toString(packageConfiguration.getItineraryDisplayNames(), " | ")%>
					</p>
					<p style="font-size:11px;width:100%;color:#777">Created <%=DateUtility.getPrettyTimeDifference(new Date(), packageConfiguration.getGenerationTime())%> ago by <a href="<%=UserWallBean.getUserWallURL(request, user.getUserId())%>"><%=user.getName()%></a></p>
				</div>
			</article>
			<% } } %>
		</div>
	</article>
<%	} 
	if(contributions != null && !contributions.isEmpty()) {	
%>
<article class="default clearfix sideBlock mrgn10T" id="rcmndCltCtr">
	<div class="deals">
		<h2 class="mrgn10B sideHeading">Top Contributing Experts</h2>
		<% 
			for (Contribution contribution : contributions) {
		%>
		<article class="full-width" style="padding:5px 5px 5px 0px">
			<% if(StringUtils.isNotBlank(contribution.getUser().getProfilePicURL())) { %>
			<div style="float:left"><a href="<%=UserWallBean.getUserWallURL(request, contribution.getUserId())%>"><img src="<%=UIHelper.getProfileImageURLForDataType(contribution.getUser(), FileDataType.U_SMALL)%>" style="height:40px" /></a></div>
			<% } else { %>
			<div style="float:left"><a href="<%=UserWallBean.getUserWallURL(request, contribution.getUserId())%>"><img src="https://irs2.4sqi.net/img/user/30x30/blank_girl.png" style="height:40px" /></a></div>				
			<% } %>
			<div class="description" style="padding-top:0px;padding-left:10px">
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

