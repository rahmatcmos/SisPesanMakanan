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
        vKode = "",
        vKodeOrang = "",
        vNama = "",
        vKodeDepartemen = "",
        vKodePekerjaan = "",
        vCatatan = "",
        vTanggalMasuk = "",
        vTanggalBerhenti = "",
        vAktif = "",
        vKeluaran="";
    
    if(!vOperasi.equals("")){
        /* operasi membuat kode baru */
        if(vOperasi.equals("k")){
            ClsKode oKode = new ClsKode();
            String vKodeAcak = vModKonfKodeAwal + oKode.fBuatKodeAcak(6).toUpperCase();
            vKeluaran = vKodeAcak;
        }
        
        /* ################### operasi tambah data */
        if(vOperasi.equals("t")){
            /* variabel POST */
            vKode = oKata.fHapusSpasi(request.getParameter("dtKode").toString());
            vKodeOrang = oKata.fHapusSpasi(request.getParameter("dtKodeOrang").toString());
            vNama = oKata.fSatuSpasi(request.getParameter("dtNama").toString());
            vKodeDepartemen = oKata.fSatuSpasi(request.getParameter("dtKodeDepartemen").toString()).substring(0,8);
            vKodePekerjaan = oKata.fSatuSpasi(request.getParameter("dtKodePekerjaan").toString()).substring(0,8);
            vTanggalMasuk = oKata.fHapusSpasi(request.getParameter("dtTanggalMasuk").toString());
            vTanggalBerhenti = oKata.fHapusSpasi(request.getParameter("dtTanggalBerhenti").toString());
            vAktif = oKata.fHapusSpasi(request.getParameter("dtAktif").toString());
            vCatatan = oKata.fSatuSpasi(request.getParameter("dtCatatan").toString());
            /* operasi basisdata */
            if(!vKode.equals("") && !vNama.equals("")){
                /* tambah data */
                oOpsBasisdata.fOperasiBdDasar("",
                        vModKonfNamaBd, 
                        vModKonfNamaTabel,
                        new String[]{"kode"}, 
                        new String[]{vKode},
                        new String[]{"null",vKode,vNama,vCatatan,vKodeDepartemen,vKodePekerjaan,vKodeOrang,vTanggalMasuk,vTanggalBerhenti,vAktif}, "t",true);
                /* jumlah data total menyesuaikan dengan */
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                vKeluaran = Integer.toString(vJumDataTotal);
                oOpsBasisdata.fTutupKoneksi();
            }
        }
        
        /* ################### operasi ubah data */
        if(vOperasi.equals("u")){
            /* variabel POST */
            vKode = oKata.fHapusSpasi(request.getParameter("dtKode").toString());
            vKodeOrang = oKata.fHapusSpasi(request.getParameter("dtKodeOrang").toString());
            vNama = oKata.fSatuSpasi(request.getParameter("dtNama").toString());
            vKodeDepartemen = oKata.fSatuSpasi(request.getParameter("dtKodeDepartemen").toString()).substring(0,8); /* kode: 0-8 */
            vKodePekerjaan = oKata.fSatuSpasi(request.getParameter("dtKodePekerjaan").toString()).substring(0,8); /* kode: 0-8 */
            vTanggalMasuk = oKata.fHapusSpasi(request.getParameter("dtTanggalMasuk").toString());
            vTanggalBerhenti = oKata.fHapusSpasi(request.getParameter("dtTanggalBerhenti").toString());
            vAktif = oKata.fHapusSpasi(request.getParameter("dtAktif").toString());
            vCatatan = oKata.fSatuSpasi(request.getParameter("dtCatatan").toString());
            /* operasi basisdata */
            if(!vKode.equals("") && !vNama.equals("")){
                oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    vModKonfNamaTabel, 
                    new String[]{"kode"}, new String[]{vKode}, 
                    new String[]{"null",vKode,vNama,vCatatan,vKodeDepartemen,vKodePekerjaan,vKodeOrang,vTanggalMasuk,vTanggalBerhenti,vAktif}, 
                    "u",
                    true);
                
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                vKeluaran = Integer.toString(vJumDataTotal);
                oOpsBasisdata.fTutupKoneksi();
            }
        }
        
        /* ################### operasi hapus data */
        if(vOperasi.equals("h")){
            /* variabel POST */
            vKode = oKata.fHapusSpasi(request.getParameter("dtKode").toString());
            out.println(vKode);
            /* hapus banyak data */
            if(vKode.contains("#")){
                out.println("Ya mengandung #.");
                String[] vArrKode = vKode.split("#");
                for(String vKodeHapus:vArrKode){
                    out.println("Hapus --> " + vKodeHapus);
                    oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel,new String[]{"kode"}, new String[]{vKodeHapus}, new String[]{""}, "h", true);
                    int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                    oOpsBasisdata.fTutupKoneksi();
                    vKeluaran = Integer.toString(vJumDataTotal);
                }
            }
            
            /* hapus data tunggal */
            if(!vKode.contains("#")){
                /* operasi basisdata */
                if(!vKode.equals("")){
                    oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel,new String[]{"kode"}, new String[]{vKode}, new String[]{""}, "h", true);
                    int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                    oOpsBasisdata.fTutupKoneksi();
                    vKeluaran = Integer.toString(vJumDataTotal);
                }
            }
        }
        
        /* operasi select */
        if(vOperasi.equals("s")){
        
            /* kode data */
            String vPostKodeData = oKata.fHapusSpasi(request.getParameter("dtKodeData").toString());
            String vPostKodeRef = oKata.fHapusSpasi(request.getParameter("dtKodeRef").toString());
            
            /* 1) data provinsi */
            if(vPostKodeData.equals("pekerjaan")){
                String vKodeDepartemenRef = vPostKodeRef.substring(0,8);
                ResultSet vArrDataProvinsi = oOpsBasisdata.fArrAmbilDataDbKondisi("", "", 
                        "tb_resto_pekerjaan", new String[]{"kode","nama"}, 
                        new String[]{"kode_resto_departemen",vKodeDepartemenRef}, "nomor", "ASC", new String[]{""}, "=");
                
                /* iterasi */
                StringBuilder vSbJSON = new StringBuilder();
                /* pembuka tag data json */
                vSbJSON.append("[");
                int j = 0;
                boolean vBarisPertama = true;
                while(vArrDataProvinsi.next()){
                    j += 1;
                    if(vBarisPertama){
                        vSbJSON.append("{\"kode\":\""); 
                        vSbJSON.append(vArrDataProvinsi.getString("kode"));
                        vSbJSON.append("\", "); 
                        vSbJSON.append("\"nama\":\"");
                        vSbJSON.append(vArrDataProvinsi.getString("nama"));
                        vSbJSON.append("\""); 
                        vSbJSON.append("}");
                        vBarisPertama = false;
                    }else{
                        vSbJSON.append(","); 
                        vSbJSON.append("{\"kode\":\""); 
                        vSbJSON.append(vArrDataProvinsi.getString("kode"));
                        vSbJSON.append("\", "); 
                        vSbJSON.append("\"nama\":\"");
                        vSbJSON.append(vArrDataProvinsi.getString("nama"));
                        vSbJSON.append("\""); 
                        vSbJSON.append("}");
                    }
                }
                vSbJSON.append("]");
                /* keluaran */
                vKeluaran = j + "@" + vSbJSON.toString();
            }
            
        }
        
    }
    
    out.println(vKeluaran);
%>