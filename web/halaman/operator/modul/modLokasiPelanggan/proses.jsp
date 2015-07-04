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
    
%>

<%
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    /* obyek basisdata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* variabel POST */
    String vOperasi = oKata.fHapusSpasi(request.getParameter("dtOperasi").toString()),
        vLintang = "",
        vBujur = "",
        vKodeOrang = "",
        vKodePelanggan = "",
        vAlamat = "",
        vCatatan = "",
        vKeluaran="";
    
    if(!vOperasi.equals("")){
        
        /* ################### operasi ubah data */
        if(vOperasi.equals("u")){
            /* variabel POST */
            vKodePelanggan = oKata.fHapusSpasi(request.getParameter("dtKodeOrang").toString());
            vLintang = oKata.fHapusSpasi(request.getParameter("dtLintang").toString());
            vBujur = oKata.fHapusSpasi(request.getParameter("dtBujur").toString());
            vAlamat = oKata.fSatuSpasi(request.getParameter("dtAlamat").toString());
            vCatatan = oKata.fSatuSpasi(request.getParameter("dtCatatan").toString());
            
            vKodeOrang = oOpsBasisdata.fAmbilSatuData("", "", "tb_pelanggan", "kode_orang", "kode", vKodePelanggan);
            /* operasi basisdata */
            if(!vLintang.equals("") && !vBujur.equals("")){
                
                /* periksa apakah data orang tsb sudah ada di basisdata */
                boolean vAdaData = oOpsBasisdata.fDataAda("", "", vModKonfNamaTabel, "kode_orang", vKodeOrang);
                
                if(vAdaData){
                    /* ubah data */
                    oOpsBasisdata.fOperasiBdDasar("", 
                        vModKonfNamaBd, 
                        vModKonfNamaTabel, 
                        new String[]{"kode_oran"}, new String[]{vKodeOrang}, 
                        new String[]{"null","null",vLintang,vBujur,vAlamat,vCatatan}, 
                        "u",
                        true);

                    int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode_orang"});
                    vKeluaran = Integer.toString(vJumDataTotal);
                    oOpsBasisdata.fTutupKoneksi();
                }else{
                    System.out.println("Tambah");
                    /* tambah data */
                     oOpsBasisdata.fOperasiBdDasar("", 
                        vModKonfNamaBd, 
                        vModKonfNamaTabel, 
                        new String[]{"kode_orang"}, new String[]{vKodeOrang}, 
                        new String[]{"null",vKodeOrang,vLintang,vBujur,vAlamat,vCatatan}, 
                        "t",
                        false);

                    int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode_orang"});
                    vKeluaran = Integer.toString(vJumDataTotal);
                    oOpsBasisdata.fTutupKoneksi();
                }
            }
        }
    }
    
    out.println(vKeluaran);
%>