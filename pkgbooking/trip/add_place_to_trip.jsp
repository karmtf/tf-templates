<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<html>
<head>
<jsp:include page="<%=SystemProperties.getHeadTagsPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
<title>Add to Trip</title>
</head>

<body>
<jsp:include page="/common/includes/viacom/header.jsp" />

	<jsp:include page="includes/add_place_to_trip.jsp"/>

<jsp:include page="/common/includes/viacom/footer.jsp"/>
</body>
</html>
