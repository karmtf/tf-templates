<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%
	Destination content = (Destination) request.getAttribute(Attributes.DESTINATION.toString());
	String viewClass = StringUtils.trimToEmpty(request.getParameter("viewClass"));

	String destinationURL = DestinationContentBean.getDestinationContentURL(request, content);
	String descriptionText = UIHelper.extractRenderTextFromHTML(StringUtils.trimToEmpty(content.getDescription()));
%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<div class="u_block cntBlk cntShVw <%=viewClass%>">
	<div class="imgBlk">
		<a href="<%=destinationURL%>">
			<img src="<%=UIHelper.getDestinationImageURLForDataType(request, content.getMainImage(), FileDataType.I300X150)%>" style="width:220px;height:150px; border:1px solid #DDD"/>
		</a>
	</div>
	<div class="smryBlk">
		<h3 class="title"><a title="<%=content.getName()%>" href="<%=destinationURL%>"><%=content.getName()%></a></h3>
		<% if (StringUtils.isNotBlank(descriptionText)) { %>
			<p class="smry"><%=StringUtility.truncateAtWord(descriptionText, 170, true)%></p>
		<% } %>
		<a href="<%=destinationURL%>" class="readmore">Read More</a>
	</div>
</div>
