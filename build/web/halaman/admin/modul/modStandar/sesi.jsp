<%@page import="pilar.cls.clsKonf,pilar.cls.clsAdmin" %>

<%  
    /* memeriksa sesi halaman admin */
    clsKonf oKonf = new clsKonf();
    clsAdmin oAdmin = new clsAdmin();
    try{
        if(session.getAttribute("sesID") != "" && !session.getId().equals("")){
            boolean vStatusSesi = oAdmin.fHalamanAdmin(session);
            if(!vStatusSesi){
                response.sendRedirect(clsKonf.vKonfURL);
            }
        }
    }catch(Exception e){
        response.sendRedirect(clsKonf.vKonfURL);
    }
 %>