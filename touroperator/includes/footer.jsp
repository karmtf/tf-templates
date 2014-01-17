<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.UIConfig"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.partner.config.PartnerConfiguration"%>
<!--header-->
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>

<%

	User user = SessionManager.getUser(request);
	boolean hideFooter = UIConfig.isHideFooter(request);
	PartnerConfigData partnerConfigData = PartnerConfigManager.getCurrentPartnerConfig();
	User partnerUser = null;
	if (partnerConfigData != null && partnerConfigData.getConfig() != null) {
        PartnerConfiguration partnerConfig = partnerConfigData.getConfig();
		partnerUser = partnerConfig.getPartnerUser();       
	}
%>

	<footer><div class="container_12">
		
		<nav class="grid_8">
			<a href="/tours/welcome">Home</a>
			<a href="/tours/packages">Packages</a>
			<a href="/tours/tips">Travel Guide</a>
			<a href="/tours/reviews">Travel Tips</a>
			<a href="/tours/contactus" class="selected">Contact</a>
		</nav>

		<p class="address grid_4">
			<strong><%=partnerUser.m_name%></strong><br />
			<span><%=partnerUser.m_street%>, 
				<%=LocationData.getCityNameFromId(partnerUser.getCityId())%> - <%=partnerUser.m_pincode%></span>
			<span><a href="mailto:karmveer@apniwali.com"><%=partnerUser.m_email%></a></span>
		</p>

		<p class="copyright grid_8">
			© 2014 <%=SettingsController.getApplicationName()%>
		</p>

	</div></footer>
