<%
	String productType = request.getParameter("product");
	int selectedStep = StringUtility.parseInteger(request.getParameter("selectedStep"), 1);
	int stepWidth = StringUtility.parseInteger(request.getParameter("stepWidth"), -1);
	Map<String, String> steps = new LinkedHashMap<String, String>();
	if(productType != null && productType.equals("hotel")) {
		steps.put("link","Create Your Page");
		steps.put("link","Add Your Hotels");
		steps.put("link","Add Hotel Packages");
		steps.put("link","Get More Traffic and Customers");
	} else if(productType != null && productType.equals("tour operator")) {
		steps.put("/partner/config","Add New Itinerary");
		steps.put("/partner/edit-config","Add Day-wise Itinerary");
		steps.put("link2","Publish Itinerary");
		steps.put("link","Add Pricing for Itinerary");
	} else {
		steps.put("/partner/config","Add New Itinerary");
		steps.put("/partner/edit-config","Add Day-wise Itinerary");
		steps.put("link","Publish Itinerary");
	}
	int totalSteps = steps.size();
	int lastStepMargin = (totalSteps - 1) * (stepWidth + 10);
%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.ArrayList"%>
<ul class="stpHdr" style="margin-bottom:20px">
<%
	int stepCount = 0;
	for (String link : steps.keySet()) { 
		String step = steps.get(link);
	    stepCount++;
	    boolean isSelected = (stepCount == selectedStep);
	    boolean isLastStep = (stepCount == totalSteps);
	    String sepClazz = (isSelected ? "stpG01": (stepCount == (selectedStep - 1) ? "stpG10": "stpG11"));
	    if(!link.equals("link")) {
%>
	<li class="<%=sepClazz%>" <%=(stepWidth > 0) ? "style=\"" + (isLastStep ? "margin-left:" + lastStepMargin + "px;": "width:" + stepWidth + "px;") + "\"": ""%> <%=isLastStep ? "class=\"stpLst\"": ""%>><div class="stp <%=isSelected ? "stpSl": ""%>"><span><b>Step <%=stepCount%>.</b></span> <a href="<%=link%>"><%=step%></a> &rarr;</div></li>
<% } else { %>
	<li class="<%=sepClazz%>" <%=(stepWidth > 0) ? "style=\"" + (isLastStep ? "margin-left:" + lastStepMargin + "px;": "width:" + stepWidth + "px;") + "\"": ""%> <%=isLastStep ? "class=\"stpLst\"": ""%>><div class="stp <%=isSelected ? "stpSl": ""%>"><span><b>Step <%=stepCount%>.</b></span> <b><%=step%></b></div></li>
<% } %>
<% } %>
<div class="clearfix"></div>
</ul>
<style type="text/css">
.stp {
font-size:12px;
font-weight:normal;
}
</style>
