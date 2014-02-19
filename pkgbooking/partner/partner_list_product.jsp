<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.util.SocialMediaHelper"%>
<%
	String message = request.getParameter(Attributes.MESSAGE_TITLE.toString());
	User loggedInUser = SessionManager.getUser(request);
	boolean isLoggedIn = (loggedInUser != null);
%>
<html>
<head>
<title>List Your Travel Offerings</title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
<style type="text/css">
.mainHeading {border-bottom:1px solid #eee;font-size:18px;padding-bottom:10px;color:rgb(0, 139, 218)}
.prtnrThks {font-size:14px;}
.search-main {width:47%}
.points li, .steps li {
font-size: 20pt;
padding: 5px 30px;
vertical-align: middle;
list-style: decimal;
margin-left: 15px;
float: left;
list-style-position: inside;
}
.steps {max-width:25%;}
.steps figure {font-size:20pt;width}
.steps .desc, .points .desc {
font-size: 13px;
line-height: 22px;
vertical-align: middle;
display: inline-block;
}
aside {width:20%;padding:20px;}
aside ul li {list-style-type:disc;text-align:left;}
.imgdock{padding:5px;margin:20px 0;border:1px solid #ddd;}
.booking .f-item {width:98%}
.three-fourth {width:60%;}
.right-sidebar {width:35%;}
.inner-nav {width:20%;}
.inner-nav li {width:90%;-webkit-border-radius:0;border-radius:0;padding:16px 0px 16px 16px;background:#fff;}
.inner-nav li a {text-align:left;font-size:14px}
.inner-nav li.active {background:#e1e7f4;}
.tab-content {border:1px solid #eee;}
h5 {font-size:17px;font-weight:normal;margin-bottom:15px;}
.locations .full-width figure {width:12%}
@media screen and (max-width: 600px) {
	aside {width:90%;padding:15px 10px}
}
@media screen and (max-width: 830px) {
.search-main {width:100%}
.three-fourth {width:100%;}
.right-sidebar {width:100%;}
.inner-nav {width:100%;}
}
.invalid-inp {color:red;}
</style>
<script type="text/javascript">
$jQ(document.partnerLForm).validate({
	rules: {"name": {required: true, minlength:3, maxlength:50}, "email":{required: true, email: true}},
	messages: {"name": {required: "Please enter your full name", minlength: "Name must be valid."}
	, "email":{required: "Please enter a valid email to signup", email: "Please enter a valid email to signup"}}
});
function submitPartnerLead() {
	if(!$jQ(document.partnerLForm).valid()) {
		return false;
	}
	document.partnerLForm.submit();
}
</script>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<div class="main" role="main" style="background:#fff">
	<div class="wrap clearfix">
		<div class="content clearfix" style="padding-top:0px">
			<% if(message != null) { %>
			<h2><%=message%> Please login <a href="/signup">here</a></h2>
			<% } %>
			<section id="section0" data-anchor="signup" class="section active-section mrgnT">
				<div class="mrgnT full-width u_alignC">
					<h1 style="color:#333;padding:0;font-size:20px">Create Your Page</h1>
					<h4 class="mrgn10T">Make your knowledge work for you to get business. <a href="/gen/help/how-to-sell">Learn More</a></h4>
				</div>
				<section class="three-fourth">
					<article>
						<p class="mrgnT">
						   <img src="http://images.tripfactory.com/static/img/help/infographics.png" style="width:75%;">
						</p>
					</article>
				</section>
				<aside class="right-sidebar" style="margin-bottom:0;padding:0">
					<article style="padding-top:0">
						<form name="partnerLForm" method="post" id="partnerLForm" class="booking wideL" style="box-shadow:none;-webkit-box-shadow:none;background:none;padding:0" action="/user/signup">
							<div class="row row1">
								<div class="f-item">
									<label for="first_name">Name</label>
									<input type="text" name="name" value="<%=(loggedInUser != null) ? StringUtils.trimToEmpty(loggedInUser.getName()):""%>"/>
								</div>
							</div>
							<div class="row row1">
								<div class="f-item">
									<label for="first_name">Email</label>
									<input type="text" name="email" value="<%=(loggedInUser != null)?StringUtils.trimToEmpty(loggedInUser.getEmail()):""%>"/>
								</div>
							</div>
							<div class="row row1">
								<div class="f-item">
									<label for="first_name">Password</label>
									<input type="password" name="password" />
								</div>
							</div>
							<div class="row row1">
								<div class="f-item">
									<label for="first_name">I am a:</label>
									<label><input type="radio" name="cat" value="<%=PartnerType.HOTEL.name()%>">&nbsp;<%=PartnerType.HOTEL.getDisplayText()%></label>
									<label><input type="radio" name="cat" value="<%=PartnerType.TOUR_OPERATOR.name()%>">&nbsp;Tour/Package Operator</label>
									<label><input type="radio" name="cat" value="<%=PartnerType.GUEST_HOUSE.name()%>">&nbsp;Guest House, Apartment or Holiday Home</label>
									<label><input type="radio" name="cat" value="<%=PartnerType.TRAVEL_AGENT.name()%>">&nbsp;Travel Expert/Agent</label>
									<label><input type="radio" name="cat" value="<%=PartnerType.TRAVEL_EXPERT.name()%>">&nbsp;Activity Operator or Tour Guide</label>
									<label><input type="radio" name="cat" value="<%=PartnerType.OTHER.name()%>">&nbsp;<%=PartnerType.OTHER.getDisplayText()%></label>
								</div>
							</div>
							<div class="row row5 btnPos right">
								<a href="#" class="search-button" onclick="submitPartnerLead(); return false;">Create My Page &raquo;</a>
								<img src="http://images.tripfactory.com/static/img/elements/free.png" style="margin-top: 6px;" />
							</div>
							<div class="clearfix"></div>
							<p class="mrgnT">
								<a href="/signup">Login here</a>
							</p>
						</form>
					</article>
				</aside>
			</section>
		</div>
	</div>
</div>
<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
