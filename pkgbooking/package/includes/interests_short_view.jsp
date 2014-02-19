<%
	String desc = request.getParameter("desc");
	String imgLink = request.getParameter("img");
	String query = request.getParameter("query");
	String text = request.getParameter("text");
%>
<div class="pkgSmV">
<div class="imgCtr">		
<div class="pkgDescT" style="position: absolute; top: 10px; z-index: 3; display: none;">
<div style="position: absolute; width: 220px; height: 165px; background: none repeat scroll 0% 0% rgb(255, 255, 255); opacity: 0.8;"></div>
<div style="position: absolute; width: 220px; color:#333333; top: 10px;">
		<div style="padding: 5px; font-weight: bold; line-height: 18px;">
			<%=desc%>
		</div>
	</div>
</div>
<a href="/holidays/movenpick-burdubai-191" style="position: relative; display: block; text-decoration: none;">
<img height="165" width="220" src="<%=imgLink%>">
</a>
</div>
<span class="pNm" style="height: 20px; margin-top: 10px; margin-bottom: 0pt;"><a style="text-decoration:none;color:#F78C0D;" title="Movenpick Burdubai" href="/holidays/movenpick-burdubai-191"><%=text%></a>
</span>
</div>
