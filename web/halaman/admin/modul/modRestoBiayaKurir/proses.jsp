<%@page import="java.time.Instant"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
    /* ################### memeriksa sesi halaman admin */
    ClsKonf oKonf = new ClsKonf();
    ClsAdmin oAdmin = new ClsAdmin();
    
    try{
        if(session.getAttribute("sesID") != "" && !session.getId().equals("")){
            boolean vStatusSesi = oAdmin.fHalamanAdmin(session);
            if(!vStatusSesi){
                response.sendRedirect(ClsKonf.vKonfURL);
            }
        }
    }catch(Exception e){
        response.sendRedirect(ClsKonf.vKonfURL);
    }
%>

<%
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    /* obyek basisdata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* variabel POST */
    String vOperasi = oKata.fHapusSpasi(request.getParameter("dtOperasi").toString()),
        vBiaya = "",
        vTanggal = "",
        vJam = "",
        vTimestamp = "",
        vKeluaran = "";
    
    if(!vOperasi.equals("")){
        
        /* ################### operasi ubah data */
        if(vOperasi.equals("u")){
            /* variabel POST */
            vBiaya = oKata.fSatuSpasi(request.getParameter("dtBiaya").toString());
            /* tanggal & jam */
            Date oTanggalKini = new Date();
            SimpleDateFormat oFormatTanggal = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat oFormatWaktu = new SimpleDateFormat("HH:mm");
    
            vTanggal = oFormatTanggal.format(oTanggalKini);
            vJam = oFormatWaktu.format(oTanggalKini);
            
            /* timestamp */
            long vUnixTimestamp = Instant.now().getEpochSecond();
            vTimestamp = String.valueOf(vUnixTimestamp);
            
            /* operasi basisdata */
            if(!vBiaya.equals("")){
                oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    vModKonfNamaTabel, 
                    new String[]{"nomor"}, new String[]{"1"}, 
                    new String[]{"null",vBiaya,vTanggal,vJam,vTimestamp}, 
                    "u",
                    true);
                
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                vKeluaran = Integer.toString(vJumDataTotal);
                oOpsBasisdata.fTutupKoneksi();
            }
        }
    }
    
    out.println(vKeluaran);
%>