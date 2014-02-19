<%@page import="java.util.List"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.accounts.database.model.HotelSupplierMap"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%
	int hotelId = RequestUtil.getIntegerRequestParameter(request, "hotelid", -1);
	int period = RequestUtil.getIntegerRequestParameter(request, "period", 1);
	String section = request.getParameter("page");
	String param = RequestUtil.getStringRequestParameter(request, "name", null);
	String value = RequestUtil.getStringRequestParameter(request, "value", null);
%>
<div class="crumbs">
	<ul id="breadcrumbs" class="breadcrumb"> 
		<li><a href="/">TripFactory</a></li>
		<li class="active"><a href="/partner/product-trends" title="">Dashboard</a></li>
	</ul>
	<ul class="alt-buttons">
		<li class="dropdown"><a href="#" title="" data-toggle="dropdown"><i class="icon-time"></i><span>Filter by Time Range</span> <strong>(<%=period%> day(s))</strong></a>
			<ul class="dropdown-menu pull-right">
				<li><a href="/partner/<%=section%>?period=1<%=(param != null) ? "&" + param + "=" + value: ""%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%>"><i class="icon-calendar"></i>24 Hours</a></li>
				<li><a href="/partner/<%=section%>?period=7<%=(param != null) ? "&" + param + "=" + value: ""%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%>"><i class="icon-calendar"></i>7 days</a></li>
				<li><a href="/partner/<%=section%>?period=14<%=(param != null) ? "&" + param + "=" + value: ""%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%>"><i class="icon-calendar"></i>14 days</a></li>
				<li><a href="/partner/<%=section%>?period=30<%=(param != null) ? "&" + param + "=" + value: ""%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%>"><i class="icon-calendar"></i>1 month</a></li>
			</ul>
		</li>
		<li class="dropdown" style="display:none"><a href="#" title="" data-toggle="dropdown"><i class="icon-map-marker"></i><span>Filter by Geography</span> <strong>(Global)</strong></a>
			<ul class="dropdown-menu pull-right">
				<li><a href="#" title=""><i class="icon-plus"></i>Bangalore</a></li>
				<li><a href="#" title=""><i class="icon-reorder"></i>Tokyo</a></li>
				<li><a href="#" title=""><i class="icon-cog"></i>Singapore</a></li>
				<li><a href="#" title=""><i class="icon-cog"></i>View All</a></li>
			</ul>
		</li>  
	</ul>
</div>
