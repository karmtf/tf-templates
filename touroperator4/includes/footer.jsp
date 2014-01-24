<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.UIConfig"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%
	User user = SessionManager.getUser(request);
	boolean hideFooter = UIConfig.isHideFooter(request);
%>
<footer style="padding-bottom:30px;">

<div class="row-fluid footer">
    	<div class="span12">
        	<div class="container">
                        <div class="footer_menu2">
                            <ul>
                            
                    <li><a href="/tours/welcome" style="padding-left:0">Home</a></li>
					<li><a href="/tours/packages">Packages</a></li>
					<li><a href="/tours/tips">Travel Guide</a></li>
					<li><a href="/tours/reviews">Travel Tips</a></li>
					<li><a href="/tours/contactus">Contact</a></li>
                            </ul>
                        </div>
                </div>
        </div>
    </div>
</div>


</footer>
