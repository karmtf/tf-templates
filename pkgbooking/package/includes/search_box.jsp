<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="java.util.EnumSet"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.eos.packages.data.PackageConstants"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="com.eos.packages.data.PackageQuery"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<form
	action="<%=NavigationHelper.getFullyQualifiedHTTPServletURLByRole(request) %>"
	method="post" class="via_form" name="packageSearchForm">
	<%
	PackageQuery pgq = (PackageQuery) request.getAttribute(B2cNavigation.SEARCH_QUERY_ATTRIBUTE);
	String varname = request.getParameter("JS_VAR_NAME");
	if(varname==null) {
		varname = "packageSearchTab";
	}
	%>
	<script type="text/javascript">	
	<jsp:include page="/includes/holidayPackageCitiesJS.jsp"></jsp:include>
	</script>
<script type="text/javascript" src="/static/js/package/package_search.js?ver=<%=StaticFileVersions.JS_PACKAGE_SEARCH_VERSION %>&yui=<%=StaticFileVersions.YUI_VERSION %>"></script>
<script type="text/javascript">
var <%=varname%>;

$jQ(document).ready(function() {
	this.initFlt = function() {
		<%=varname%> = new PackageSearch("packageSearchForm",{});
	};
	setTimeout(this.initFlt,10);
});
</script>
<div class="package_search">
<div class="inpElement ps_intl">
<div class="inpField radio">
	<div id="buttongroup1" class="yui-buttongroup">
        <input type="radio" name="radiofield1" value="Domestic" checked>
        <input type="radio" name="radiofield1" value="International">
    </div>
</div>
</div>
<div class="inpElement ps_country">
<div class="inpName">Country</div>
<div class="inpField"><select name="country"
	onChange="refreshHolidayPackageCityList()">
	<option value="70">India</option>
</select></div>
</div>
<div class="inpElement ps_city">
<div class="inpName">City</div>
<div class="inpField"><select name="city"></select></div>
</div>
<div class="inpElement ps_type">
<div class="inpName">Package Type</div>
<div class="inpField"><select name="package_type">
	<%
	    EnumSet<PackageConstants.PackageType> packageTypes = EnumSet.allOf(PackageConstants.PackageType.class);

	    Iterator<PackageConstants.PackageType> packagetype_iterator = packageTypes.iterator();
	    while (packagetype_iterator.hasNext()) {
	        PackageConstants.PackageType packType = (PackageConstants.PackageType) packagetype_iterator.next();
	%>
	<option value=<%=packType.ordinal() %>><%=packType.m_name%></option>
	<%
	    }
	%>
</select></div>
</div>
<div class="inpElement via_submit">
<div class="inpField"><input type="button" name="search" value="Find Holiday &amp; Packages &raquo;"></div>
</div>
</div>
</form>