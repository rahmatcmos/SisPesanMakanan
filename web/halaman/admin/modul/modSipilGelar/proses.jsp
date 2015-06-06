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
        vNama = "",
        vSingkatan = "",
        vLetak = "",
        vCatatan = "",
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
            vNama = oKata.fSatuSpasi(request.getParameter("dtNama").toString());
            vSingkatan = oKata.fSatuSpasi(request.getParameter("dtSingkatan").toString());
            vLetak = oKata.fHapusSpasi(request.getParameter("dtLetak").toString());
            vCatatan = oKata.fSatuSpasi(request.getParameter("dtCatatan").toString());
            /* operasi basisdata */
            if(!vKode.equals("") && !vNama.equals("")){
                oOpsBasisdata.fOperasiBdDasar("",
                        vModKonfNamaBd, 
                        vModKonfNamaTabel,
                        new String[]{"kode"}, 
                        new String[]{vKode},
                        new String[]{"null",vKode,vNama,vSingkatan,vLetak,vCatatan}, "t",true);
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
            vNama = oKata.fSatuSpasi(request.getParameter("dtNama").toString());
            vSingkatan = oKata.fSatuSpasi(request.getParameter("dtSingkatan").toString());
            vLetak = oKata.fHapusSpasi(request.getParameter("dtLetak").toString());
            vCatatan = oKata.fSatuSpasi(request.getParameter("dtCatatan").toString());
            /* operasi basisdata */
            if(!vKode.equals("") && !vNama.equals("")){
                oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    vModKonfNamaTabel, 
                    new String[]{"kode"}, new String[]{vKode}, 
                    new String[]{"null",vKode,vNama,vSingkatan,vLetak,vCatatan}, 
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
        
    }
    
    out.println(vKeluaran);
%>