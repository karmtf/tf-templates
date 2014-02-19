<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%
	List<PackageConfigData> packagesList = (List<PackageConfigData>) request.getAttribute(Attributes.PACKAGE_LIST.toString());
	String viewClass = StringUtils.trimToEmpty(request.getParameter("clazz"));
	boolean showRecommended = Boolean.parseBoolean(request.getParameter("showRecommended"));

	int itemCount = 0;
	for (PackageConfigData packageConfiguration: packagesList) {
	    request.setAttribute(Attributes.PACKAGE.toString(), packageConfiguration);
	    itemCount++;
%>
	<jsp:include page="package_short_view.jsp">
		<jsp:param name="showPick" value="true"/>
		<jsp:param name="clazz" value="<%=viewClass + (showRecommended ? " recommend":"")%>" />
	</jsp:include>
<% } %>