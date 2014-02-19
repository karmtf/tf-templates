<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%
	Destination content = (Destination) request.getAttribute(Attributes.DESTINATION.toString());
	DestinationContentOverride contentOverride = content.getContentOverride();
	String viewClass = StringUtils.trimToEmpty(request.getParameter("viewClass"));

	String name = (contentOverride != null && contentOverride.getName() != null) ? contentOverride.getName(): content.getName();
	String destinationURL = (contentOverride != null && contentOverride.getUrl() != null) ? contentOverride.getUrl(): DestinationContentBean.getDestinationContentURL(request, content);
	String descriptionText = UIHelper.extractRenderTextFromHTML(StringUtils.trimToEmpty((contentOverride != null && contentOverride.getDescription() != null) ? contentOverride.getDescription(): content.getDescription()));
	String moreButtonText = (contentOverride != null && contentOverride.getMoreButtonText() != null) ? contentOverride.getMoreButtonText(): "Read More";
%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.content.DestinationContentOverride"%>
<article class="default clearfix">
<div class="deal-of-the-day">
	<figure>
		<a href="<%=destinationURL%>">
			<img src="<%=UIHelper.getDestinationImageURLForDataType(request, content.getMainImage(), FileDataType.I300X150)%>" style="width:220px;height:150px;"/>
		</a>
	</figure>
	<h3><a title="<%=name%>" href="<%=destinationURL%>"><%=name%> Guide</a></h3>
	<% if (StringUtils.isNotBlank(descriptionText)) { %>
	<p style="width:100%"><%=StringUtility.truncateAtWord(descriptionText, 250, true)%></p>
	<% } %>
	<div class="readmore"><a href="<%=destinationURL%>" class="grBtn1" target="_blank"><%=moreButtonText%> &raquo;</a></div>
</div>
</article>