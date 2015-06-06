package pilar.cls;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

public class ClsKeranjang {
    
    public final List<ClsProduk> vArrProduk = new ArrayList<>();
    private double vPrvTotal;
    
    public List<ClsProduk> ClsKeranjangBaru(HttpServletRequest vFRequest, String vFNamaCookie){
        
        String cookieName = vFNamaCookie;
        Cookie cookies [] = vFRequest.getCookies ();
        Cookie vCookieProduk = null;
        if(cookies != null){
            for(int i = 0; i < cookies.length; i++){
                if (cookies [i].getName().equals (cookieName)){
                    vCookieProduk = cookies[i];
                    break;
                }
            }
        }
        
        //System.out.println("Nilai cookie -->" +  vCookieProduk.getValue());
        /* buat daftar produk berdasarkan cookie */
        if(vCookieProduk != null){
            String[] vArrIsiCookie = vCookieProduk.getValue().split("#");
            
            /* kode : jumlah kode --> key : value */
            Map<String,Integer> vHMKode = new HashMap<>();
            for (String vStrKode : vArrIsiCookie) {
                if (!vHMKode.containsKey(vStrKode)){
                    vHMKode.put(vStrKode,1);
                } else {
                    vHMKode.put(vStrKode, vHMKode.get(vStrKode) + 1);
                }
            }
            
            /* obyek basisdata */
            ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
            /* iterasi map -> membuat obyek produk */
            ClsOperasiProduk oOProduk = new ClsOperasiProduk();
            Iterator it = vHMKode.entrySet().iterator();
            
            /* sekalian hitung total */
            double vTotal = 0.0;
            double vTotalIt = 0.0;
            double vHarga = 0.0;
            double vKuantitas = 0.0;
            
            while (it.hasNext()) {
                Map.Entry vKodeNilai = (Map.Entry)it.next();
                /* obyek produk */
                ClsProduk oProduk = new ClsProduk();
                /* nilai masing-masing atribut produk */
                String vKodeProduk = vKodeNilai.getKey().toString();
                String vNamaProduk = oOpsBasisdata.fAmbilSatuData("", "", "tb_resto_produk", "nama", "kode", vKodeProduk);
                String vHargaProduk = oOpsBasisdata.fAmbilSatuData("", "", "tb_resto_produk", "harga", "kode", vKodeProduk);
                String vKodeSatuan = oOpsBasisdata.fAmbilSatuData("", "", "tb_resto_produk", "kode_produk_satuan", "kode", vKodeProduk);
                String vSatuan = oOpsBasisdata.fAmbilSatuData("", "", "tb_produk_satuan", "singkatan", "kode", vKodeSatuan);
                String vPraKuantitas = vKodeNilai.getValue().toString();
                
                /* masukkan ke dalam obyek produk */
                //System.out.println(vKodeNilai.getKey().toString());
                //System.out.println(vNamaProduk);
                //System.out.println(vHargaProduk);
                //System.out.println(vSatuan);
                //System.out.println(vKodeNilai.getValue().toString());
                
                oProduk.setvPrvKode(vKodeNilai.getKey().toString());
                oProduk.setvPrvNama(vNamaProduk);
                oProduk.setvPrvHarga(vHargaProduk);
                oProduk.setvPrvSatuan(vSatuan);
                oProduk.setvPrvKuantitas(vKodeNilai.getValue().toString());
                
                /* masukkan ke dalam list */
                vArrProduk.add(oProduk);
                
                it.remove();
                
                /* total belanja */
                if(!vHargaProduk.equals("")){
                    vHarga = Double.parseDouble(vHargaProduk);
                    vKuantitas = Double.parseDouble(vPraKuantitas);
                    vTotalIt = vHarga * vKuantitas;
                    vTotal += vTotalIt;
                }
            }
            
            /* private var total */
            this.vPrvTotal = vTotal;
            
        }
        
        return this.vArrProduk;
    }
    
    public double fTotal(){
        return this.vPrvTotal;
    }
    
    
}
