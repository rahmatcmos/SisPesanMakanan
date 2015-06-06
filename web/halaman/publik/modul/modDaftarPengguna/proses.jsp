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
        vNamaDepan = "",
        vNamaBelakang = "",
        vJenisKelamin = "",
        vTanggalLahir="",
        vKeluaran="",
        vNamaLengkap = "";
    
    if(!vOperasi.equals("")){
        
        /* ################### operasi tambah data */
        if(vOperasi.equals("t")){
            /* variabel POST */
            vEmail = oKata.fHapusSpasi(request.getParameter("dtEmail").toString());
            vSandi = oKata.fHapusSpasi(request.getParameter("dtSandi").toString());
            vNamaDepan = oKata.fSatuSpasi(request.getParameter("dtNamaDepan").toString()); 
            vNamaBelakang = oKata.fSatuSpasi(request.getParameter("dtNamaBelakang").toString());
            vJenisKelamin = oKata.fHapusSpasi(request.getParameter("dtJenisKelamin").toString());
            vTanggalLahir = oKata.fHapusSpasi(request.getParameter("dtTanggalLahir").toString());
            vNamaLengkap = vNamaDepan + " " + vNamaBelakang;
            
            ClsSHA oSHA = new ClsSHA();
            String vSandiEnkripsi = oSHA.fSHA256(vSandi);
            /* operasi basisdata */
            if(!vEmail.equals("") && 
                    !vSandi.equals("") && 
                    !vNamaDepan.equals("") &&
                    !vNamaBelakang.equals("") && 
                    !vJenisKelamin.equals("") &&
                    !vTanggalLahir.equals("")){
                /* membuat kode acak */
                ClsKode oKode = new ClsKode();
                String vKodeAcakOrang = "OR" + oKode.fBuatKodeAcak(14).toUpperCase();
                String vKodeAcakPelanggan = "PG" + oKode.fBuatKodeAcak(14).toUpperCase();
                
                Calendar now = Calendar.getInstance();
                
                String vTahunKini = String.valueOf(now.get(Calendar.YEAR));
                String vBulanKini =  String.valueOf(now.get(Calendar.MONTH) + 1);
                String vHariKini = String.valueOf(now.get(Calendar.DATE));
                String vTanggalKini = vTahunKini + "-" + vBulanKini + "-" + vHariKini;
                
                /* masukkan ke tabel orang */
                oOpsBasisdata.fOperasiBdDasar("",
                        vModKonfNamaBd, 
                        "tb_sipil_orang",
                        new String[]{"kode"}, 
                        new String[]{vKodeAcakOrang},
                        new String[]{"null",
                            vKodeAcakOrang,
                            "",
                            vNamaDepan,
                            vNamaBelakang,
                            vNamaLengkap.trim(),
                            vJenisKelamin,
                            "",
                            "",
                            "",
                            "",
                            vTanggalLahir,
                            ""}, "t",true);
                
                /* masukkan ke tabel pelanggan */
                oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    "tb_pelanggan", 
                    new String[]{"kode"}, new String[]{vKodeAcakPelanggan}, 
                    new String[]{"null",
                        vKodeAcakPelanggan,
                        vEmail,vSandiEnkripsi,
                        vKodeAcakOrang,vTanggalKini}, 
                    "t",
                    true);
                
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                vKeluaran = "1";
                oOpsBasisdata.fTutupKoneksi();
            }
        }
    }
    
    out.println(vKeluaran);
%>