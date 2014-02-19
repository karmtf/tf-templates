<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.holiday.data.PackageGroupResultItem"%>
<%@page import="java.util.List"%>
<%
	List<PackageGroupResultItem> pkgsGroupList = (List<PackageGroupResultItem>) request.getAttribute(Attributes.PACKAGE_GROUP_RESULT.toString());
%>
<%
	for (PackageGroupResultItem pkgGroup: pkgsGroupList) {
	    request.setAttribute(Attributes.PACKAGE_GROUP.toString(), pkgGroup);
%>
	<jsp:include page="pkg_group_view.jsp"/>
<% } %>
