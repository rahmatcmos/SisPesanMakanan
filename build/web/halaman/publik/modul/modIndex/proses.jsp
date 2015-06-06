<%@page import="java.io.File"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsKode"%>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* konf */
    ClsKonf oKonf = new ClsKonf();
%>

<%
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    /* obyek basisdata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* variabel POST */
    String vOperasi = oKata.fHapusSpasi(request.getParameter("dtOperasi").toString()),
        vKodeProduk = "",
        vKodeFotoProduk = "",
        vNama = "",
        vFotoSampul = "",
        vKeterangan = "",
        vKeluaran="";
    
    if(!vOperasi.equals("")){
        
        /* ################### operasi tambah data */
        if(vOperasi.equals("t")){
           /* variabel POST */
            /* request berasal dari modRestoModalUploadFotoProduk/modal.jsp */
            vKodeProduk = oKata.fHapusSpasi(request.getParameter("dtKodeProduk").toString());
            vKodeFotoProduk = oKata.fHapusSpasi(request.getParameter("dtKodeFotoProduk").toString());
            
            /* operasi basisdata */
            int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisiArr("", 
                        "", 
                        vModKonfNamaTabel, 
                        new String[]{"kode"},
                        new String[]{"kode_resto_produk"},
                        new String[]{vKodeProduk},
                        new String[]{"="},
                        new String[]{""});
            vKeluaran = Integer.toString(vJumDataTotal);
            oOpsBasisdata.fTutupKoneksi();
            
        }
        
        /* ################### operasi ubah data */
        if(vOperasi.equals("u")){
            /* variabel POST */
            vKodeProduk = oKata.fHapusSpasi(request.getParameter("dtKodeProduk").toString());
            vKodeFotoProduk = oKata.fHapusSpasi(request.getParameter("dtKodeFotoProduk").toString());
            vNama = oKata.fSatuSpasi(request.getParameter("dtNama").toString());
            vFotoSampul = oKata.fHapusSpasi(request.getParameter("dtFotoSampul").toString());
            vKeterangan = oKata.fSatuSpasi(request.getParameter("dtKeterangan").toString());
            
            /* operasi basisdata */
            if(!vKodeProduk.equals("") && !vKodeFotoProduk.equals("")){
                /* foto sampul */
                System.out.println("Foto sampul: " + vFotoSampul);
                if(vFotoSampul.equals("1")){
                    /* set sampul foto yang lain = 0 dalam satu produk  */
                    oOpsBasisdata.fBeriNilaiSamaSemuaBarisPadaKolomX("", "", vModKonfNamaTabel, "sampul", "kode_resto_produk",vKodeProduk,"0");
                    
                }
                
                oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    vModKonfNamaTabel, 
                    new String[]{"kode"}, new String[]{vKodeFotoProduk}, 
                    new String[]{"null",vKodeFotoProduk,vNama,"null","null","null",vFotoSampul,vKeterangan,"null"}, 
                    "u",
                    true);
                
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisiArr("", 
                        "", 
                        vModKonfNamaTabel, 
                        new String[]{"kode"},
                        new String[]{"kode_resto_produk"},
                        new String[]{vKodeProduk},
                        new String[]{"="},
                        new String[]{""});
                vKeluaran = Integer.toString(vJumDataTotal);
                oOpsBasisdata.fTutupKoneksi();
            }
        }
        
        /* ################### operasi hapus data */
        if(vOperasi.equals("h")){
            /* variabel POST */
            vKodeProduk = oKata.fHapusSpasi(request.getParameter("dtKodeProduk").toString());
            vKodeFotoProduk = oKata.fHapusSpasi(request.getParameter("dtKodeFotoProduk").toString());
            //out.println(vKodeFotoProduk);
            /* hapus banyak data */
            if(vKodeFotoProduk.contains("#")){
                out.println("Ya mengandung #.");
                String[] vArrKode = vKodeFotoProduk.split("#");
                for(String vKodeHapus:vArrKode){
                    
                    /* # hapus berkas */
                    /* mengambil nama berkas */
                    String vNamaBerkas = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "nama_berkas", "kode", vKodeHapus);
                    String vEkstensi = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "ekstensi", "kode", vKodeHapus);
                    out.println("Hapus --> " + vKodeHapus);
                    out.println("Berkas --> " + vNamaBerkas + vEkstensi);
                    
                    File vFlBerkas = new File(ClsKonf.vKonfDirFoto + File.separator + "produk" + File.separator + vNamaBerkas + vEkstensi);
                    File vFlBerkasResize = new File(ClsKonf.vKonfDirFoto + File.separator + "produk" + File.separator + "r" + vNamaBerkas + vEkstensi);
                    File vFlBerkasThumbnail = new File(ClsKonf.vKonfDirFoto + File.separator + "produk" + File.separator + "t" + vNamaBerkas + vEkstensi);
                   
                    if(vFlBerkas.delete() && vFlBerkasResize.delete() && vFlBerkasThumbnail.delete()){
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel,new String[]{"kode"}, new String[]{vKodeHapus}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk produk ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_resto_produk"},new String[]{vKodeProduk},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                        out.println("Sudah dihapus.");
                    }else{
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel,new String[]{"kode"}, new String[]{vKodeHapus}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk produk ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_resto_produk"},new String[]{vKodeProduk},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                        out.println("Sudah dihapus.");
                    }
                    
                }
            }
            
            /* hapus data tunggal */
            if(!vKodeFotoProduk.contains("#")){
                /* operasi basisdata */
                if(!vKodeFotoProduk.equals("")){
                    /* # hapus berkas */
                    /* mengambil nama berkas */
                    String vNamaBerkas = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "nama_berkas", "kode", vKodeFotoProduk);
                    String vEkstensi = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "ekstensi", "kode", vKodeFotoProduk);
                    File vFlBerkas = new File(ClsKonf.vKonfDirFoto + File.separator + "produk" + File.separator + vNamaBerkas + vEkstensi);
                    File vFlBerkasResize = new File(ClsKonf.vKonfDirFoto + File.separator + "produk" + File.separator + "r" + vNamaBerkas + vEkstensi);
                    File vFlBerkasThumbnail = new File(ClsKonf.vKonfDirFoto + File.separator + "produk" + File.separator + "t" + vNamaBerkas + vEkstensi);
                    
                    System.out.println("Nama berkas: " + vNamaBerkas + vEkstensi);
                    
                    if(vFlBerkas.delete() && vFlBerkasResize.delete() && vFlBerkasThumbnail.delete()){
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel, new String[]{"kode"}, new String[]{vKodeFotoProduk}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk produk ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_resto_produk"},new String[]{vKodeProduk},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                    }else{
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel, new String[]{"kode"}, new String[]{vKodeFotoProduk}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk produk ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_resto_produk"},new String[]{vKodeProduk},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                    }
                    
                    
                    
                }
            }
        }
        
        /* ################### operasi ambil nama berkas */
        if(vOperasi.equals("b")){
           /* variabel POST */
            /* request berasal dari modRestoModalUploadFotoProduk/modal.jsp */
            vKodeProduk = oKata.fHapusSpasi(request.getParameter("dtKodeProduk").toString());
            vKodeFotoProduk = oKata.fHapusSpasi(request.getParameter("dtKodeFotoProduk").toString());
            
            String vNamaBerkas = oOpsBasisdata.fAmbilSatuData("", "", vModKonfNamaTabel, "nama_berkas", "kode", vKodeFotoProduk);
            vKeluaran = vNamaBerkas;
        }
        
    }
    
    out.println(vKeluaran);
%>