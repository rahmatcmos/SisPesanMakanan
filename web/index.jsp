<%@ page import="pilar.cls.ClsBerkasXML,pilar.cls.ClsKonf" %> 

<%
    ClsKonf oKonf = new ClsKonf();
    //response.sendRedirect(oKonf.vKonfURL + "/halaman/admin/modul/modOtentifikasi/index.jsp");
    response.sendRedirect(oKonf.vKonfURL + "/halaman/publik/modul/modIndex/index.jsp");
%>
