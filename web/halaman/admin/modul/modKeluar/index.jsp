<%@page import="pilar.cls.ClsKonf" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ClsKonf oKonf = new ClsKonf();
    session.invalidate();
    response.sendRedirect(ClsKonf.vKonfURL + "/index.jsp");    
%>