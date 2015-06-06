<%@page import="java.time.Instant"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="pilar.cls.ClsSHA"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsKode"%>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* obyek konfigurasi */
    ClsKonf oKonf = new ClsKonf();
    
%>

<%
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    /* obyek basisdata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* variabel POST */
    String vOperasi = oKata.fHapusSpasi(request.getParameter("dtOperasi").toString()),
        vNama= "",
        vEmail = "",
        vPerihal = "",
        vKomentar = "",
        vTanggal = "",
        vJam = "",
        vTimeStamp = "",
        vKeluaran="";
    
    if(!vOperasi.equals("")){
        
        /* ################### operasi tambah data */
        if(vOperasi.equals("m")){
            /* variabel POST */
            vNama = oKata.fSatuSpasi(request.getParameter("dtNama").toString());
            vEmail = oKata.fHapusSpasi(request.getParameter("dtEmail").toString());
            vPerihal = oKata.fSatuSpasi(request.getParameter("dtPerihal").toString());
            vKomentar = oKata.fSatuSpasi(request.getParameter("dtKomentar").toString());
            
            /* tanggal & jam */
            Date oTanggalKini = new Date();
            SimpleDateFormat oFormatTanggal = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat oFormatWaktu = new SimpleDateFormat("HH:mm");
    
            vTanggal = oFormatTanggal.format(oTanggalKini);
            vJam = oFormatWaktu.format(oTanggalKini);
            
            /* timestamp */
            long vUnixTimestamp = Instant.now().getEpochSecond();
            vTimeStamp = String.valueOf(vUnixTimestamp);
            
            
            
            if(!vNama.equals("") && 
                    !vEmail.equals("") && 
                    !vPerihal.equals("") &&
                    !vKomentar.equals("")){
            
                    /* tambah data */
                     oOpsBasisdata.fOperasiBdDasar("", 
                        vModKonfNamaBd, 
                        vModKonfNamaTabel, 
                        new String[]{"email"}, new String[]{vEmail}, 
                        new String[]{"null",vNama,vEmail,vPerihal,vKomentar,vTanggal,vJam,vTimeStamp}, 
                        "t",
                        true);
            }
        }
    }
    
    out.println(vKeluaran);
%>