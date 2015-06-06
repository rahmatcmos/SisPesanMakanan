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
        vEmail = "",
        vSandi = "",
        vKeluaran="";
    
    if(!vOperasi.equals("")){
        
        /* ################### operasi tambah data */
        if(vOperasi.equals("m")){
            /* variabel POST */
            vEmail = oKata.fHapusSpasi(request.getParameter("dtEmail").toString());
            vSandi = oKata.fHapusSpasi(request.getParameter("dtSandi").toString());
            
            ClsSHA oSHA = new ClsSHA();
            String vSandiEnkripsi = oSHA.fSHA256(vSandi);
            /* operasi basisdata */
            if(!vEmail.equals("") && 
                    !vSandi.equals("")){
                
                String vSandiDB = oOpsBasisdata.fAmbilSatuData("", "", "tb_pelanggan", "sandi", "email", vEmail);
                
                if(vSandiEnkripsi.equals(vSandiDB)){
                    request.getSession(true);
                    /* memberi nilai pada sesi */
                    request.getSession().setAttribute("sesIDPub", vEmail);
                    request.getSession().setAttribute("sesSandiPub", vSandiDB);

                    /* memberi nilai pada cookie */
                    Cookie ckiEmail = new Cookie("ckiNamaPub", vEmail);
                    ckiEmail.setMaxAge(60*60*24*7); 

                    Cookie ckiSandi = new Cookie("ckiSandiPub", vSandiDB);
                    ckiSandi.setMaxAge(60*60*24*7);

                    /* kirim cookie ke browser */
                    response.addCookie(ckiEmail);
                    response.addCookie(ckiSandi);
                    
                    /* ambil kode orang */
                    String vKodeOrang = oOpsBasisdata.fAmbilSatuData("", "", "tb_pelanggan", "kode_orang", "email", vEmail);
                    /* ambil nama lengkap */
                    String vNamaLengkap = oOpsBasisdata.fAmbilSatuData("", "", "tb_sipil_orang", "nama_lengkap", "kode", vKodeOrang);
                    vKeluaran = "1#" + vNamaLengkap;
                }else{
                    vKeluaran = "0#";
                }
                
                
                oOpsBasisdata.fTutupKoneksi();
            }else{
                vKeluaran = "0#";
            }
        }
    }else{
        vKeluaran = "0#";
    }
    
    out.println(vKeluaran);
%>