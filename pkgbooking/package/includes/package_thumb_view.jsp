<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="java.util.List"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE.toString());
	String clazz = StringUtils.trimToEmpty(request.getParameter("clazz"));

	List<String> cityItnNames = pkgConfig.getItineraryDisplayNames();
	String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, pkgConfig);
	String imageUrl = pkgConfig.getImageURL(request); 
	String imageUrlComplete = UIHelper.getImageURLForDataType(request, imageUrl, FileDataType.I150X75, true);
%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<div class="u_block">
	<div class="left">
		<img src="<%=imageUrlComplete%>" style="width:50px;height:40px" />
	</div>
	<div class="left mrgnL10" style="max-width:70%">
		<h3 style="font-size:13px;"><a title="<%=pkgConfig.getPackageName()%>" style="text-decoration:none" href="<%=pkgDetailUrl%>"><%=UIHelper.cutLargeText(pkgConfig.getPackageName(), 25)%></a></h3>
		<p style="font-size:11px;width:100%"><%=UIHelper.cutLargeText(ListUtility.toString(cityItnNames, " | "), 85)%></p>
		<% if(pkgConfig.getPricePerPerson() > 0) { %>
		<p style="font-size:15px;font-weight:bold;width:100%">
			<%=PackageDataBean.getPackagePricePerPersonDisplay(request, pkgConfig, false)%>
		</p>
		<% } %>
	</div>
</div>
