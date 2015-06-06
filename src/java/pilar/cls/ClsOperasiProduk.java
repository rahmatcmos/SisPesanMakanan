package pilar.cls;

import pilar.data.clsDataProduk;
import java.util.*;

public class ClsOperasiProduk {
    
    public final List<ClsProduk> vArrProduk = new ArrayList<>();
    
    public ClsOperasiProduk(){
        
        int i = 0;
        for(String  vKode : clsDataProduk.vPubSKode){
            ClsProduk oProduk = new ClsProduk();
            oProduk.setvPrvKode(vKode);
            oProduk.setvPrvNama(clsDataProduk.vPubSNama[i]);
            oProduk.setvPrvHarga(clsDataProduk.vPubSHarga[i]);
            oProduk.setvPrvSatuan(clsDataProduk.vPubSSatuan[i]);
            /* tambahkan ke list */
            vArrProduk.add(i,oProduk);
            i += 1;
        }
    }
    
    public List<ClsProduk> fDaftarProduk(){
        return this.vArrProduk;
    }
    
    public String fNilaiAtributProduk(String vFKode, String vFAtribut){
        String vKeluaran = null;
        ClsProduk oProduk = new ClsProduk();
        
        for(ClsProduk vProduk : this.vArrProduk){
            if(vProduk.getvPrvKode().equals(vFKode)){
                oProduk = vProduk;
            }
        }
        
        switch(vFAtribut){
            case "nama":
                vKeluaran = oProduk.getvPrvNama();
                break;
            case "harga":
                vKeluaran = oProduk.getvPrvHarga();
                break;
            case "satuan":
                vKeluaran = oProduk.getvPrvSatuan();
                break;
            case "kuantitas":
                vKeluaran = oProduk.getvPrvKuantitas();
                break;
        }
        
        /* keluaran */
        //return oProduk.getvPrvHarga();
        return vKeluaran;
    }
    
}
