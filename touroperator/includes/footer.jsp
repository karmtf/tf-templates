<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.UIConfig"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%
	User user = SessionManager.getUser(request);
	boolean hideFooter = UIConfig.isHideFooter(request);
%>

	<footer><div class="container_12">
		
		<nav class="grid_8">
			<a href="/tours/welcome">Home</a>
			<a href="/tours/packages">Packages</a>
			<a href="/tours/reviews">Travel Guide</a>
			<a href="/tours/tips">Travel Tips</a>
			<a href="/tours/contactus" class="selected">Contact</a>
		</nav>

		<p class="address grid_4">
			<strong>apniwali dot com </strong><br />
			<span>Somewhere in bangalore</span><br />
			<span><a href="mailto:karmveer@apniwali.com">karmveer@apniwali.com</a></span>
		</p>

		<p class="copyright grid_8">
			© 2014 apniwali Travel Agency
		</p>

	</div></footer>
