<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.data.UserBean"%>
<%@page import="java.util.List"%>
<%@page import="com.poc.server.secondary.database.model.UserEntityList"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%
	User publicUser = UserBean.getPublicUser(request, false);
	List<UserEntityList> entityLists = (List<UserEntityList>) request.getAttribute(Attributes.USER_ENTITY_LISTS.toString());
%>
<%@page import="com.poc.server.user.entity.UserEntityBean"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=UIHelper.getPageTitle(request, UIHelper.getUserPossessiveFirstName(publicUser) + " Wish Lists")%></title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<div class="main" role="main">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">
		<% if (entityLists != null && !entityLists.isEmpty()) { %>
			<h3><b><%=UIHelper.getUserPossessiveFirstName(publicUser)%> Wish Lists</b></h3>
			<%
				for (UserEntityList entityList: entityLists) {
			%>
				<div class="posR" style="display:inline-block; margin:15px 25px 15px 0;">
					<a href="<%=UserEntityBean.getEntityListURL(request, entityList)%>" style="display:block; height:200px; text-align:center;">
						<div style="position:absolute; top:0; border:1px solid #d0d0d0; padding:3px; background:#fff; border-radius:2px; height:185px; width:277px;"><img src="<%=UserEntityBean.getImageForEntityList(entityList)%>" style="border:1px solid #777; height:183px; width:275px;"></div>
						<div style="top:0; left:0; width:280px;">
							<div style="position:relative; text-align:center; display:inline-block; margin-top:69px; max-width:210px;">
								<div style="padding:5px 10px; max-width:200px; background-color:rgba(11, 11, 12, 0.7); color:#fff; border-radius:5px;">
									<h4 style="font-size:13px; padding:0; margin:2px 0;"><%=entityList.getListName()%></h4>
									<div style="color:#bbb; font-size:11px;"><%=(entityList.getEntityWrappers() != null) ? entityList.getEntityWrappers().size(): 0%> Listings</div>
								</div>
							</div>
						</div>
					</a>
				</div>
			<% } %>
		<% } else { %>
			<div style="margin:4em 0;">
				<div class="u_alignC noDtBB dkC">
					<p>You haven't created any wish list yet</p>
				</div>
			</div>
		<% } %>
		</div>
	<!--//main content-->
	</div>
</div>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp"></jsp:include>
</body>
</html>